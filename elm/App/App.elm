module App.App exposing
  (init, update, urlUpdate, view, subscriptions, urlParser)

{-| The main application component. Handles the top level routing.
-}

import Html exposing
  (div, header, footer, main', section, nav, h1, h2, a, text, Html)
import Html.Attributes exposing (href)
import Html.App
import Navigation exposing (Location)
import UrlParser exposing (format, s, oneOf, (</>))
import Tuple2 exposing (mapEach, mapSnd)
import App.HomePage as HomePage
import App.NotFoundPage as NotFoundPage
import App.Demo.Demo as Demo
import App.AppRoute exposing (Route(..))
import App.MainMenu as MainMenu

type alias Model =
  { routeModel: RouteModel
  , mainMenu: MainMenu.Model
  }

type RouteModel =
    HomeModel HomePage.Model
  | DemoModel Demo.Model
  | NotFoundModel NotFoundPage.Model

type alias RoutingContext =
  { route: Route
  , location: Location
  }

type Msg =
    HomeMsg HomePage.Msg
  | DemoMsg Demo.Msg
  | NotFoundMsg NotFoundPage.Msg
  | MainMenuMsg MainMenu.Msg

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
      }

    cmd = Cmd.batch [ routeCmd, menuCmd ]
  in
    (model, cmd)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
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
      MainMenu.urlUpdate routingContext.route model.mainMenu
  in
    ( { model
      | routeModel = routeModel
      , mainMenu = mainMenu
      }
    , Cmd.batch [routeCmd, menuCmd]
    )


view: Model -> Html Msg
view model =
  let
    mainMenu =
      Html.App.map MainMenuMsg <| MainMenu.view model.mainMenu

    mainContent =
      case model.routeModel of
        HomeModel homeModel ->
          Html.App.map HomeMsg <| HomePage.view homeModel
        DemoModel demoModel ->
          Html.App.map DemoMsg <| Demo.view demoModel
        NotFoundModel notFoundModel ->
          Html.App.map NotFoundMsg <| NotFoundPage.view notFoundModel
  in
    div []
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

{-| A parser which turns `Location` into a `Route`.
-}
urlParser: Navigation.Parser RoutingContext
urlParser =
  Navigation.makeParser <| \location ->
    let
      route =
        case UrlParser.parse identity pathnameParser location.pathname of
          Ok route ->
            route
          Err _ ->
            NotFoundRoute
    in
      { route = route
      , location = location
      }

{-| A parser which turns `Location.pathname` into a `Route`.
-}
pathnameParser: UrlParser.Parser (Route -> a) a
pathnameParser =
  oneOf
    [ format DemoRoute (s "" </> s "demo" </> Demo.pathnameParser)
    , format HomeRoute (s "")
    ]

{-| Tags the Home model and command.
-}
mapHome =
  mapEach HomeModel (Cmd.map HomeMsg)

{-| Tags the Demo model and command.
-}
mapDemo =
  mapEach DemoModel (Cmd.map DemoMsg)

{-| Tags the NotFound model and command.
-}
mapNotFound =
  mapEach NotFoundModel (Cmd.map NotFoundMsg)

{-| Tags the MainMenu command.
-}
mapMainMenu =
  mapSnd (Cmd.map MainMenuMsg)
