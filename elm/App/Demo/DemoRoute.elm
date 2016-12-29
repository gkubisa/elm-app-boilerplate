module App.Demo.DemoRoute exposing
  ( Route(..)
  , pathnameParser, toPathnameFragment
  )

import UrlParser exposing (map, s, oneOf, (</>))

type Route =
    DemoRoute
  | AccordionDemoRoute
  | CheckboxDemoRoute
  | OtherDemoRoute

pathnameParser: UrlParser.Parser (Route -> a) a
pathnameParser =
  oneOf
    [ map AccordionDemoRoute (s "accordion")
    , map CheckboxDemoRoute (s "checkbox")
    , map OtherDemoRoute (s "other")
    , map DemoRoute (s "")
    ]

toPathnameFragment: Route -> String
toPathnameFragment route =
  case route of
    DemoRoute ->
      ""
    AccordionDemoRoute ->
      "accordion"
    CheckboxDemoRoute ->
      "checkbox"
    OtherDemoRoute ->
      "other"
