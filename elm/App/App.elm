module App.App exposing
  (init, update, urlUpdate, view, subscriptions)

{-| The main application component. Handles the top level routing.
-}

import Html exposing
  (div, header, footer, main', section, nav, h1, h2, a, text, Html)
import Html.Attributes exposing (href)
import Html.App
import Html.Lazy exposing (lazy)
import Navigation exposing (Location, newUrl)
import Tuple2 exposing (mapEach, mapSnd)
import App.HomePage as HomePage
import App.NotFoundPage as NotFoundPage
import App.Demo.Demo as Demo
import App.AppRoute as AppRoute exposing (Route(..), RoutingContext, onNavigate)
import App.MainMenu as MainMenu

type alias Model =
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
    (routeModel, routeCmd) = case routingContext.route of
      HomeRoute ->
        mapHome <| HomePage.init
      DemoRoute demoRoute ->
        mapDemo <| Demo.init demoRoute
      NotFoundRoute ->
        mapNotFound <| NotFoundPage.init routingContext.location

    (menuModel, menuCmd) = mapMainMenu <| MainMenu.init routingContext.route

    model =
      { routeModel = routeModel
      , mainMenu = menuModel
      , location = routingContext.location
      }

    cmd = Cmd.batch [ routeCmd, menuCmd ]
  in
    (model, cmd)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Navigate href ->
      (model, newUrl href)
    MainMenuMsg mainMenuMsg ->
      let
        (mainMenu, mainMenuCmd) =
          mapMainMenu <| MainMenu.update mainMenuMsg model.mainMenu
      in
        ( { model | mainMenu = mainMenu }
        , mainMenuCmd)
    DemoMsg demoMsg ->
      case model.routeModel of
        DemoModel demoModel ->
          let
            (demo, demoCmd) =
              mapDemo <| Demo.update demoMsg demoModel
          in
            ( { model | routeModel = demo }
            , demoCmd )
        _ ->
          (model, Cmd.none)
    _ ->
      (model, Cmd.none)

urlUpdate: RoutingContext -> Model -> (Model, Cmd Msg)
urlUpdate routingContext model =
  let
    (routeModel, routeCmd) = case routingContext.route of
      HomeRoute ->
        mapHome <| HomePage.init
      DemoRoute demoRoute ->
        mapDemo <| case model.routeModel of
          DemoModel demoModel ->
            Demo.urlUpdate demoRoute demoModel
          _ ->
            Demo.init demoRoute
      NotFoundRoute ->
        mapNotFound <| NotFoundPage.init routingContext.location

    (mainMenu, menuCmd) = mapMainMenu <|
      MainMenu.urlUpdate (AppRoute.toString routingContext.route) model.mainMenu
  in
    ( { model
      | routeModel = routeModel
      , mainMenu = mainMenu
      , location = routingContext.location
      }
    , Cmd.batch [routeCmd, menuCmd]
    )


view: Model -> Html Msg
view model =
  let
    mainMenu =
      Html.App.map MainMenuMsg <| lazy MainMenu.view model.mainMenu

    mainContent =
      case model.routeModel of
        HomeModel homeModel ->
          Html.App.map HomeMsg <| lazy HomePage.view homeModel
        DemoModel demoModel ->
          Html.App.map DemoMsg <| lazy Demo.view demoModel
        NotFoundModel notFoundModel ->
          Html.App.map NotFoundMsg <| lazy NotFoundPage.view notFoundModel
  in
    div [ onNavigate model.location.origin Navigate ]
      [ header []
          [ h1 []
              [ text "elm-app-boilerplate" ]
          , nav []
              [ mainMenu ]
          ]
      , main' []
          [ mainContent
          ]
      , footer []
          [ a [ href "https://github.com/gkubisa/elm-app-boilerplate" ]
              [ text "Source Code on GitHub" ]
          ]
      ]

subscriptions: Model -> Sub Msg
subscriptions model =
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
