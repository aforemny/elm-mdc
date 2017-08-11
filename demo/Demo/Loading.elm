module Demo.Loading exposing (view)

import Demo.Page exposing (Page)
import Html exposing (Html, text)
import Material.Options as Options exposing (div, css, cs, when)


view : Page m -> Html m
view page =
    div [] []
