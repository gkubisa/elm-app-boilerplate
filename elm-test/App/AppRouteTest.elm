module App.AppRouteTest exposing (testSuite)

import Expect
import Test exposing (Test, describe, test)

import App.AppRoute exposing (extractOrigin)

testSuite: Test
testSuite =
  describe "App.AppRoute"
    [ describe "extractOrigin" <|
        let
          createTest (description, origin, url) =
            test description <| \() ->
              Expect.equal origin (extractOrigin url)

          testCases =
            [ ( "works for http with no port"
              , "http://example.com:80"
              , "http://example.com/some/path"
              )
            , ( "works for https with no port"
              , "https://example.com:443"
              , "https://example.com/some/path"
              )
            , ( "works for http with a custom port"
              , "http://example.com:9999"
              , "http://example.com:9999/some/path"
              )
            , ( "works for https with a custom port"
              , "https://example.com:9999"
              , "https://example.com:9999/some/path"
              )
            ]
        in
          List.map createTest testCases
    ]
