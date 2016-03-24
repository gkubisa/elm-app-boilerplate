module ElmAppBoilerplate.Page
  ( init
  , update
  , view
  , Model
  ) where
{-| A simple module for displaying an HTML page with a heading and body. -}

import Html exposing (Html, text, h1, section, p)
import Effects exposing (Effects)

type alias Model =
  { heading: String
  , body: String
  }

init : String -> String -> (Model, Effects a)
init heading body =
  ( { heading = heading
    , body = body
    }
  , Effects.none
  )

update : a -> Model -> (Model, Effects a)
update action model =
  ( model, Effects.none )

view : address -> Model -> Html
view address model = section []
  [ h1 [] [ text model.heading ]
  , p [] [ text model.body ]
  ]
