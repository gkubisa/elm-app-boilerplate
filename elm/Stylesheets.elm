port module Stylesheets exposing (main)

import App.Section.Root.Css as SectionRoot
import Css.File exposing
  ( CssFileStructure
  , CssCompilerProgram
  , toFileStructure
  , compile
  , compiler
  )


port files : CssFileStructure -> Cmd msg


stylesheets =
  [ SectionRoot.css
  ]


fileStructure : CssFileStructure
fileStructure =
  toFileStructure
    [ ( "main.css", compile stylesheets ) ]


main : CssCompilerProgram
main =
  compiler files fileStructure
