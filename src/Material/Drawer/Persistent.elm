module Material.Drawer.Persistent
    exposing
        ( content
        , defaultModel
        , header
        , headerContent
        , Model
        , Msg
        , Property
        , react
        , render
        , Store
        , subs
        , subscriptions
        , toggleOn
        , toolbarSpacer
        , update
        , view
        )

{-| The MDC Drawer component is a spec-aligned drawer component adhering to the
Material Design navigation drawer pattern. It implements permanent, persistent,
and temporary drawers.

## Design & API Documentation

- [Material Design guidelines: Navigation drawer](https://material.io/guidelines/patterns/navigation-drawer.html)
- [Demo: Temporary Drawer](https://aforemny.github.io/elm-mdc/#temporary-drawer)
- [Demo: Persistent Drawer](https://aforemny.github.io/elm-mdc/#persistent-drawer)
- [Demo: Permanent Drawer Above Toolbar](https://aforemny.github.io/elm-mdc/#permanent-drawer-above)
- [Demo: Permanent Drawer Below Toolbar](https://aforemny.github.io/elm-mdc/#permanent-drawer-below)

## View
@docs view
@docs Property

## Elements
@docs header, headerContent, content, toolbarSpacer

## TEA architecture
@docs subscriptions, Model, defaultModel, Msg, update
@docs open, close, toggle

## Featured render
@docs subs, emit, render
@docs Store, react
-}

import Html exposing (Html, text)
import Json.Decode as Json
import Material.Drawer as Drawer
import Material.Internal.Drawer
import Material.Msg exposing (Index)
import Material.Options as Options


type alias Model =
    Drawer.Model


defaultModel : Model
defaultModel =
    Drawer.defaultModel


type alias Msg
    = Drawer.Msg


update : x -> Msg -> Model -> ( Maybe Model, Cmd m )
update =
    Drawer.update


type alias Config =
    Drawer.Config


defaultConfig : Config
defaultConfig =
    Drawer.defaultConfig


type alias Property m =
    Drawer.Property m


view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view =
    Drawer.view className


header : List (Property m) -> List (Html m) -> Html m
header =
    Drawer.header


headerContent : List (Property m) -> List (Html m) -> Html m
headerContent =
    Drawer.headerContent


content : List (Property m) -> List (Html m) -> Html m
content =
    Drawer.content


toolbarSpacer : List (Property m) -> List (Html m) -> Html m
toolbarSpacer =
    Drawer.toolbarSpacer


type alias Store s =
    Drawer.Store s


render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render =
    Drawer.render className


react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Drawer.react


subs : (Material.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Drawer.subs


subscriptions : Model -> Sub Msg
subscriptions =
    Drawer.subscriptions


toggleOn : (Material.Msg.Msg m -> m) -> Index -> String -> Options.Property c m
toggleOn lift index event =
    Options.on event (Json.succeed (lift (Material.Msg.DrawerMsg index (Material.Internal.Drawer.Toggle True))))


className : String
className =
    "mdc-drawer--persistent"
