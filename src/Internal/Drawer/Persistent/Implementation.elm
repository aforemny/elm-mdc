module Internal.Drawer.Persistent.Implementation
    exposing
        ( Property
        , content
        , header
        , headerContent
        , open
        , toolbarSpacer
        , view
        )

import Html exposing (Html, text)
import Internal.Component exposing (Index, Indexed)
import Internal.Drawer.Implementation as Drawer
import Internal.Drawer.Model exposing (Model, Msg)
import Internal.List.Implementation as Lists
import Internal.Msg


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


headerContent : List (Property m) -> List (Html m) -> Html m
headerContent =
    Drawer.headerContent


content : Lists.Property m
content =
    Drawer.content


toolbarSpacer : List (Property m) -> List (Html m) -> Html m
toolbarSpacer =
    Drawer.toolbarSpacer


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


open : Property m
open =
    Drawer.open


className : String
className =
    "mdc-drawer--persistent"
