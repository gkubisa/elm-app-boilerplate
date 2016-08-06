module App.Demo.DemoRoute exposing
  ( Route(..)
  , toUrl, pathnameParser
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

{-| Converts the specified `Route` to a `Url`
-}
toUrl: Route -> Erl.Url
toUrl route =
  -- TODO implement it properly
  Erl.new
