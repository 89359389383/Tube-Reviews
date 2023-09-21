const sqlite3 = require('sqlite3');

// データベースとの接続
const db = new sqlite3.Database('./db/favorites.db');  // 既存のパスを使用

// データベースのエラーハンドリング
db.on('error', (error) => {
  console.error("Database Error:", error.message);
});

module.exports = db;

