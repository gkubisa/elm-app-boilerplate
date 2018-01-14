module App.Section.Root.Style exposing (..)

import Html.CssHelpers exposing (Namespace, withNamespace)


type CssClass
    = Root
    | Root_Header
    | Root_Heading
    | Root_Title
    | Root_Navigation
    | Root_Main
    | Root_Footer


namespaceName : String
namespaceName =
    "s"


namespace : Namespace String class id msg
namespace =
    withNamespace namespaceName
