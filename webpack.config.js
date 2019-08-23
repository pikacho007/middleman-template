var webpack = require('webpack');
var { CleanWebpackPlugin } = require('clean-webpack-plugin');

module.exports = {
  entry: {
    common: './source/script/common.js'
  },

  resolve: {
    modules: [__dirname + '/source/script', 'node_modules'],
    extensions: ['.js','.jsx']
  },

  output: {
    path: __dirname + '/.tmp/dist',
    filename: 'script/[name].js',
  },

  module: {
    rules: [
      {
        test: /\.js[x]?$/,
        exclude: /node_modules|\.tmp|vendor/,
        loader: 'babel-loader'
      },
      {
        test: /\.json$/,
        exclude: /node_modules/,
        loader: 'json-loader'
      }
    ],
  },

  node: {
    console: true,
  },

  plugins: [
    new CleanWebpackPlugin({cleanOnceBeforeBuildPatterns: '.tmp/*'}),
    // Declare Global variables
    // new webpack.ProvidePlugin({
    //   $: 'jquery',
    //   jQuery: 'jquery',
    //   'window.jQuery': 'jquery',
    //   Cookies: 'js-cookie',
    // }),
  ],
};
