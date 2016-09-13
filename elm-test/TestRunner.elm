port module TestRunner exposing (..)

import Json.Encode exposing (Value)
import Test.Runner.Node exposing (run)
import Tests

main: Program Value
main =
  run emit Tests.testSuite

port emit: (String, Value) -> Cmd msg
