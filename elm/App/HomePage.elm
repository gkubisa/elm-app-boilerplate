module App.HomePage exposing
  ( init, view
  , Model, Msg
  )

import Html exposing ( Html, h1, text )

type alias Model =
  {
  }

type Msg =
  Noop

init: (Model, Cmd Msg)
init =
  ( {}
  , Cmd.none
  )

view: Model -> Html Msg
view model =
  h1 []
    [ text "Welcome to elm-app-boilerplate!" ]
