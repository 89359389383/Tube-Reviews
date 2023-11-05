const { environment } = require('@rails/webpacker');
const webpack = require('webpack');

// ProvidePluginを追加してjQueryがグローバルに利用できるようにする
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.jQuery': 'jquery',
  })
);

// Sass（SCSS）ファイルの処理を追加
environment.loaders.append('sass', {
  test: /\.scss$/,
  use: [
    'style-loader', // JSの文字列から`style`ノードを作成
    'css-loader',   // CSSをCommonJSに変換
    'sass-loader'   // SassをCSSにコンパイル
  ]
});

module.exports = environment;

