module App.Section.Root
    exposing
        ( Model
        , Msg
        , init
        , update
        , view
        , subscriptions
        , locationChanged
        )

{-| The main application component. Handles the top level routing.
-}

import App.Etc.Config exposing (AppConfig)
import App.Page.Home as HomePage
import App.Page.NotFound as NotFoundPage
import App.Section.Demo as Demo
import App.Section.Root.Route as RootRoute exposing (Route(..), onNavigate)
import App.Section.Root.Style as Style
import App.Widget.MainMenu as MainMenu
import Html exposing (div, header, footer, main_, section, nav, h1, h2, a, text, Html)
import Html.Attributes exposing (href)
import Html.Lazy exposing (lazy, lazy2)
import Navigation exposing (Location, newUrl)
import Tuple2 exposing (mapEach, mapSecond)
import UrlParser


class : a -> Html.Attribute msg
class =
    List.singleton >> .class Style.namespace


type Model
    = Model
        { routeModel : RouteModel
        , mainMenu : MainMenu.Model
        , location : Location
        , appConfig : AppConfig
        }


type RouteModel
    = HomeModel HomePage.Model
    | DemoModel Demo.Model
    | NotFoundModel NotFoundPage.Model


type Msg
    = HomePageMsg HomePage.Msg
    | DemoPageMsg Demo.Msg
    | NotFoundPageMsg NotFoundPage.Msg
    | MainMenuMsg MainMenu.Msg
    | Navigate String
    | LocationChanged Location


locationChanged : Location -> Msg
locationChanged location =
    LocationChanged location


init : AppConfig -> Location -> ( Model, Cmd Msg )
init appConfig location =
    let
        parser =
            RootRoute.pathnameParser appConfig.basePath

        maybeRoute =
            UrlParser.parsePath parser location

        ( routeModel, routeCmd ) =
            case maybeRoute of
                Just route ->
                    case route of
                        HomeRoute ->
                            mapHome <| HomePage.init

                        DemoRoute demoRoute ->
                            mapDemo <| Demo.init demoRoute

                Nothing ->
                    mapNotFound <| NotFoundPage.init location

        ( menuModel, menuCmd ) =
            mapMainMenu <| MainMenu.init appConfig

        model =
            { routeModel = routeModel
            , mainMenu = menuModel
            , location = location
            , appConfig = appConfig
            }

        cmd =
            Cmd.batch [ routeCmd, menuCmd ]
    in
        ( Model model, cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    case msg of
        Navigate href ->
            ( Model model, newUrl href )

        MainMenuMsg mainMenuMsg ->
            let
                ( mainMenu, mainMenuCmd ) =
                    mapMainMenu <| MainMenu.update mainMenuMsg model.mainMenu
            in
                ( Model { model | mainMenu = mainMenu }
                , mainMenuCmd
                )

        DemoPageMsg demoMsg ->
            case model.routeModel of
                DemoModel demoModel ->
                    let
                        ( demo, demoCmd ) =
                            mapDemo <| Demo.update demoMsg demoModel
                    in
                        ( Model { model | routeModel = demo }
                        , demoCmd
                        )

                _ ->
                    ( Model model, Cmd.none )

        LocationChanged location ->
            let
                parser =
                    RootRoute.pathnameParser model.appConfig.basePath

                maybeRoute =
                    UrlParser.parsePath parser location

                ( routeModel, routeCmd ) =
                    case maybeRoute of
                        Just route ->
                            case route of
                                HomeRoute ->
                                    mapHome <| HomePage.init

                                DemoRoute demoRoute ->
                                    mapDemo <|
                                        case model.routeModel of
                                            DemoModel demoModel ->
                                                Demo.update (Demo.routeChanged demoRoute) demoModel

                                            _ ->
                                                Demo.init demoRoute

                        Nothing ->
                            mapNotFound <| NotFoundPage.init location
            in
                ( Model
                    { model
                        | routeModel = routeModel
                        , location = location
                    }
                , routeCmd
                )

        _ ->
            ( Model model, Cmd.none )


view : Model -> Html Msg
view (Model model) =
    let
        routeToString =
            RootRoute.toString model.appConfig.basePath

        mainMenu =
            Html.map MainMenuMsg <| lazy2 MainMenu.view model.mainMenu model.location.pathname

        mainContent =
            case model.routeModel of
                HomeModel homeModel ->
                    Html.map HomePageMsg <| lazy HomePage.view homeModel

                DemoModel demoModel ->
                    Html.map DemoPageMsg <| lazy Demo.view demoModel

                NotFoundModel notFoundModel ->
                    Html.map NotFoundPageMsg <| lazy NotFoundPage.view notFoundModel
    in
        div
            [ class Style.Root
            , onNavigate model.location.origin Navigate
            ]
            [ header [ class Style.Root_Header ]
                [ h1 [ class Style.Root_Heading ]
                    [ a
                        [ class Style.Root_Title
                        , href <| routeToString RootRoute.HomeRoute
                        ]
                        [ text "elm-app-boilerplate" ]
                    ]
                , nav [ class Style.Root_Navigation ]
                    [ mainMenu ]
                ]
            , main_ [ class Style.Root_Main ]
                [ mainContent
                ]
            , footer [ class Style.Root_Footer ]
                [ a [ href "https://github.com/gkubisa/elm-app-boilerplate" ]
                    [ text "Fork it on GitHub" ]
                ]
            ]


subscriptions : Model -> Sub Msg
subscriptions (Model model) =
    Sub.none


{-| Tags the Home model and command.
-}
mapHome : ( HomePage.Model, Cmd HomePage.Msg ) -> ( RouteModel, Cmd Msg )
mapHome =
    mapEach HomeModel (Cmd.map HomePageMsg)


{-| Tags the Demo model and command.
-}
mapDemo : ( Demo.Model, Cmd Demo.Msg ) -> ( RouteModel, Cmd Msg )
mapDemo =
    mapEach DemoModel (Cmd.map DemoPageMsg)


{-| Tags the NotFound model and command.
-}
mapNotFound : ( NotFoundPage.Model, Cmd NotFoundPage.Msg ) -> ( RouteModel, Cmd Msg )
mapNotFound =
    mapEach NotFoundModel (Cmd.map NotFoundPageMsg)


{-| Tags the MainMenu command.
-}
mapMainMenu : ( a, Cmd MainMenu.Msg ) -> ( a, Cmd Msg )
mapMainMenu =
    mapSecond (Cmd.map MainMenuMsg)
