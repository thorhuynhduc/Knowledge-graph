/* ===================================================================
 *  CẤU HÌNH — đọc từ biến môi trường, có giá trị mặc định.
 *  Bạn có thể sửa trực tiếp ở đây HOẶC tạo file .env (xem README).
 * =================================================================== */
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
};
