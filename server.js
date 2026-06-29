/* ===================================================================
 *  KNOWLEDGE GRAPH — Node.js + Express + MySQL (mysql2)
 *
 *  Server vừa phục vụ frontend tĩnh (thư mục public/) vừa cung cấp API.
 *  Giữ cùng "hợp đồng" API như bản PHP để frontend dùng lại nguyên vẹn:
 *    GET  /api?action=graph
 *    POST /api?action=saveNode | deleteNode | savePosition
 *                  | addEdge | deleteEdge | replaceAll | setup
 * =================================================================== */
const express = require('express');
const path = require('path');
const fs = require('fs');
const crypto = require('crypto');
const pool = require('./db');
const config = require('./config');

const app = express();
// Sau reverse proxy (Caddy) thì tin hop đầu để req.ip là IP thật của client.
if (config.COOKIE_SECURE) app.set('trust proxy', 1);
app.use(express.json({ limit: '5mb' }));               // parse JSON body

// ---- Helpers trả JSON thống nhất ----
const ok   = (res, data = {})        => res.json({ ok: true, ...data });
const fail = (res, msg, code = 400)  => res.status(code).json({ ok: false, error: msg });

// ===================================================================
//  XÁC THỰC ĐĂNG NHẬP — session cookie ký HMAC (không cần thư viện ngoài).
//  Username/password đặt trong .env (AUTH_USER / AUTH_PASS).
// ===================================================================
const COOKIE = 'kg_session';

// Ký / kiểm tra chuỗi bằng HMAC-SHA256 với SESSION_SECRET.
function sign(value) {
  const mac = crypto.createHmac('sha256', config.SESSION_SECRET).update(value).digest('base64url');
  return `${value}.${mac}`;
}
function unsign(signed) {
  if (typeof signed !== 'string') return null;
  const i = signed.lastIndexOf('.');
  if (i < 0) return null;
  const value = signed.slice(0, i);
  const a = Buffer.from(signed), b = Buffer.from(sign(value));
  if (a.length !== b.length || !crypto.timingSafeEqual(a, b)) return null;
  return value;                         // dạng "user|exp"
}
function makeToken(user) {
  return sign(`${user}|${Date.now() + config.SESSION_TTL_MS}`);
}
function tokenUser(signed) {            // -> username nếu token hợp lệ & chưa hết hạn, ngược lại null
  const value = unsign(signed);
  if (!value) return null;
  const [user, exp] = value.split('|');
  if (!exp || Number(exp) < Date.now()) return null;
  return user;
}
function readCookie(req, name) {
  for (const part of (req.headers.cookie || '').split(';')) {
    const i = part.indexOf('=');
    if (i > -1 && part.slice(0, i).trim() === name) return decodeURIComponent(part.slice(i + 1).trim());
  }
  return null;
}
function isAuthed(req) { return !!tokenUser(readCookie(req, COOKIE)); }
function safeEqual(a, b) {              // so sánh chống timing attack
  const ab = Buffer.from(String(a)), bb = Buffer.from(String(b));
  return ab.length === bb.length && crypto.timingSafeEqual(ab, bb);
}

// ---- Trang đăng nhập + login/logout (CÔNG KHAI, đặt trước cổng chặn) ----
app.get('/login', (req, res) => {
  if (isAuthed(req)) return res.redirect('/');
  res.sendFile(path.join(__dirname, 'public', 'login.html'));
});

// ---- Chống brute-force đăng nhập: khóa tạm theo IP sau nhiều lần sai ----
const MAX_FAILS = 5;                       // số lần sai tối đa trong cửa sổ
const WINDOW_MS = 10 * 60 * 1000;          // cửa sổ đếm: 10 phút
const LOCK_MS   = 5  * 60 * 1000;          // thời gian khóa: 5 phút
const loginFails = new Map();              // ip -> { count, first, lockUntil }

function loginLockLeft(ip) {                // số mili-giây còn bị khóa (0 = không khóa)
  const e = loginFails.get(ip);
  if (e && e.lockUntil && e.lockUntil > Date.now()) return e.lockUntil - Date.now();
  return 0;
}
function noteLoginFail(ip) {
  const now = Date.now();
  let e = loginFails.get(ip);
  if (!e || now - e.first > WINDOW_MS) e = { count: 0, first: now, lockUntil: 0 };
  e.count++;
  if (e.count >= MAX_FAILS) e.lockUntil = now + LOCK_MS;
  loginFails.set(ip, e);
}

