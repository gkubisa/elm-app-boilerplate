module App.Section.Root.Css exposing (css)

import App.Etc.Style exposing (..)
import App.Section.Root.Style exposing (CssClass(..), namespaceName)
import Css exposing (..)
import Css.Elements exposing (h1, a)
import Css.Namespace exposing (namespace)


css =
    (stylesheet << namespace namespaceName)
        [ everything
            [ focus
                [ outline3 (Css.rem 0.125) solid accentColor
                ]
            ]
        , class Root
            [ minWidth screen_xx_small
            ]
        , class Root_Header
            [ backgroundColor primaryColor
            ]
        , class Root_Heading
            [ fontSize font_large
            , lineHeight (num 2)
            , textAlign center
            , margin zero
            , color textPrimaryColor
            , backgroundColor darkPrimaryColor
            ]
        , class Root_Title
            [ color inherit
            , textDecoration none
            ]
        , class Root_Navigation
            []
        , class Root_Main
            [ padding2 zero (Css.rem 0.4)
            , color primaryTextColor
            , descendants
                [ h1
                    [ fontSize font_xx_large
                    ]
                , a
                    [ color secondaryTextColor
                    ]
                ]
            ]
        , class Root_Footer
            [ padding2 (Css.rem 1) (Css.rem 0.4)
            , backgroundColor primaryColor
            , color textPrimaryColor
            , descendants
                [ a
                    [ color inherit
                    ]
                ]
            ]
        ]
