module App.Demo.DemoRoute exposing
  ( Route(..)
  , pathnameParser, toPathnameFragment
  )

import UrlParser exposing (format, s, oneOf, (</>))
import Erl

type Route =
    DemoRoute
  | AccordionDemoRoute
  | CheckboxDemoRoute
  | OtherDemoRoute

pathnameParser: UrlParser.Parser (Route -> a) a
pathnameParser =
  oneOf
    [ format AccordionDemoRoute (s "accordion")
    , format CheckboxDemoRoute (s "checkbox")
    , format OtherDemoRoute (s "other")
    , format DemoRoute (s "")
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
