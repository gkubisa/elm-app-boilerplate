import './polyfill/origin'
import './workaround/webpack-hot-loader'
import '../styles/Main.less'
import Elm from '../elm/Main'

Elm.Main.embed(document.getElementById('elm'))
