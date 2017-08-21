module Material.Drawer.Temporary
    exposing
        ( -- VIEW
          view
        , Property

        , header
        , headerContent
        , content
        
          -- TEA
        , subscriptions
        , open
        , close
        , toggle
        , Model
        , defaultModel
        , Msg
        , update

          -- RENDER
        , subs
        , emit
        , render
        , Store
        , react
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
@docs header, headerContent, content

## TEA architecture
@docs subscriptions, Model, defaultModel, Msg, update
@docs open, close, toggle

## Featured render
@docs subs, emit, render
@docs Store, react
-}

import Html exposing (Html, text)
import Material.Drawer as Drawer
import Material.Msg exposing (Index)


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


type alias Config m =
    Drawer.Config m


defaultConfig : Config m
defaultConfig =
    Drawer.defaultConfig


type alias Property m =
    Drawer.Property m


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


open : Msg
open =
    Drawer.open False


close : Msg
close =
    Drawer.close


toggle : Msg
toggle =
    Drawer.toggle False


emit : (Material.Msg.Msg m -> m) -> Index -> Msg -> Cmd m
emit =
    Drawer.emit


className : String
className =
    "mdc-temporary-drawer"
