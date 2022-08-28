module Pages.Home_ exposing (Model, Msg, page)

import Components.Svg as SVG exposing (Logo(..))
import Gen.Params.Home_ exposing (Params)
import Gen.Route as Route
import Html exposing (Html, a, div, h1, h2, h5, p, section, text)
import Html.Attributes exposing (class, href, id, rel, style, tabindex, target)
import Html.Attributes.Aria exposing (ariaHidden, ariaLabel, ariaLabelledby)
import Html.Events exposing (onClick)
import Layout exposing (initLayout)
import Page
import Random
import Request
import Round
import Shared
import Simplex exposing (noise2d, permutationTableFromInt)
import Svg exposing (desc)
import Svg.Attributes exposing (transform)
import Task
import Utils.View exposing (customProp, customProps)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update shared
        , view = view shared
        , subscriptions = subs
        }



-- INIT


type alias Model =
    { -- Permutation Table int to generate the noise.
      randomPermutationTable : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { randomPermutationTable = 0 }
    , run <| RandomPermutationTable
    )


run : msg -> Cmd msg
run m =
    Task.succeed ()
        |> Task.perform
            (always m)



-- UPDATE


type Msg
    = NoOp
    | RandomPermutationTable
    | NewRandomPermutationTable Int


update : Shared.Model -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        RandomPermutationTable ->
            ( model
            , Random.generate NewRandomPermutationTable (Random.int 1 360)
            )

        NewRandomPermutationTable random_ ->
            ( { model | randomPermutationTable = random_ }
            , Cmd.none
            )



-- SUB


subs : Model -> Sub Msg
subs _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Revex - Home"
    , body =
        Layout.viewLayout
            { initLayout
                | route = Route.Home_
                , rootAttrs = [ onClick RandomPermutationTable ]
                , rootContent = viewPage shared model
            }
    }


viewPage : Shared.Model -> Model -> List (Html Msg)
viewPage shared model =
    [ viewFluxDiv shared model
    ]


viewFluxDiv : Shared.Model -> Model -> Html Msg
viewFluxDiv _ model =
    let
        amountOfFlux =
            800
    in
    div [ class "flux-container" ] <|
        List.indexedMap
            (\i _ ->
                let
                    iFloat : Float
                    iFloat =
                        toFloat i

                    shadowHue : String
                    shadowHue =
                        toFloat model.randomPermutationTable
                            + (iFloat * 0.3)
                            |> Round.round 2

                    noise : Float
                    noise =
                        noise2d
                            (permutationTableFromInt model.randomPermutationTable)
                            (iFloat * 0.0085)
                            (iFloat * 0.0085)

                    translateX : String
                    translateX =
                        [ Round.round 5 <| noise * 50, "px" ]
                            |> String.concat

                    rotate : String
                    rotate =
                        [ Round.round 5 <| noise * 50, "deg" ]
                            |> String.concat

                    scale : { x : String, y : String }
                    scale =
                        { x = Round.round 5 <| 3 + noise * 2
                        , y = Round.round 5 <| 3 + noise * 2
                        }

                    before_ =
                        if model.randomPermutationTable <= 180 then
                            ( "flux-before", "\" \"" )

                        else
                            ( "", " " )
                in
                div
                    [ class "flux"
                    , customProps
                        [ ( "flux-color", shadowHue )
                        , ( "flux-x", translateX )
                        , ( "flux-rotate", rotate )
                        , ( "flux-scale-x", scale.x )
                        , ( "flux-scale-y", scale.y )
                        , before_
                        ]
                    , ariaHidden True
                    ]
                    []
            )
            (List.range 0 amountOfFlux)
