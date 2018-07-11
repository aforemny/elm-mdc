module Demo.Helper.ResourceLink exposing (view)

import Html.Attributes as Html
import Html exposing (Html, text)
import Material.List as Lists
import Material.Options as Options exposing (styled, cs)


view :
    { link : String
    , title : String
    , icon : String
    , altText : String
    }
    -> Html m
view { link, title, icon, altText } =
    Lists.a
        [ Options.attribute (Html.href link)
        , Options.attribute (Html.target "_blank")
        ]
        [ Lists.graphic []
            [ styled Html.img
                [ cs "resources-icon"
                , Options.attribute (Html.src icon)
                , Options.attribute (Html.alt altText)
                ]
                []
            ]
        , text title
        ]
