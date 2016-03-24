module Main where

import StartApp exposing (start)
import Task exposing (Task)
import Effects exposing (Effects)
import Html
import ElmAppBoilerplate.Page as Page

app : StartApp.App Page.Model
app =
  start
    { init = Page.init "Welcome to Elm App Boilerplate" "Happy coding! :-)"
    , view = Page.view
    , update = Page.update
    , inputs = []
    }

main : Signal Html.Html
main =
  app.html

port tasks : Signal (Task Effects.Never ())
port tasks =
  app.tasks
