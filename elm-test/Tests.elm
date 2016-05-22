module Tests exposing (testSuite)

import ElmTest exposing (Test, suite)
import String
import App.SampleTest

testSuite : Test
testSuite =
  suite "All tests"
    [ App.SampleTest.testSuite
    ]
