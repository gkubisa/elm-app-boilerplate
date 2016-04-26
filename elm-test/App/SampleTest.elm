module App.SampleTest
  ( testSuite
  ) where

import App.Sample exposing (sum, product)
import ElmTest exposing (Test, test, suite, assertEqual)
import Check exposing (Claim, Evidence, claim, that, is, true, for, quickCheck)
import Check.Producer exposing (filter, tuple, int, float)
import Check.Test exposing (evidenceToTest)

testSuite : Test
testSuite =
  suite "App.Sample"
    [ suite "sum"
        [ test "should return a sum of 2 Ints" <| assertEqual 8 (sum 3 5)
        , test "should return a sum of 2 Floats" <| assertEqual -10.5 (sum -20.5 10)
        ]
    , evidenceToTest << quickCheck <| Check.suite "product"
        [ claim "should multiply Ints"
            `that` (\(a, b) -> product a b)
            `is` (\(a, b) -> a * b)
            `for` tuple (int, int)
        , claim "should multiply Floats"
            `that` (\(a, b) -> product a b)
            `is` (\(a, b) -> a * b)
            `for` tuple (float, float)
        , claim "should be inverted by division with minimal imprecision"
            `true` (\(a, b) -> abs (product a b / b - a) < 1e-10)
            `for` (filter (\(a, b) -> b /= 0) (tuple (float, float)))
        ]
    ]
