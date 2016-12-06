module App.MainMenu exposing
  ( init, update, view
  , Model, Msg )

import Html exposing (Html)
import App.AppRoute as AppRoute
import App.Demo.DemoRoute as DemoRoute
import App.Widget.Menu as Menu exposing
  (navigationLink, parentItem)

type alias Model = Menu.Model
type alias Msg = Menu.Msg

init: (Menu.Model, Cmd Menu.Msg)
init =
  Menu.init
    [ parentItem "Root Item"
        [ navigationLink "Home"
            (AppRoute.toString AppRoute.HomeRoute)
        , parentItem "Demo"
            [ navigationLink "Overview"
                (AppRoute.toString <| AppRoute.DemoRoute DemoRoute.DemoRoute)
            , navigationLink "Accordion Demo"
                (AppRoute.toString <| AppRoute.DemoRoute DemoRoute.AccordionDemoRoute)
            , navigationLink "Checkbox Demo"
                (AppRoute.toString <| AppRoute.DemoRoute DemoRoute.CheckboxDemoRoute)
            , navigationLink "Other Demos"
                (AppRoute.toString <| AppRoute.DemoRoute DemoRoute.OtherDemoRoute)
            ]
        , parentItem "Resources"
            [ navigationLink "elm-app-boilerplate on GitHub"
                "https://github.com/gkubisa/elm-app-boilerplate"
            , navigationLink "Elm Lang Website"
                "http://elm-lang.org"
            ]
        ]
    ]

update: Menu.Msg -> Menu.Model -> (Menu.Model, Cmd Menu.Msg)
update = Menu.update

view: Menu.Model -> Menu.Url -> Html Menu.Msg
view = Menu.view Menu.defaultConfig
