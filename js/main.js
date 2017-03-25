import './polyfill/origin'
import '../elm/Stylesheets'
import Elm from '../elm/Main'

Elm.Main.embed(document.getElementById('elm'), __CONFIG__)
