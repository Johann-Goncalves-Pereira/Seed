module Utils.View exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (attribute)


customProps : List ( String, String ) -> Attribute msg
customProps listProps =
    List.foldl
        (\( prop, value ) result ->
            String.concat [ result, "--", prop, ":", value, ";" ]
        )
        ""
        listProps
        |> attribute "style"


customProp : String -> String -> Attribute msg
customProp prop value =
    String.concat [ "--", prop, ":", value, ";" ]
        |> attribute "style"
