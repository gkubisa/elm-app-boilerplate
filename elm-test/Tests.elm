module Tests exposing (testSuite)

import Test exposing (Test, describe)

import App.AppRouteTest as AppRouteTest
import App.Widget.MenuTest as MenuTest

testSuite : Test
testSuite =
  describe "elm-app-boilerplate"
    [ AppRouteTest.testSuite
    , MenuTest.testSuite
    ]
