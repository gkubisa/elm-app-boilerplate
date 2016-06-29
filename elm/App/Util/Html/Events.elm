module App.Util.Html.Events exposing
  (onClick)

import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import Json.Decode as Json

{-| The same as `Html.Events.onClick` but prevents the default action.
-}
onClick: msg -> Attribute msg
onClick msg =
  let
    options =
      { preventDefault = True
      , stopPropagation = False
      }
  in
    onWithOptions "click" options (Json.succeed msg)
