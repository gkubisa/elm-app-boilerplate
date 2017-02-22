port module TestRunner exposing (..)

import Json.Encode exposing (Value)
import Test.Runner.Node exposing (TestProgram, run)
import App.Etc.Tests as Tests

main: TestProgram
main =
  run emit Tests.testSuite

port emit: (String, Value) -> Cmd msg