app.post('/api/login', (req, res) => {
  const ip = req.ip || 'unknown';
  const lockLeft = loginLockLeft(ip);
  if (lockLeft > 0) {
    return fail(res, `Đăng nhập sai quá nhiều lần. Thử lại sau ${Math.ceil(lockLeft / 1000)} giây.`, 429);
  }
  const { username = '', password = '' } = req.body || {};
  if (!safeEqual(username, config.AUTH_USER) || !safeEqual(password, config.AUTH_PASS)) {
    noteLoginFail(ip);
    return fail(res, 'Sai tài khoản hoặc mật khẩu', 401);
  }
  loginFails.delete(ip);                   // đăng nhập đúng -> xóa lịch sử sai
  res.setHeader('Set-Cookie',
    `${COOKIE}=${makeToken(username)}; HttpOnly; SameSite=Lax; Path=/; Max-Age=${Math.floor(config.SESSION_TTL_MS / 1000)}` +
    (config.COOKIE_SECURE ? '; Secure' : ''));
  return ok(res);
});

app.post('/api/logout', (req, res) => {
  res.setHeader('Set-Cookie', `${COOKIE}=; HttpOnly; SameSite=Lax; Path=/; Max-Age=0`);
  return ok(res);
});

// Healthcheck cho Docker (công khai, không cần đăng nhập).
app.get('/healthz', (req, res) => res.json({ ok: true, status: 'up' }));

// ---- CỔNG CHẶN: mọi route phía dưới yêu cầu đã đăng nhập ----
app.use((req, res, next) => {
  if (isAuthed(req)) return next();
  if (req.path.startsWith('/api')) return fail(res, 'Chưa đăng nhập', 401);
  return res.redirect('/login');
});

// ---- Phục vụ frontend tĩnh (đã qua cổng chặn) ----
app.use(express.static(path.join(__dirname, 'public')));

// ---- Middleware kiểm tra token cho thao tác ghi (nếu bật API_TOKEN) ----
app.use('/api', (req, res, next) => {
  if (config.API_TOKEN && req.method === 'POST') {
    if ((req.get('X-API-Token') || '') !== config.API_TOKEN) {
      return fail(res, 'Token không hợp lệ', 401);
    }
  }
  next();
});

