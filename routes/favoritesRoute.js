const express = require('express');
const router = express.Router();
const db = require('./db'); // データベース接続のサンプル

router.get('/api/favorites', async (req, res, next) => {
    try {
        const results = await db.getFavorites(); // お気に入り動画のデータを取得
        res.json(results);
    } catch (error) {
        next(error); // エラーが発生した場合、エラーハンドリングミドルウェアに移行します
    }
});

module.exports = router;
