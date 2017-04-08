module App.Page.Home
    exposing
        ( init
        , view
        , Model
        , Msg
        )

import Html exposing (Html, section, h1, p, a, text)
import Html.Attributes exposing (href)


type Model
    = Model


type Msg
    = Noop


init : ( Model, Cmd Msg )
init =
    ( Model
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    section []
        [ h1 [] [ text "elm-app-boilerplate" ]
        , p []
            [ text """elm-app-boilerplate provides a great foundation for creating
            new web applications in Elm. """
            , a [ href "https://github.com/gkubisa/elm-app-boilerplate" ]
                [ text "Fork it on Github" ]
            , text " and get coding!"
            ]
        ]
