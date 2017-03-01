module App.Section.Root.Style exposing
  ( CssClass
  , namespace )

import Html.CssHelpers exposing (withNamespace)


type CssClass
  = Root


namespace = withNamespace "Section"
