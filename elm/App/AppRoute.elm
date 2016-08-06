module App.AppRoute exposing
  ( Route(..), RoutingContext
  , toUrl, toString, urlParser
  , newRoute, modifyRoute
  )

import Navigation exposing (Location)
import UrlParser exposing (format, s, oneOf, (</>))
import Erl
import App.Demo.DemoRoute as DemoRoute

type Route =
    HomeRoute
  | DemoRoute DemoRoute.Route
  | NotFoundRoute

type alias RoutingContext =
  { route: Route
  , location: Location
  }

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
    [ format DemoRoute (s "" </> s "demo" </> DemoRoute.pathnameParser)
    , format HomeRoute (s "")
    ]


{-| Converts the specified `Route` to a `Url`
-}
toUrl: Route -> Erl.Url
toUrl route =
  case route of
    HomeRoute ->
      Erl.parse "/"
    DemoRoute demoRoute ->
      case demoRoute of
        DemoRoute.DemoRoute ->
          Erl.parse "/demo/"
        DemoRoute.AccordionDemoRoute ->
          Erl.parse "/demo/accordion"
        DemoRoute.CheckboxDemoRoute ->
          Erl.parse "/demo/checkbox"
        DemoRoute.OtherDemoRoute ->
          Erl.parse "/demo/other"
    NotFoundRoute ->
      Erl.new

{-| Converts the specified `Route` to a URL represented as a `String`.
-}
toString: Route -> String
toString =
  Erl.toString << toUrl

{-| Navigates to the specified route creating a new entry in the browser
history.
-}
newRoute: Route -> Cmd msg
newRoute =
  Navigation.newUrl << toString

{-| Navigates to the specified route modifying the current entry in the browser
history.
-}
modifyRoute: Route -> Cmd msg
modifyRoute =
  Navigation.modifyUrl << toString
