module Main where

import StartApp exposing (start)
import Task exposing (Task)
import Effects exposing (Effects)
import Html

app : StartApp.App String
app =
  start
    { init = ("Elm App Boilerplate", Effects.none)
    , view = (\address model -> Html.text model)
    , update = (\action model -> (model, Effects.none))
    , inputs = []
    }

main : Signal Html.Html
main =
  app.html

port tasks : Signal (Task Effects.Never ())
port tasks =
  app.tasks