// ===================================================================
//  ROUTER API — phân nhánh theo ?action=
// ===================================================================
app.all('/api', async (req, res) => {
  const action = req.query.action || '';
  const body = req.body || {};

  try {
    switch (action) {

      // ---------- LẤY TOÀN BỘ GRAPH ----------
      case 'graph': {
        const [nodes] = await pool.query(
          'SELECT id,label,category,description,links,pos_x,pos_y FROM kg_nodes'
        );
        const [edges] = await pool.query(
          'SELECT id,source,target,type FROM kg_edges'
        );
        const elements = [];
        for (const r of nodes) {
          const el = { group: 'nodes', data: {
            id: r.id, label: r.label, category: r.category,
            description: r.description || '',
            links: r.links ? safeJson(r.links) : [],
          }};
          if (r.pos_x !== null && r.pos_y !== null) {
            el.position = { x: Number(r.pos_x), y: Number(r.pos_y) };
          }
          elements.push(el);
        }
        for (const r of edges) {
          elements.push({ group: 'edges', data: {
            id: r.id, source: r.source, target: r.target, type: r.type,
          }});
        }
        return ok(res, { elements });
      }

      // ---------- THÊM / SỬA NODE (UPSERT) ----------
      case 'saveNode': {
        const id = (body.id || '').trim();
        const label = (body.label || '').trim();
        if (!id || !label) return fail(res, 'Thiếu id hoặc label');
        const category = body.category || 'Frontend';
        const description = body.description || '';
        const links = JSON.stringify(Array.isArray(body.links) ? body.links : []);
        await pool.execute(
          `INSERT INTO kg_nodes (id,label,category,description,links)
           VALUES (?,?,?,?,?)
           ON DUPLICATE KEY UPDATE
             label=VALUES(label), category=VALUES(category),
             description=VALUES(description), links=VALUES(links)`,
          [id, label, category, description, links]
        );
        return ok(res);
      }

      // ---------- XÓA NODE ----------
      case 'deleteNode': {
        const id = (body.id || '').trim();
        if (!id) return fail(res, 'Thiếu id');
        await pool.execute('DELETE FROM kg_nodes WHERE id=?', [id]);
        return ok(res);
      }

      // ---------- LƯU VỊ TRÍ NODE ----------
      case 'savePosition': {
        const id = (body.id || '').trim();
        if (!id) return fail(res, 'Thiếu id');
        await pool.execute(
          'UPDATE kg_nodes SET pos_x=?, pos_y=? WHERE id=?',
          [Number(body.x) || 0, Number(body.y) || 0, id]
        );
        return ok(res);
      }

      // ---------- THÊM / SỬA EDGE (UPSERT) ----------
      case 'addEdge': {
        const id = (body.id || '').trim();
        const source = (body.source || '').trim();
        const target = (body.target || '').trim();
        const type = body.type || 'related';
        if (!id || !source || !target) return fail(res, 'Thiếu dữ liệu edge');
        await pool.execute(
          `INSERT INTO kg_edges (id,source,target,type)
           VALUES (?,?,?,?)
           ON DUPLICATE KEY UPDATE type=VALUES(type)`,
          [id, source, target, type]
        );
        return ok(res);
      }

      // ---------- XÓA EDGE ----------
      case 'deleteEdge': {
        const id = (body.id || '').trim();
        if (!id) return fail(res, 'Thiếu id');
        await pool.execute('DELETE FROM kg_edges WHERE id=?', [id]);
        return ok(res);
      }

      // ---------- THAY TOÀN BỘ (Import / Sample / Reset) ----------
      case 'replaceAll': {
        const elements = body.elements || [];
        const conn = await pool.getConnection();
        try {
          await conn.beginTransaction();
          await conn.query('DELETE FROM kg_edges');
          await conn.query('DELETE FROM kg_nodes');

          // Insert nodes trước
          for (const el of elements) {
            if (el.group !== 'nodes') continue;
            const d = el.data || {};
            const px = el.position && typeof el.position.x === 'number' ? el.position.x : null;
            const py = el.position && typeof el.position.y === 'number' ? el.position.y : null;
            await conn.execute(
              `INSERT INTO kg_nodes (id,label,category,description,links,pos_x,pos_y)
               VALUES (?,?,?,?,?,?,?)`,
              [d.id, d.label || '', d.category || 'Frontend', d.description || '',
               JSON.stringify(d.links || []), px, py]
            );
          }
          // Sau đó insert edges
          for (const el of elements) {
            if (el.group !== 'edges') continue;
            const d = el.data || {};
            await conn.execute(
              'INSERT INTO kg_edges (id,source,target,type) VALUES (?,?,?,?)',
              [d.id, d.source, d.target, d.type || 'related']
            );
          }
          await conn.commit();
          return ok(res, { count: elements.length });
        } catch (e) {
          await conn.rollback();
          return fail(res, 'Thay dữ liệu thất bại: ' + e.message, 500);
        } finally {
          conn.release();
        }
      }

      // ---------- TẠO BẢNG TỪ schema.sql ----------
      case 'setup': {
        const sql = fs.readFileSync(path.join(__dirname, 'schema.sql'), 'utf8');
        await pool.query(sql); // pool bật multipleStatements
        return ok(res, { message: 'Đã tạo bảng thành công' });
      }

      default:
        return fail(res, 'Action không hợp lệ: ' + action, 404);
    }
  } catch (e) {
    // Lỗi DB thường gặp: bảng chưa tồn tại -> gợi ý Init DB
    return fail(res, e.message, 500);
  }
});

// Parse JSON an toàn (phòng trường hợp cột links lưu chuỗi không hợp lệ)
function safeJson(str) {
  try { return JSON.parse(str); } catch { return []; }
}

app.listen(config.PORT, () => {
  console.log(`\n  🚀 Knowledge Graph chạy tại  http://localhost:${config.PORT}`);
  console.log(`     DB: ${config.DB_USER}@${config.DB_HOST}:${config.DB_PORT}/${config.DB_NAME}`);
  console.log(`     Đăng nhập: user "${config.AUTH_USER}"`);
  if (config.AUTH_USER === 'admin' && config.AUTH_PASS === 'admin')
    console.log('  ⚠️  Đang dùng tài khoản mặc định admin/admin — đặt AUTH_USER/AUTH_PASS trong .env.');
  if (!config.SESSION_SECRET_SET)
    console.log('  ⚠️  SESSION_SECRET trống — phiên sẽ mất khi restart. Đặt giá trị cố định trong .env.');
  if (!config.API_TOKEN) console.log('  ⚠️  API_TOKEN trống — nên đặt khi deploy public.\n');
});
