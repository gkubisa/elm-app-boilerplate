port module Stylesheets exposing (main)

import App.Section.Root.Css as SectionRoot
import App.Widget.MainMenu.Css as MainMenu
import Css.File
    exposing
        ( CssFileStructure
        , CssCompilerProgram
        , toFileStructure
        , compile
        , compiler
        )
import Css.Normalize as Normalize


port files : CssFileStructure -> Cmd msg


stylesheets =
    [ Normalize.css
    , MainMenu.css
    , SectionRoot.css
    ]


fileStructure : CssFileStructure
fileStructure =
    toFileStructure
        [ ( "main.css", compile stylesheets ) ]


main : CssCompilerProgram
main =
    compiler files fileStructure
