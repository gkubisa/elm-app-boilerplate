module Main exposing (main)

import Navigation
import App.App as App

{-| Entry point to the application.
-}

main : Program Never App.Model App.Msg
main =
  Navigation.program App.locationChanged
    { init = App.init
    , view = App.view
    , update = App.update
    , subscriptions = App.subscriptions
    }
