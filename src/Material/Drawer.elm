module Material.Drawer
    exposing
        ( -- VIEW
          view
        , Property
        , Config
        , defaultConfig

        , header
        , headerContent
        , content
        , toolbarSpacer

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
import Json.Decode as Json exposing (Decoder)
import Material.Component as Component exposing (Indexed)
import Material.Helpers as Helpers
import Material.Internal.Drawer exposing (Msg(..))
import Material.Internal.Options as Internal
import Material.Msg exposing (Index)
import Material.Options as Options exposing (Style, cs, css, styled, many, when, maybe)
import Mouse


type alias Model =
    { open : Bool
    , state : Maybe Bool
    , animating : Bool
    , persistent : Bool
    }


defaultModel : Model
defaultModel =
    { open = False
    , state = Nothing
    , animating = False
    , persistent = False
    }


type alias Msg
    = Material.Internal.Drawer.Msg


update : x -> Msg -> Model -> ( Maybe Model, Cmd m )
update fwd msg model =
    case msg of
        NoOp ->
            ( Nothing, Cmd.none )

        Tick ->
            ( Just { model | state = Just model.open
            , animating = False
            }
            , Cmd.none )

        Click ->
              if model.persistent then
                  ( Nothing, Cmd.none )
              else
                  update fwd Close model

        Open persistent ->
            ( Just { model
            | open = True
            , state = Nothing
            , animating = True
            , persistent = persistent
            }
            , Cmd.none )

        Close ->
            ( Just { model | open = False
            , state = Nothing
            , animating = True
            }
            , Cmd.none )

        Toggle persistent ->
            if model.open then
                update fwd Close model
            else
                update fwd (Open persistent) model


type alias Config m =
    { input : List (Options.Style m)
    , container : List (Options.Style m)
    , value : Bool
    }


defaultConfig : Config m
defaultConfig =
    { input = []
    , container = []
    , value = False
    }


type alias Property m =
    Options.Property (Config m) m


view : String -> (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view className lift model options nodes =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

--        persistent =
--            className == "mdc-persistent-drawer"
    in
    Internal.applyContainer summary Html.div
    [ cs className
    , cs (modifier className "open") |> when model.open
    , cs (modifier className "animating") |> when model.animating
    ]
    [ styled Html.nav
      ( cs (element className "drawer")
      :: Options.onWithOptions "click"
         { stopPropagation = False
         , preventDefault = False
         }
         (Json.succeed (lift NoOp))
      :: when model.open (css "transform" "translateX(0)")
      :: when model.animating ( Options.on "transitionend" (Json.succeed (lift Tick)) )
      :: options
      )
      nodes
    ]


header : String -> List (Property m) -> List (Html m) -> Html m
header className options =
    styled Html.header
    ( cs (element className "header")
    :: options
    )


headerContent : String -> List (Property m) -> List (Html m) -> Html m
headerContent className options =
    styled Html.div
    ( cs (element className "header-content")
    :: options
    )


content : String -> List (Property m) -> List (Html m) -> Html m
content className options =
    styled Html.nav
    ( cs (element className "content")
    :: options
    )


toolbarSpacer : List (Property m) -> List (Html m) -> Html m
toolbarSpacer options =
    styled Html.div
    ( cs "mdc-persistent-drawer__toolbar-spacer"
    :: options
    )


type alias Store s =
    { s | drawer : Indexed Model }


( get, set ) =
    Component.indexed .drawer (\x y -> { y | drawer = x }) defaultModel


render :
    String
    -> (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render className lift index store options =
    Component.render get (view className) Material.Msg.DrawerMsg lift index store
        (Internal.dispatch lift :: options)


react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.DrawerMsg update


subs : (Material.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Material.Msg.DrawerMsg .drawer subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.open then
        Mouse.clicks (\_ -> Click)
    else
        Sub.none


open : Bool -> Msg
open persistent =
    Open persistent


close : Msg
close =
    Close


toggle : Bool -> Msg
toggle persistent =
    Toggle persistent


emit : (Material.Msg.Msg m -> m) -> Index -> Msg -> Cmd m
emit lift idx msg =
    Helpers.cmd (lift (Material.Msg.DrawerMsg idx msg))


element : String -> String -> String
element className name =
    className ++ "__" ++ name


modifier : String -> String -> String
modifier className name =
    className ++ "--" ++ name
