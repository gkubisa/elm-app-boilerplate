module Tests exposing (testSuite)

import ElmTest exposing (Test, suite)
import String
import App.SampleTest as SampleTest
import App.Widget.MenuTest as MenuTest

testSuite : Test
testSuite =
  suite "All tests"
    [ SampleTest.testSuite
    , MenuTest.testSuite
    ]
