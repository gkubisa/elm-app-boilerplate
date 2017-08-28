module App.Widget.MainMenu.Style exposing (..)

import App.Widget.Menu.Style exposing (CssClass)
import Html.CssHelpers exposing (Namespace, withNamespace)


namespaceName : String
namespaceName =
    "wMain"


namespace : Namespace String CssClass Never msg
namespace =
    withNamespace namespaceName
