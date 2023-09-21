// errorHandler.js
module.exports = function errorHandler(err, req, res, next) {
    console.error(err.stack); // サーバーログにエラースタックを出力
    res.status(500).json({ error: 'Internal Server Error' }); // エラーメッセージをJSON形式でレスポンスとして返す
};
