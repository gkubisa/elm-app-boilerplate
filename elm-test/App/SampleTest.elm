module App.SampleTest
  ( testSuite
  ) where

import App.Sample exposing (sum, product)
import ElmTest exposing (Test, test, suite, assertEqual)

testSuite : Test
testSuite =
  suite "App.Sample"
    [ suite "sum"
        [ test "should return a sum of 2 numbers" <| assertEqual 8 (sum 3 5)
        ]
    , suite "product"
        [ test "should return a product of 2 numbers" <| assertEqual 15 (product 3 5)
        ]
    ]
