module App.AppRoute exposing
  ( Route(..), RoutingContext
  , pathnameParser, toPathnameFragment
  , urlParser
  , toUrl, toString
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

{-| A parser which turns `Location.pathname` into a `Route`.
-}
pathnameParser: UrlParser.Parser (Route -> a) a
pathnameParser =
  oneOf
    [ format DemoRoute (s "" </> s "demo" </> DemoRoute.pathnameParser)
    , format HomeRoute (s "")
    ]

toPathnameFragment: Route -> String
toPathnameFragment route =
  case route of
    HomeRoute ->
      "/"
    DemoRoute _ ->
      "/demo/"
    NotFoundRoute ->
      ""

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

{-| Converts the specified `Route` to a `Url`
-}
toUrl: Route -> Erl.Url
toUrl route =
  let
    basePath = toPathnameFragment route
    fullPath =
      case route of
        DemoRoute demoRoute ->
          basePath ++ DemoRoute.toPathnameFragment demoRoute
        _ ->
          basePath
  in
    Erl.parse fullPath

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
