module App.NotFoundPage exposing
  ( init, view
  , Model, Msg
  )

import Html exposing (Html, section, h1, p, text)
import Navigation exposing (Location, modifyUrl)
import Erl

type Model = Model
  { location: Location
  }

type Msg =
  Noop

init: Location -> (Model, Cmd Msg)
init location =
  let
    model =
      { location = location
      }

    parsedUrl = Erl.parse location.href

    -- try the URL with the trailing slash, too
    cmd =
      if parsedUrl.hasTrailingSlash then
        Cmd.none
      else
        modifyUrl << Erl.toString <| { parsedUrl | hasTrailingSlash = True }
  in
    (Model model, cmd)

view: Model -> Html Msg
view (Model model) =
  section []
    [ h1 []
        [ text "Not Found" ]
    , p []
        [ text "Sorry, nothing here." ]
    ]
