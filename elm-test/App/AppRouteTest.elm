module App.AppRouteTest exposing (testSuite)

import Test exposing (Test, describe, test)
import Expect
import String

-- import App.AppRoute exposing (extractOrigin)

testSuite: Test
testSuite =
  describe "App.AppRoute"
    -- TODO add some real tests
    [ test "Addition" <|
        \() ->
            Expect.equal (3 + 7) 10
    , test "String.left" <|
        \() ->
            Expect.equal "a" (String.left 1 "abcdefg")
    -- , test "This test should fail" <|
    --     \() ->
    --         Expect.fail "failed as expected!"
    ]
