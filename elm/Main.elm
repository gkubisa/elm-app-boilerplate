import Navigation
import App.App as App

{-| Entry point to the application.
-}

main : Program Never
main =
  Navigation.program App.urlParser
    { init = App.init
    , view = App.view
    , update = App.update
    , urlUpdate = App.urlUpdate
    , subscriptions = App.subscriptions
    }
