import Navigation
import App.App as App
import App.AppRoute as AppRoute

{-| Entry point to the application.
-}

main : Program Never
main =
  Navigation.program AppRoute.urlParser
    { init = App.init
    , view = App.view
    , update = App.update
    , urlUpdate = App.urlUpdate
    , subscriptions = App.subscriptions
    }
