module App.Etc.Tests exposing (testSuite)

import Test exposing (Test, describe)
import App.Section.Root.Route.Test as RootRouteTest
import App.Widget.Menu.Test as MenuTest


testSuite : Test
testSuite =
    describe "elm-app-boilerplate"
        [ RootRouteTest.testSuite
        , MenuTest.testSuite
        ]
