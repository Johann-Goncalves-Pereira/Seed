module Layout exposing (Model, initLayout, viewLayout)

import Array
import Gen.Route as Route exposing (Route)
import Html exposing (Attribute, Html, a, div, header, main_, nav, text)
import Html.Attributes exposing (class, classList, href, id, tabindex)
import Regex



-- Model


type alias Model msg =
    { route : Route
    , rootContent : List (Html msg)
    , rootAttrs : List (Attribute msg)
    }


type alias Link =
    { routeStatic : Route
    , routeReceived : Route
    , routeName : String
    }


initLayout : Model msg
initLayout =
    { route = Route.Home_
    , rootContent = []
    , rootAttrs = []
    }


defaultLink : Link
defaultLink =
    { routeStatic = Route.Home_
    , routeReceived = Route.Home_
    , routeName = ""
    }



-- Structure


routeName : Route -> String
routeName route =
    let
        strRoute : String
        strRoute =
            Route.toHref route

        getLength =
            String.length strRoute

        getFirstCharacter =
            String.dropRight (getLength - 2) strRoute
                |> String.toUpper
                |> String.dropLeft 1
    in
    if route == Route.Home_ then
        "Home"

    else
        getFirstCharacter
            ++ String.replace "/" " - " (String.dropLeft 2 strRoute)


userReplace : String -> (Regex.Match -> String) -> String -> String
userReplace userRegex replacer string =
    case Regex.fromString userRegex of
        Nothing ->
            string

        Just regex ->
            Regex.replace regex replacer string


classBuilder : String -> String
classBuilder string =
    userReplace "[ ]" (\_ -> "-") string
        |> String.toLower



-- View


viewLayout : Model msg -> List (Html msg)
viewLayout model =
    let
        pageClass : String
        pageClass =
            "root--"
                ++ classBuilder
                    (routeName model.route)

        rootClass : String
        rootClass =
            "root"
    in
    div
        ([ id rootClass
         , classList
            [ ( rootClass, True )
            , ( pageClass, True )
            ]
         ]
            ++ model.rootAttrs
        )
        model.rootContent
        |> List.singleton
