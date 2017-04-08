module Main exposing (main)

import Navigation
import App.Section.Root as Root
import App.Etc.Config exposing (AppConfig)


{-| Entry point to the application.
-}
main : Program AppConfig Root.Model Root.Msg
main =
    Navigation.programWithFlags Root.locationChanged
        { init = Root.init
        , view = Root.view
        , update = Root.update
        , subscriptions = Root.subscriptions
        }
