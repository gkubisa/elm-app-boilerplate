const path = require('path')
const merge = require('webpack-merge')
const HtmlWebpackPlugin = require('html-webpack-plugin')

const config = {
  entry: path.resolve(__dirname, 'scripts/main.js' ),

  resolve: {
    modulesDirectories: ['node_modules'],
    extensions:         ['', '.js', '.elm']
  },

  module: {
    noParse: /\.elm$/,
    loaders: [
      { test: /\.less$/, loader: 'style!css!less' },
      { test: /\.(png|jpg|gif|svg)$/, loader: 'url-loader?limit=8192' }
    ]
  },

  plugins: [
    new HtmlWebpackPlugin({
      template: 'html/index.html',
      inject:   'body'
    })
  ]
}

if (process.env.npm_lifecycle_event === 'start') { // npm start
  module.exports = merge(config, {
    module: {
      loaders: [ {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-hot!elm-webpack'
      } ]
    }
  })

} else { // npm run build
  module.exports = merge(config, {

  })
}
