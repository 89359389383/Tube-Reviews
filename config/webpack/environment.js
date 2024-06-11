const { environment } = require('@rails/webpacker')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')

// Babel ローダーの設定を更新
const babelLoader = environment.loaders.get('babel')
babelLoader.test = /\.(js|jsx|mjs|cjs)$/
babelLoader.exclude = /node_modules/
environment.loaders.prepend('babel', babelLoader)

// Sass ローダーの設定を追加
const sassLoader = {
  test: /\.(scss|sass)$/,
  use: [
    process.env.NODE_ENV !== 'production' ? 'style-loader' : MiniCssExtractPlugin.loader,
    'css-loader',
    {
      loader: 'sass-loader',
      options: {
        implementation: require('sass')
      }
    }
  ]
}
environment.loaders.append('sass', sassLoader)

// CSS ローダーの設定を追加
const cssLoader = {
  test: /\.css$/,
  use: [
    process.env.NODE_ENV !== 'production' ? 'style-loader' : MiniCssExtractPlugin.loader,
    'css-loader'
  ]
}
environment.loaders.append('css', cssLoader)

// プラグインの設定を追加
environment.plugins.append('MiniCssExtractPlugin', new MiniCssExtractPlugin({
  filename: '[name]-[contenthash].css',
  chunkFilename: '[id]-[contenthash].css'
}))

module.exports = environment
