module App.Widget.MainMenu.Css exposing (css)

import App.Etc.Style exposing (..)
import App.Widget.Menu.Style exposing (CssClass(..))
import App.Widget.MainMenu.Style exposing (namespaceName)
import Css exposing (..)
import Css.Namespace exposing (namespace)


css =
    (stylesheet << namespace namespaceName)
        [ class Menu
            [ backgroundColor primaryColor
            , margin zero
            , padding zero
            ]
        , class Menu_List
            [ display none
            , margin zero
            , padding4 zero zero zero (Css.rem 1)
            ]
        , class (Menu_List_level 1)
            [ display block
            , padding zero
            ]
        , class (Menu_List_level 2)
            [ display block
            , padding zero
            , after
                [ property "content" "''"
                , property "clear" "both"
                , display block
                ]
            ]
        , class (Menu_List_level 3)
            [ padding zero
            , width zero
            ]
        , class Menu_List_expanded
            [ display block
            ]
        , class Menu_Item
            [ listStyle none
            ]
        , class (Menu_Item_level 2)
            [ float left
            ]
        , class Menu_Content
            [ backgroundColor transparent
            , border zero
            , padding2 (Css.rem 0.6) (Css.rem 0.4)
            , display inlineBlock
            , textDecoration none
            , color textPrimaryColor
            , whiteSpace noWrap
            , hover
                [ backgroundColor darkPrimaryColor
                ]
            , focus
                -- causes the outline to display on top of the other items
                [ position relative
                ]
            ]
        , class (Menu_Content_level 1)
            [ display none
            ]
        , class Menu_Content_active
            [ backgroundColor darkPrimaryColor
            ]
        ]
