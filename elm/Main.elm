import Html.App
import App.Demo as Demo

main : Program Never
main =
  Html.App.program
    { init = Demo.init
    , view = Demo.view
    , update = Demo.update
    , subscriptions = Demo.subscriptions
    }
