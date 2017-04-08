module App.Widget.MainMenu
    exposing
        ( init
        , update
        , view
        , Model
        , Msg
        )

import Html exposing (Html)
import App.Section.Root.Route as RootRoute
import App.Widget.MainMenu.Style exposing (namespace)
import App.Etc.Config exposing (AppConfig)
import App.Section.Demo.Route as DemoRoute
import App.Widget.Menu as Menu exposing (navigationLink, parentItem)


type alias Config =
    Menu.Config


type alias Model =
    Menu.Model


type alias Msg =
    Menu.Msg


type alias Url =
    Menu.Url


menuConfig : Config
menuConfig =
    Menu.customConfig namespace


init : AppConfig -> ( Model, Cmd Msg )
init appConfig =
    let
        routeToString =
            RootRoute.toString appConfig.basePath
    in
        Menu.init
            [ parentItem "Root Item"
                [ navigationLink "Home"
                    (routeToString RootRoute.HomeRoute)
                , parentItem "Demo"
                    [ navigationLink "Demo Overview"
                        (routeToString <| RootRoute.DemoRoute DemoRoute.DemoRoute)
                    , navigationLink "Accordion Demo"
                        (routeToString <| RootRoute.DemoRoute DemoRoute.AccordionDemoRoute)
                    , navigationLink "Checkbox Demo"
                        (routeToString <| RootRoute.DemoRoute DemoRoute.CheckboxDemoRoute)
                    , navigationLink "Other Demo"
                        (routeToString <| RootRoute.DemoRoute DemoRoute.OtherDemoRoute)
                    ]
                , parentItem "Resources"
                    [ navigationLink "Fork it on GitHub"
                        "https://github.com/gkubisa/elm-app-boilerplate"
                    , navigationLink "Elm Lang Website"
                        "http://elm-lang.org"
                    ]
                ]
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update =
    Menu.update


view : Model -> Url -> Html Msg
view =
    Menu.view menuConfig
