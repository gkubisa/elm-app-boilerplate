module ElmAppBoilerplate.Page
  ( init
  , update
  , view
  , Model
  ) where
{-| A simple module for displaying an HTML page with a heading and body.
It also contains a small demo of Semantic UI, which demonstrates that the
library's JavaScript works properly on the content which is dynamically
added and removed. -}

import Html exposing (Html, text, h1, h2, h3, section, p, button)
import Html.Events exposing (onClick)
import Effects exposing (Effects)
import Signal

type Action = ShowDemo | HideDemo

type alias Model =
  { heading: String
  , body: String
  , demoVisible: Bool
  }

init : String -> String -> (Model, Effects a)
init heading body =
  noFx { heading = heading
    , body = body
    , demoVisible = False
    }

update : Action -> Model -> (Model, Effects a)
update action model =
  case action of
    ShowDemo -> noFx <| showDemo model
    HideDemo -> noFx <| hideDemo model

view : Signal.Address Action -> Model -> Html
view address model =
  section []
    [ h1 [] [ text model.heading ]
    , p [] [ text model.body ]
    , viewDemo address model
    ]

viewDemo : Signal.Address Action -> Model -> Html
viewDemo address model =
  section [] <|
    [ h2 []
      [ text "Semantic UI Demo" ]
    , p []
      [ text """
          The purpose of this demo is to show that the Semantic UI's JavaScript
          works properly when the HTML content is added and removed dynamically.
          """ ]
    , button [ onClick address (demoAction model) ]
      [ text << actionLabel << demoAction <| model ]
    ]
      `List.append`
        if model.demoVisible
          then [viewDemoContent address model]
          else []

viewDemoContent : Signal.Address Action -> Model -> Html
viewDemoContent address model =
  section []
    [ h3 [] [ text "Semantic UI Demo Content" ]
    , p [] [ text "Some content." ]
    ]

noFx : Model -> (Model, Effects a)
noFx model =
  (model, Effects.none)

showDemo : Model -> Model
showDemo model =
  { model | demoVisible = True }

hideDemo : Model -> Model
hideDemo model =
  { model | demoVisible = False }

demoAction : Model -> Action
demoAction model =
  if model.demoVisible
    then HideDemo
    else ShowDemo

actionLabel : Action -> String
actionLabel action =
  case action of
    ShowDemo -> "Show Demo"
    HideDemo -> "Hide Demo"
