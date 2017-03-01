import path from 'path'
import webpack from 'webpack'
import autoprefixer from 'autoprefixer'
import HtmlWebpackPlugin from 'html-webpack-plugin'
import ExtractTextPlugin from 'extract-text-webpack-plugin'
import WebpackStableModuleIdAndHash from 'webpack-stable-module-id-and-hash'
import dotenv from 'dotenv'

const dotenvError = dotenv.config().error

if (dotenvError) {
  throw dotenvError
}

const START = process.env.npm_lifecycle_event === 'start'
const BUILD = process.env.npm_lifecycle_event === 'build'

const jsDir = path.resolve(__dirname, 'js') + '/'
const jsTestFiles = [
  path.join(jsDir, 'tests.js'),
  /\.test.js$/
]

const config = {
  entry: './js/main.js',

  output: {
    path: './dist',
    filename: process.env.BASE_PATH + '/[name].[hash].js',
    hotUpdateChunkFilename: process.env.BASE_PATH + '/[id].[hash].hot-update.js',
    hotUpdateMainFilename: process.env.BASE_PATH + '/[hash].hot-update.json'
  },

  resolve: {
    extensions: ['', '.js', '.elm']
  },

  module: {
    noParse: /\/Main\.elm$/,
    preLoaders: [
      {
        test: /\.js$/,
        include: [jsDir],
        exclude: jsTestFiles,
        loader: 'eslint-loader'
      }
    ],
    loaders: [
      {
        test: /\.js$/,
        include: [jsDir],
        exclude: jsTestFiles,
        loader: 'babel-loader'
      },
      {
        test: /\.(png|jpg|gif|svg|ttf|otf|eot|svg|woff2?)$/,
        loader: 'url-loader?limit=8192'
      },
      {
        test: /\/Main\.elm$/,
        loader: `${START ? 'elm-hot!' : ''}elm-webpack?verbose=true&warn=true${START ? '&debug=true' : ''}&pathToMake=node_modules/.bin/elm-make`
      },
      {
        test: /\/Stylesheets\.elm$/,
        loader: "style!css!elm-css-webpack"
      }
    ]
  },

  plugins: [
    new HtmlWebpackPlugin({
      template: 'html/index.html',
      inject: 'body',
      minify: require('./html-minifier.json')
    }),
    new webpack.DefinePlugin({
      '__CONFIG__': {
        basePath: JSON.stringify(process.env.BASE_PATH)
      }
    })
  ],

  postcss: [ autoprefixer({ browsers: ['last 2 versions']} ) ],

  eslint: {
    failOnWarning: true,
    failOnError: true
  },

  devServer: {
    stats: 'errors-only',
    historyApiFallback: true
  }
}

if (START) {
  config.module.loaders.push({ test: /\.less$/, loader: 'style!css!postcss-loader!less' })
}
if (BUILD) {
  config.output.filename = config.output.filename.replace('[hash]', '[chunkhash]')

  // put styles in a separate file
  config.module.loaders.push({ test: /\.less$/, loader: ExtractTextPlugin.extract('style-loader', 'css!postcss-loader!less') })
  config.plugins.push(new ExtractTextPlugin(process.env.BASE_PATH + '/[name].[contenthash].css'))

  // ensure the JS file 'chunkhash' does not change when only the styles change
  config.plugins.push(new WebpackStableModuleIdAndHash())

  // disable UglifyJs warnings
  config.plugins.push(new webpack.optimize.UglifyJsPlugin({compress: {warnings: false }}))
}

export default config
