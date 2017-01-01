import './polyfill/origin'
import '../styles/Main.less'
import Elm from '../elm/Main'

Elm.Main.embed(document.getElementById('elm'))
