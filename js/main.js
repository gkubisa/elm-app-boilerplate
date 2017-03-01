import './polyfill/origin'
import '../styles/Main.less'
import Elm from '../elm/Main'
import '../elm/Stylesheets'

Elm.Main.embed(document.getElementById('elm'), __CONFIG__)
