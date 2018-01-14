import './polyfill/origin'
import '../src/Stylesheets'
import Elm from '../src/Main'

Elm.Main.embed(document.getElementById('elm'), __CONFIG__)
