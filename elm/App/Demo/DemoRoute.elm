module App.Demo.DemoRoute exposing
  (Route(..), toUrl)

import Erl

type Route =
    DemoRoute
  | AccordionDemoRoute
  | CheckboxDemoRoute
  | OtherDemoRoute

{-| Converts the specified `Route` to a `Url`
-}
toUrl: Route -> Erl.Url
toUrl route =
  -- TODO implement it properly
  Erl.new
