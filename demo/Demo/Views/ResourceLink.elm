module Demo.Views.ResourceLink exposing (view)

import Material.List as Lists
import Html.Attributes
import Html exposing (Html, text)
import Material.Options exposing (attribute, cs, styled)


view : String -> String -> String -> String -> Html m
view link title iconLink altText =
    Lists.a
        [ attribute <| Html.Attributes.href link
        , attribute <| Html.Attributes.target "_blank"
        ]
        [ Lists.graphic []
            [ styled Html.img
                [ attribute <| Html.Attributes.src iconLink
                , cs "resources-icon"
                , attribute <| Html.Attributes.alt altText
                ]
                []
            ]
        , text title
        ]
