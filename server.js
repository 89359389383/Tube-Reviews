const express = require('express');
const bodyParser = require('body-parser');
const favoritesRoute = require('./favoritesRoute');

const app = express();
const PORT = 8080;
const IP = '0.0.0.0';

// database.jsからデータベースの接続をインポート
const db = require('./database.js');

// body-parserを使ってJSONリクエストを解析する
app.use(bodyParser.json());

// favoritesRouteを統合
app.use(favoritesRoute);

// /update-memo エンドポイントの追加
app.post('/update-memo', (req, res) => {
    const { videoId, memo } = req.body;

    if (!videoId || !memo) {
        return res.status(400).json({ error: 'Video ID and memo are required' });
    }

    const query = "UPDATE favorites SET memo = ? WHERE id = ?";  // <-- この行を修正
    db.run(query, [memo, videoId], function(err) {
        if (err) {
            return res.status(500).json({ error: 'Database error', details: err });
        }
        res.json({ success: true });
    });
});

app.listen(PORT, IP, () => {
    console.log(`Server is running on http://${IP}:${PORT}`);
});
