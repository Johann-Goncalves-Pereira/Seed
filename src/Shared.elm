module Shared exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    )

import Json.Decode as Json
import Request exposing (Request)



-- port onScroll : ({ x : Float, y : Float } -> msg) -> Sub msg


type alias Flags =
    Json.Value


type alias Model =
    {}


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    ( {}
    , Cmd.none
    )


type Msg
    = NoOp



-- | OnScroll { x : Float, y : Float }


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- OnScroll { x, y } ->
--     ( { model | scrollOffset = { x = x, y = y } }
--     , Cmd.none
--     )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none



-- onScroll OnScroll
