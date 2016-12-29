port module TestRunner exposing (..)

import Json.Encode exposing (Value)
import Test.Runner.Node exposing (TestProgram, run)
import Tests

main: TestProgram
main =
  run emit Tests.testSuite

port emit: (String, Value) -> Cmd msg
