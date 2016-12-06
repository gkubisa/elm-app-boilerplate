module App.MainMenu exposing
  ( init, update, view
  , Model, Msg )

import Html exposing (Html)
import App.AppRoute as AppRoute
import App.Demo.DemoRoute as DemoRoute
import App.Widget.Menu as Menu exposing
  (createMenu, createNavigationLink, createParentItem)

type alias Model = Menu.Model
type alias Msg = Menu.Msg

init: (Menu.Model, Cmd Menu.Msg)
init =
  let
    menu =
      createMenu
        [ createParentItem "Root Item"
            [ createNavigationLink "Home"
                (AppRoute.toString AppRoute.HomeRoute)
            , createParentItem "Demo"
                [ createNavigationLink "Overview"
                    (AppRoute.toString <| AppRoute.DemoRoute DemoRoute.DemoRoute)
                , createNavigationLink "Accordion Demo"
                    (AppRoute.toString <| AppRoute.DemoRoute DemoRoute.AccordionDemoRoute)
                , createNavigationLink "Checkbox Demo"
                    (AppRoute.toString <| AppRoute.DemoRoute DemoRoute.CheckboxDemoRoute)
                , createNavigationLink "Other Demos"
                    (AppRoute.toString <| AppRoute.DemoRoute DemoRoute.OtherDemoRoute)
                ]
            , createParentItem "Resources"
                [ createNavigationLink "elm-app-boilerplate on GitHub"
                    "https://github.com/gkubisa/elm-app-boilerplate"
                , createNavigationLink "Elm Lang Website"
                    "http://elm-lang.org"
                ]
            ]
        ]
  in
    Menu.init menu

update: Menu.Msg -> Menu.Model -> (Menu.Model, Cmd Menu.Msg)
update = Menu.update

view: Menu.Model -> Menu.Url -> Html Menu.Msg
view = Menu.view Menu.defaultConfig
