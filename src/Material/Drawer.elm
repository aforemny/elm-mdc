module Material.Drawer exposing
    ( close
    , Config
    , content
    , defaultConfig
    , defaultModel
    , emit
    , header
    , headerContent
    , Model
    , Msg
    , open
    , Property
    , react
    , render
    , Store
    , subs
    , subscriptions
    , toggle
    , toolbarSpacer
    , update
    , view
    )

import Html exposing (Html, text)
import Json.Decode as Json exposing (Decoder)
import Material.Component as Component exposing (Indexed)
import Material.Helpers as Helpers
import Material.Internal.Drawer exposing (Msg(..))
import Material.Internal.Options as Internal
import Material.List as Lists
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
            ( Just
              { model | state = Just model.open
              , animating = False
              }
            ,
              Cmd.none
            )

        Click ->
              if model.persistent then
                  ( Nothing, Cmd.none )
              else
                  update fwd Close model

        Open persistent ->
            ( Just
              { model
              | open = True
              , state = Nothing
              , animating = True
              , persistent = persistent
              }
            , Cmd.none
            )

        Close ->
            ( Just
              { model | open = False
              , state = Nothing
              , animating = True
              }
            ,
              Cmd.none
            )

        Toggle persistent ->
            if model.open then
                update fwd Close model
            else
                update fwd (Open persistent) model


type alias Config =
    {}


defaultConfig : Config
defaultConfig =
    {}


type alias Property m =
    Options.Property Config m


view : String -> (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view className lift model options nodes =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options
    in
    styled Html.aside
    [ cs "mdc-drawer"
    , cs className
    , cs ("mdc-drawer--open") |> when model.open
    , cs ("mdc-drawer--animating") |> when model.animating
    ]
    [ styled Html.nav
      ( cs "mdc-drawer__drawer"
      :: Options.onWithOptions "click"
         { stopPropagation = True
         , preventDefault = False
         }
         (Json.succeed (lift NoOp))
      :: when model.open (css "transform" "translateX(0)")
      :: when model.animating ( Options.on "transitionend" (Json.succeed (lift Tick)) )
      :: options
      )
      nodes
    ]


header : List (Property m) -> List (Html m) -> Html m
header options =
    styled Html.header (cs "mdc-drawer__header" :: options)


headerContent : List (Property m) -> List (Html m) -> Html m
headerContent options =
    styled Html.div (cs "mdc-drawer__header-content" :: options)


content : Lists.Property m
content =
    cs "mdc-drawer__content"


toolbarSpacer : List (Property m) -> List (Html m) -> Html m
toolbarSpacer options =
    styled Html.div (cs "mdc-drawer__toolbar-spacer" :: options)


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
