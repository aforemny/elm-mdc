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

import Html exposing (Html, text, div)
import Internal.Component exposing (Index, Indexed)
import Internal.Drawer.Implementation as Drawer
import Internal.Drawer.Model exposing (Model, Msg)
import Internal.List.Implementation as Lists
import Internal.Msg
import Internal.Options as Options exposing (cs, styled)


type alias Config m =
    Drawer.Config m


defaultConfig : Config m
defaultConfig =
    Drawer.defaultConfig


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
    styled div ( cs "mdc-drawer-scrim" :: options)


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


react :
    (Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Drawer.react


subs : (Internal.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Drawer.subs


subscriptions : Model -> Sub Msg
subscriptions =
    Drawer.subscriptions


onClose : m -> Property m
onClose =
    Drawer.onClose


open : Property m
open =
    Drawer.open


className : String
className =
    "mdc-drawer--modal"
