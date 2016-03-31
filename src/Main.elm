module Main where

import StartApp exposing (start)
import Task exposing (Task)
import Effects exposing (Effects)
import Html
import App.Demo as Demo

app : StartApp.App Demo.Model
app =
  start
    { init = Demo.init "Welcome to Elm App Boilerplate" "Happy coding! :-)"
    , view = Demo.view
    , update = Demo.update
    , inputs = []
    }

main : Signal Html.Html
main =
  app.html

port tasks : Signal (Task Effects.Never ())
port tasks =
  app.tasks
