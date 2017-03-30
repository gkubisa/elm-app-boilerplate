import path from 'path'
import webpack from 'webpack'
import autoprefixer from 'autoprefixer'
import HtmlWebpackPlugin from 'html-webpack-plugin'
import ExtractTextPlugin from 'extract-text-webpack-plugin'
import dotenv from 'dotenv'

const dotenvError = dotenv.config().error

if (dotenvError) {
  throw dotenvError
}

const isDev = process.env.npm_lifecycle_event === 'start'
const jsDir = path.resolve('js') + '/'
const jsTestFiles = [
  path.join(jsDir, 'tests.js'),
  /\.test.js$/
]

const config = {
  entry: './js/main.js',

  output: {
    path: path.resolve('dist'),
    publicPath: `${process.env.BASE_PATH}/`,
    filename: isDev ? '[name].js' : '[name].[chunkhash].js'
  },

  resolve: {
    extensions: ['.js', '.elm']
  },

  module: {
    noParse: /\/Main\.elm$/,
    rules: [
      {
        enforce: 'pre',
        test: /\.js$/,
        include: [jsDir],
        exclude: jsTestFiles,
        loader: 'eslint-loader'
      },
      {
        test: /\.js$/,
        include: [jsDir],
        exclude: jsTestFiles,
        loader: 'babel-loader'
      },
      {
        test: /\.(png|jpg|gif|svg|ttf|otf|eot|svg|woff2?)$/,
        loader: 'url-loader',
        options: {
          limit: 8192
        }
      },
      {
        test: /\/Main\.elm$/,
        use: [
          {
            loader: isDev ? 'elm-hot-loader' : 'noop-loader'
          },
          {
            loader: 'elm-webpack-loader',
            options: {
              verbose: true,
              warn: true,
              debug: isDev,
              pathToMake: 'node_modules/.bin/elm-make'
            }
          }
        ]
      },
      {
        test: /\/Stylesheets\.elm$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            'css-loader',
            'postcss-loader',
            'elm-css-webpack-loader'
          ]
        })
      }
    ]
  },

  plugins: [
    new webpack.LoaderOptionsPlugin({
      options: {
        postcss: [ autoprefixer({ browsers: ['last 2 versions']} ) ],

        eslint: {
          failOnWarning: true,
          failOnError: true
        }
      }
    }),
    new HtmlWebpackPlugin({
      template: 'html/index.html',
      inject: 'body',
      minify: require('./html-minifier.json')
    }),
    new webpack.DefinePlugin({
      '__CONFIG__': {
        basePath: JSON.stringify(process.env.BASE_PATH)
      }
    }),
    new ExtractTextPlugin({
      disable: isDev,
      filename: `[name].[contenthash].css`
    })
  ],

  devServer: {
    stats: 'errors-only',
    historyApiFallback: true
  }
}

export default config
