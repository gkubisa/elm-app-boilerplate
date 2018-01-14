module App.Section.Demo.Route
    exposing
        ( Route(..)
        , pathnameParser
        , toPathnameFragment
        )

import UrlParser exposing (map, s, oneOf, top, (</>))


type Route
    = DemoRoute
    | AccordionDemoRoute
    | CheckboxDemoRoute
    | OtherDemoRoute


pathnameParser : UrlParser.Parser (Route -> a) a
pathnameParser =
    oneOf
        [ map DemoRoute top
        , map AccordionDemoRoute (s "accordion")
        , map CheckboxDemoRoute (s "checkbox")
        , map OtherDemoRoute (s "other")
        ]


toPathnameFragment : Route -> String
toPathnameFragment route =
    case route of
        DemoRoute ->
            ""

        AccordionDemoRoute ->
            "/accordion"

        CheckboxDemoRoute ->
            "/checkbox"

        OtherDemoRoute ->
            "/other"
