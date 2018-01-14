module App.Widget.Menu.Style exposing (..)

import Html.CssHelpers exposing (Namespace, withNamespace)


type CssClass
    = Menu
    | Menu_List
    | Menu_List_level Int
    | Menu_List_expanded
    | Menu_Item
    | Menu_Item_level Int
    | Menu_Content
    | Menu_Content_level Int
    | Menu_Content_active


namespaceName : String
namespaceName =
    "w"


namespace : Namespace String CssClass Never msg
namespace =
    withNamespace namespaceName
