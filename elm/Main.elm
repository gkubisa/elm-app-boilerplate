module Main exposing (main)

import Navigation
import App.App as App
import App.Config exposing (AppConfig)

{-| Entry point to the application.
-}

main : Program AppConfig App.Model App.Msg
main =
  Navigation.programWithFlags App.locationChanged
    { init = App.init
    , view = App.view
    , update = App.update
    , subscriptions = App.subscriptions
    }
