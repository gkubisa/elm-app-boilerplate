module App.Section.Root.Css exposing (css)

import App.Etc.Style exposing (..)
import App.Section.Root.Style as Style exposing ( CssClass(..) )
import Css exposing (..)
import Css.Elements exposing (button)
import Css.Namespace exposing (namespace)


css = (stylesheet << namespace Style.namespace)

  [ everything
      [ focus
          [ outline3 (Css.rem 0.125) solid accentColor
          ]
      ]
  ]
