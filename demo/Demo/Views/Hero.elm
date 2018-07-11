module Demo.Views.Hero exposing (view)

import Html exposing (Html)
import Material.Options as Options exposing (Property, css, styled, cs)


view : List (Property c m) -> List (Html m) -> Html m
view options =
    styled Html.section
        (List.reverse
            -- TODO: dang it
            (cs "hero"
                :: css "display" "-webkit-box"
                :: css "display" "-ms-flexbox"
                :: css "display" "flex"
                :: css "-webkit-box-orient" "horizontal"
                :: css "-webkit-box-direction" "normal"
                :: css "-ms-flex-flow" "row nowrap"
                :: css "flex-flow" "row nowrap"
                :: css "-webkit-box-align" "center"
                :: css "-ms-flex-align" "center"
                :: css "align-items" "center"
                :: css "-webkit-box-pack" "center"
                :: css "-ms-flex-pack" "center"
                :: css "justify-content" "center"
                :: css "min-height" "360px"
                :: css "padding" "24px"
                :: css "background-color" "rgba(0, 0, 0, 0.05)"
                :: options
            )
        )
