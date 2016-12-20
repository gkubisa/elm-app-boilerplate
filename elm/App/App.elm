module App.App exposing
  (init, update, urlUpdate, view, subscriptions)

{-| The main application component. Handles the top level routing.
-}

import Html exposing
  (div, header, footer, main', section, nav, h1, h2, a, text, Html)
import Html.Attributes exposing (class, href)
import Html.App
import Html.Lazy exposing (lazy, lazy2)
import Navigation exposing (Location, newUrl)
import Tuple2 exposing (mapEach, mapSnd)
import App.HomePage as HomePage
import App.NotFoundPage as NotFoundPage
import App.Demo.Demo as Demo
import App.AppRoute as AppRoute exposing (Route(..), RoutingContext, onNavigate, getRoute, getLocation)
import App.MainMenu as MainMenu

type Model = Model
  { routeModel: RouteModel
  , mainMenu: MainMenu.Model
  , location: Location
  }

type RouteModel =
    HomeModel HomePage.Model
  | DemoModel Demo.Model
  | NotFoundModel NotFoundPage.Model

type Msg =
    HomeMsg HomePage.Msg
  | DemoMsg Demo.Msg
  | NotFoundMsg NotFoundPage.Msg
  | MainMenuMsg MainMenu.Msg
  | Navigate String

init: RoutingContext -> (Model, Cmd Msg)
init routingContext =
  let
    (routeModel, routeCmd) = case getRoute routingContext of
      HomeRoute ->
        mapHome <| HomePage.init
      DemoRoute demoRoute ->
        mapDemo <| Demo.init demoRoute
      NotFoundRoute ->
        mapNotFound <| NotFoundPage.init (getLocation routingContext)

    (menuModel, menuCmd) = mapMainMenu MainMenu.init

    model =
      { routeModel = routeModel
      , mainMenu = menuModel
      , location = getLocation routingContext
      }

    cmd = Cmd.batch [ routeCmd, menuCmd ]
  in
    (Model model, cmd)

update: Msg -> Model -> (Model, Cmd Msg)
update msg (Model model) =
  case msg of
    Navigate href ->
      (Model model, newUrl href)
    MainMenuMsg mainMenuMsg ->
      let
        (mainMenu, mainMenuCmd) =
          mapMainMenu <| MainMenu.update mainMenuMsg model.mainMenu
      in
        ( Model { model | mainMenu = mainMenu }
        , mainMenuCmd)
    DemoMsg demoMsg ->
      case model.routeModel of
        DemoModel demoModel ->
          let
            (demo, demoCmd) =
              mapDemo <| Demo.update demoMsg demoModel
          in
            ( Model { model | routeModel = demo }
            , demoCmd )
        _ ->
          (Model model, Cmd.none)
    _ ->
      (Model model, Cmd.none)

urlUpdate: RoutingContext -> Model -> (Model, Cmd Msg)
urlUpdate routingContext (Model model) =
  let
    (routeModel, routeCmd) = case getRoute routingContext of
      HomeRoute ->
        mapHome <| HomePage.init
      DemoRoute demoRoute ->
        mapDemo <| case model.routeModel of
          DemoModel demoModel ->
            Demo.urlUpdate demoRoute demoModel
          _ ->
            Demo.init demoRoute
      NotFoundRoute ->
        mapNotFound <| NotFoundPage.init (getLocation routingContext)
  in
    ( Model
        { model
        | routeModel = routeModel
        , location = getLocation routingContext
        }
    , routeCmd
    )


view: Model -> Html Msg
view (Model model) =
  let
    mainMenu =
      Html.App.map MainMenuMsg <| lazy2 MainMenu.view model.mainMenu model.location.pathname

    mainContent =
      case model.routeModel of
        HomeModel homeModel ->
          Html.App.map HomeMsg <| lazy HomePage.view homeModel
        DemoModel demoModel ->
          Html.App.map DemoMsg <| lazy Demo.view demoModel
        NotFoundModel notFoundModel ->
          Html.App.map NotFoundMsg <| lazy NotFoundPage.view notFoundModel
  in
    div
      [ class "App"
      , onNavigate model.location.origin Navigate
      ]
      [ header [ class "App_header" ]
          [ h1 [ class "App_heading" ]
              [ a [ href "/" ] [ text "elm-app-boilerplate" ] ]
          , nav [ class "App_navigation" ]
              [ mainMenu ]
          ]
      , main' [ class "App_main" ]
          [ mainContent
          ]
      , footer [ class "App_footer" ]
          [ a [ href "https://github.com/gkubisa/elm-app-boilerplate" ]
              [ text "Fork it on GitHub" ]
          ]
      ]

subscriptions: Model -> Sub Msg
subscriptions (Model model) =
  Sub.none

{-| Tags the Home model and command.
-}
mapHome: (HomePage.Model, Cmd HomePage.Msg) -> (RouteModel, Cmd Msg)
mapHome =
  mapEach HomeModel (Cmd.map HomeMsg)

{-| Tags the Demo model and command.
-}
mapDemo: (Demo.Model, Cmd Demo.Msg) -> (RouteModel, Cmd Msg)
mapDemo =
  mapEach DemoModel (Cmd.map DemoMsg)

{-| Tags the NotFound model and command.
-}
mapNotFound: (NotFoundPage.Model, Cmd NotFoundPage.Msg) -> (RouteModel, Cmd Msg)
mapNotFound =
  mapEach NotFoundModel (Cmd.map NotFoundMsg)

{-| Tags the MainMenu command.
-}
mapMainMenu: (a, Cmd MainMenu.Msg) -> (a, Cmd Msg)
mapMainMenu =
  mapSnd (Cmd.map MainMenuMsg)
