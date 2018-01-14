const webpack = require('webpack')
const path = require('path')

const jsDir = path.resolve('js') + '/'
const jsTestFiles = [
  path.join(jsDir, 'tests.js'),
  /\.test.js$/
]


module.exports = function (config) {
  config.set({
    // base path used to resolve all patterns
    basePath: '',

    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['mocha'],

    // list of files/patterns to load in the browser
    files: [
      {pattern: 'js/tests.js', watched: false}
    ],

    // files to exclude
    exclude: [],

    plugins: [
      require('karma-coverage'),
      require('karma-phantomjs-launcher'),
      require('karma-mocha'),
      require('karma-mocha-reporter'),
      require('karma-sourcemap-loader'),
      require('karma-webpack')
    ],

    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {'js/tests.js': ['webpack', 'sourcemap']},

    webpack: {
      devtool: 'inline-source-map',
      module: {
        rules: [
          // ES6
          {
            test: /\.js$/,
            include: [jsDir],
            loader: 'babel-loader'
          },

          // eslint
          {
            enforce: 'pre',
            test: /\.js$/,
            include: jsTestFiles,
            loader: 'eslint-loader',
            options: {
              configFile: '.eslintrc.test.yml'
            }
          },
          {
            enforce: 'pre',
            test: /\.js$/,
            include: [jsDir],
            exclude: jsTestFiles,
            loader: 'eslint-loader',
            options: {
              configFile: '.eslintrc.yml'
            }
          },

          // don't bother loading these properly for unit tests
          {
            test: /\.(png|jpg|gif|svg|ttf|otf|eot|svg|woff2?|less)$/,
            loader: 'raw-loader'
          }
        ]
      },
      plugins: [
        new webpack.LoaderOptionsPlugin({
          options: {
            eslint: {
              failOnWarning: true,
              failOnError: true
            }
          }
        })
      ]
    },

    webpackServer: {
      noInfo: true // prevent console spamming when running in Karma!
    },

    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['mocha', 'coverage'],

    // web server port
    port: 9876,

    // enable colors in the output
    colors: true,

    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,

    // toggle whether to watch files and rerun tests upon incurring changes
    autoWatch: true,

    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['PhantomJS'],

    // if true, Karma runs tests once and exits
    singleRun: false
  })
}
