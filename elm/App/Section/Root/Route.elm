module App.Section.Root.Route
    exposing
        ( Route(..)
        , pathnameParser
        , toPathnameFragment
        , toString
        , newRoute
        , modifyRoute
        , onNavigate
        )

import Navigation exposing (Location)
import UrlParser exposing (map, s, oneOf, top, (</>))
import Html exposing (Attribute)
import Html.Events exposing (onWithOptions, defaultOptions)
import Json.Decode as JD
import App.Section.Demo.Route as DemoRoute


type Route
    = HomeRoute
    | DemoRoute DemoRoute.Route


{-| A parser which turns `Location.pathname` into a `Route`.
-}
pathnameParser : String -> UrlParser.Parser (Route -> a) a
pathnameParser basePath =
    let
        basePathParser =
            List.foldr (</>) top
                << List.map s
                << List.filter ((/=) "")
                << String.split "/"
            <|
                basePath

        routePathParser =
            oneOf
                [ map HomeRoute top
                , map DemoRoute (s "demo" </> DemoRoute.pathnameParser)
                ]
    in
        basePathParser </> routePathParser


toPathnameFragment : Route -> String
toPathnameFragment route =
    case route of
        HomeRoute ->
            "/"

        DemoRoute _ ->
            "/demo"


{-| Converts the specified `Route` to a URL represented as a `String`.
-}
toString : String -> Route -> String
toString basePath route =
    basePath
        ++ toPathnameFragment route
        ++ case route of
            DemoRoute demoRoute ->
                DemoRoute.toPathnameFragment demoRoute

            _ ->
                ""


{-| Navigates to the specified route creating a new entry in the browser
history.
-}
newRoute : String -> Route -> Cmd msg
newRoute basePath =
    Navigation.newUrl << toString basePath


{-| Navigates to the specified route modifying the current entry in the browser
history.
-}
modifyRoute : String -> Route -> Cmd msg
modifyRoute basePath =
    Navigation.modifyUrl << toString basePath


{-| Emits a custom message for navigation within the specified `origin`,
triggered by activating an anchor tag.
-}
onNavigate : String -> (String -> msg) -> Attribute msg
onNavigate expectedOrigin tagger =
    let
        options =
            { defaultOptions | preventDefault = True }

        nodeNameDecoder =
            JD.at [ "target", "nodeName" ] JD.string

        originDecoder =
            JD.at [ "target", "origin" ] JD.string

        hrefDecoder =
            JD.at [ "target", "href" ] JD.string

        eventDecoder =
            JD.map3 (,,) nodeNameDecoder originDecoder hrefDecoder

        decoder =
            eventDecoder
                |> JD.andThen
                    (\( nodeName, origin, href ) ->
                        if nodeName /= "A" then
                            JD.fail "Expected `target.nodeName` to equal \"A\""
                        else if href == "" then
                            JD.fail "Expected `target.href` to be non-empty"
                        else if origin /= expectedOrigin then
                            JD.fail <| "Expected `target.origin` to equal \"" ++ expectedOrigin ++ "\""
                        else
                            JD.succeed (tagger href)
                    )
    in
        onWithOptions "click" options decoder
