module Material.Drawer.Temporary
    exposing
        ( Model
        , defaultModel
        , Msg
        , update
        , Config
        , view
        , render
        , react
        , header
        , headerContent
        , content
        -- , open
        , subs
        , subscriptions
        , open
        , close
        , toggle
        )

{-| TODO
-}

import Html exposing (Html, text)
import Material.Drawer as Drawer
import Material.Msg exposing (Index)


-- MODEL


{-| Component model.
-}
type alias Model =
    Drawer.Model


{-| Default component model.
-}
defaultModel : Model
defaultModel =
    Drawer.defaultModel



-- ACTION, UPDATE


{-| Component message.
-}
type alias Msg
    = Drawer.Msg


{-| Component update.
-}
update : x -> Msg -> Model -> ( Maybe Model, Cmd m )
update =
    Drawer.update


-- OPTIONS


type alias Config m =
    Drawer.Config m


defaultConfig : Config m
defaultConfig =
    Drawer.defaultConfig


{-| TODO
-}
type alias Property m =
    Drawer.Property m


-- VIEW


className : String
className =
    "mdc-temporary-drawer"


{-| Component view.
-}
view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view =
    Drawer.view className


header : List (Property m) -> List (Html m) -> Html m
header =
    Drawer.header className


headerContent : List (Property m) -> List (Html m) -> Html m
headerContent =
    Drawer.headerContent className


content : List (Property m) -> List (Html m) -> Html m
content =
    Drawer.content className


-- COMPONENT


type alias Store s =
    Drawer.Store s


{-| Component react function.
-}
react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Drawer.react


{-| Component render (drawer)
-}
render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render =
    Drawer.render className


subs : (Material.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Drawer.subs


subscriptions : Model -> Sub Msg
subscriptions =
    Drawer.subscriptions


--

open : (Material.Msg.Msg m -> m) -> Index -> Cmd m
open =
    Drawer.open False


close : (Material.Msg.Msg m -> m) -> Index -> Cmd m
close =
    Drawer.close


toggle : (Material.Msg.Msg m -> m) -> Index -> Cmd m
toggle =
    Drawer.toggle False
