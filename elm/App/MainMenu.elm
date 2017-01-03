module App.MainMenu exposing
  ( init, update, view
  , Model, Msg )

import Html exposing (Html)
import App.AppRoute as AppRoute
import App.Config exposing (AppConfig)
import App.Demo.DemoRoute as DemoRoute
import App.Widget.Menu as Menu exposing
  (navigationLink, parentItem)

type alias Config = Menu.Config
type alias Model = Menu.Model
type alias Msg = Menu.Msg
type alias Url = Menu.Url

menuConfig: Config
menuConfig = Menu.customConfig "MainMenu"

init: AppConfig -> (Model, Cmd Msg)
init appConfig =
  let
    routeToString = AppRoute.toString appConfig.basePath
  in
    Menu.init
      [ parentItem "Root Item"
          [ navigationLink "Home"
              (routeToString AppRoute.HomeRoute)
          , parentItem "Demo"
              [ navigationLink "Demo Overview"
                  (routeToString <| AppRoute.DemoRoute DemoRoute.DemoRoute)
              , navigationLink "Accordion Demo"
                  (routeToString <| AppRoute.DemoRoute DemoRoute.AccordionDemoRoute)
              , navigationLink "Checkbox Demo"
                  (routeToString <| AppRoute.DemoRoute DemoRoute.CheckboxDemoRoute)
              , navigationLink "Other Demo"
                  (routeToString <| AppRoute.DemoRoute DemoRoute.OtherDemoRoute)
              ]
          , parentItem "Resources"
              [ navigationLink "Fork it on GitHub"
                  "https://github.com/gkubisa/elm-app-boilerplate"
              , navigationLink "Elm Lang Website"
                  "http://elm-lang.org"
              ]
          ]
      ]

update: Msg -> Model -> (Model, Cmd Msg)
update = Menu.update

view: Model -> Url -> Html Msg
view = Menu.view menuConfig
