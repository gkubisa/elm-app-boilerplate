module Tests exposing (testSuite)

import ElmTest exposing (Test, suite)
import App.Widget.MenuTest as MenuTest

testSuite : Test
testSuite =
  suite "All tests"
    [ MenuTest.testSuite
    ]
