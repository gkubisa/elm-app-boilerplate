module App.MainMenu exposing
  ( init, update, urlUpdate, view
  , Model, Msg )

import Html exposing (Html)
import App.AppRoute as AppRoute exposing (Route)
import App.Demo.DemoRoute as DemoRoute
import App.Widget.Menu as Menu exposing
  (createMenu, createInternalLink, createExternalLink, createParentItem)

type alias Model = Menu.Model
type alias Msg = Menu.Msg

init: Route -> (Menu.Model, Cmd Menu.Msg)
init route =
  let
    menu =
      createMenu
        [ createParentItem "Root Item"
            [ createInternalLink "Home"
                (AppRoute.HomeRoute)
            , createParentItem "Demo"
                [ createInternalLink "Overview"
                    (AppRoute.DemoRoute DemoRoute.DemoRoute)
                , createInternalLink "Accordion Demo"
                    (AppRoute.DemoRoute DemoRoute.AccordionDemoRoute)
                , createInternalLink "Checkbox Demo"
                    (AppRoute.DemoRoute DemoRoute.CheckboxDemoRoute)
                , createInternalLink "Other Demos"
                    (AppRoute.DemoRoute DemoRoute.OtherDemoRoute)
                ]
            , createParentItem "Resources"
                [ createExternalLink "elm-app-boilerplate on GitHub"
                    "https://github.com/gkubisa/elm-app-boilerplate"
                , createExternalLink "Elm Lang Website"
                    "http://elm-lang.org"
                ]
            ]
        ]
  in
    Menu.init route menu

update: Menu.Msg -> Menu.Model -> (Menu.Model, Cmd Menu.Msg)
update = Menu.update

urlUpdate: Route -> Menu.Model -> (Menu.Model, Cmd Menu.Msg)
urlUpdate = Menu.urlUpdate

view: Menu.Model -> Html Menu.Msg
view = Menu.view
