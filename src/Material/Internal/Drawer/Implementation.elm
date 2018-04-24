module Material.Internal.Drawer.Implementation exposing
    ( close
    , Config
    , content
    , defaultConfig
    , emit
    , header
    , headerContent
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
import Material.Internal.Component as Component exposing (Indexed, Index)
import Material.Internal.Drawer.Model exposing (Model, defaultModel, Msg(..))
import Material.Internal.Helpers as Helpers
import Material.Internal.List.Implementation as Lists
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (cs, css, styled, many, when)
import Mouse


update : (Msg -> m) -> Msg -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
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
                  update lift Close model

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
                update lift Close model
            else
                update lift (Open persistent) model


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
            Options.collect defaultConfig options
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
         { stopPropagation = (className == "mdc-drawer--temporary")
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
    -> (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render className =
    Component.render get (view className) Material.Internal.Msg.DrawerMsg


react :
    (Material.Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Internal.Msg.DrawerMsg update


subs : (Material.Internal.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Material.Internal.Msg.DrawerMsg .drawer subscriptions


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


emit : (Material.Internal.Msg.Msg m -> m) -> Index -> Msg -> Cmd m
emit lift idx msg =
    Helpers.cmd (lift (Material.Internal.Msg.DrawerMsg idx msg))
