module Internal.Drawer.Permanent.Implementation exposing
    ( Property
    , content
    , header
    , subTitle
    , title
    , view
    )

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Drawer.Implementation as Drawer
import Internal.Msg


type alias Property m =
    Drawer.Property m


header : List (Property m) -> List (Html m) -> Html m
header =
    Drawer.header


title : Property m
title =
    Drawer.title


subTitle : Property m
subTitle =
    Drawer.subTitle


content : List (Property m) -> List (Html m) -> Html m
content =
    Drawer.content


type alias Store s =
    Drawer.Store s


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Drawer.render ""
