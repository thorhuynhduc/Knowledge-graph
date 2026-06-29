/* ===================================================================
 *  KẾT NỐI MYSQL — connection pool dùng chung (mysql2/promise)
 * =================================================================== */
const mysql = require('mysql2/promise');
const config = require('./config');

const pool = mysql.createPool({
  host: config.DB_HOST,
  port: config.DB_PORT,
  user: config.DB_USER,
  password: config.DB_PASS,
  database: config.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  charset: 'utf8mb4',          // hỗ trợ tiếng Việt / emoji
  multipleStatements: true,    // cần để chạy schema.sql trong action 'setup'
});

module.exports = pool;
