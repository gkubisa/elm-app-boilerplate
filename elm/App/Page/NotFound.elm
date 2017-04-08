module App.Page.NotFound
    exposing
        ( init
        , view
        , Model
        , Msg
        )

import Html exposing (Html, section, h1, p, text)
import Navigation exposing (Location, modifyUrl)


type Model
    = Model


type Msg
    = Msg


init : Location -> ( Model, Cmd Msg )
init location =
    ( Model
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    section []
        [ h1 []
            [ text "Not Found" ]
        , p []
            [ text "Sorry, nothing here." ]
        ]
