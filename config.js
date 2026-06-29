/* ===================================================================
 *  CẤU HÌNH — đọc từ biến môi trường, có giá trị mặc định.
 *  Bạn có thể sửa trực tiếp ở đây HOẶC tạo file .env (xem README).
 * =================================================================== */
const crypto = require('crypto');

module.exports = {
  DB_HOST: process.env.DB_HOST || 'localhost',
  DB_PORT: Number(process.env.DB_PORT) || 3306,
  DB_USER: process.env.DB_USER || 'root',
  DB_PASS: process.env.DB_PASS || '',
  DB_NAME: process.env.DB_NAME || 'knowledge_graph',

  PORT: Number(process.env.PORT) || 3000,

  // Bảo mật (tùy chọn): nếu khác '' thì mọi request ghi (POST) phải
  // gửi header  X-API-Token  khớp giá trị này.
  API_TOKEN: process.env.API_TOKEN || '',

  // --- Đăng nhập (bắt buộc) — đặt trong .env ---
  AUTH_USER: process.env.AUTH_USER || 'admin',
  AUTH_PASS: process.env.AUTH_PASS || 'admin',

  // Khóa ký cookie phiên. Nên đặt SESSION_SECRET cố định trong .env;
  // nếu để trống sẽ tạo tạm khi khởi động (mọi người bị đăng xuất khi server restart).
  SESSION_SECRET: process.env.SESSION_SECRET || crypto.randomBytes(32).toString('hex'),
  SESSION_SECRET_SET: !!process.env.SESSION_SECRET,
  // Thời hạn phiên (giờ) -> đổi ra ms.
  SESSION_TTL_MS: (Number(process.env.SESSION_TTL_HOURS) || 168) * 3600 * 1000,
  // Đặt true khi chạy sau HTTPS (vd: Caddy) để cookie chỉ gửi qua https.
  COOKIE_SECURE: process.env.COOKIE_SECURE === 'true',
};
