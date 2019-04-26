module Internal.Drawer.Modal.Implementation exposing
    ( Property
    , content
    , header
    , onClose
    , open
    , scrim
    , subTitle
    , title
    , view
    )

import Html exposing (Html, div)
import Internal.Component exposing (Index)
import Internal.Drawer.Implementation as Drawer
import Internal.Msg
import Internal.Options exposing (cs, styled)


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


scrim : List (Property m) -> List (Html m) -> Html m
scrim options =
    styled div (cs "mdc-drawer-scrim" :: options)


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
    Drawer.render className


onClose : m -> Property m
onClose =
    Drawer.onClose


open : Property m
open =
    Drawer.open


className : String
className =
    "mdc-drawer--modal"
