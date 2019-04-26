module Internal.Drawer.Dismissible.Implementation exposing
    ( Property
    , appContent
    , content
    , header
    , onClose
    , open
    , subTitle
    , title
    , view
    )

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Drawer.Implementation as Drawer
import Internal.Msg
import Internal.Options exposing (cs)


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
    Drawer.render className


onClose : m -> Property m
onClose =
    Drawer.onClose


open : Property m
open =
    Drawer.open


appContent : Property m
appContent =
    cs "mdc-drawer-app-content"


className : String
className =
    "mdc-drawer--dismissible"
