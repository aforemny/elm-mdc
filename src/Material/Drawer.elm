module Material.Drawer
    exposing
        ( Model
        , defaultModel
        , Msg
        , update
        , Config
        , defaultConfig
        , view
        , render
        , react
        , header
        , headerContent
        , content
        , subs
        , subscriptions
        , open
        , close
        , toggle
        , Store
        , Property
        , toolbarSpacer
        )

{-| TODO
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


-- MODEL


{-| Component model.
-}
type alias Model =
    { open : Bool
    , state : Maybe Bool
    , animating : Bool
    , persistent : Bool
    }


{-| Default component model.
-}
defaultModel : Model
defaultModel =
    { open = False
    , state = Nothing
    , animating = False
    , persistent = False
    }



-- ACTION, UPDATE


{-| Component message.
-}
type alias Msg
    = Material.Internal.Drawer.Msg


{-| Component update.
-}
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


-- OPTIONS


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


{-| TODO
-}
type alias Property m =
    Options.Property (Config m) m


-- VIEW


element : String -> String -> String
element className name =
    className ++ "__" ++ name


modifier : String -> String -> String
modifier className name =
    className ++ "--" ++ name


{-| Component view.
-}
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


-- COMPONENT


type alias Store s =
    { s | drawer : Indexed Model }


( get, set ) =
    Component.indexed .drawer (\x y -> { y | drawer = x }) defaultModel


{-| Component react function.
-}
react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.DrawerMsg update


--open : Property m
--open =
--    Internal.option (\config -> { config | open = True })


{-| Component render (drawer)
-}
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


subs : (Material.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Material.Msg.DrawerMsg .drawer subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.open then
        Mouse.clicks (\_ -> Click)
    else
        Sub.none


open : Bool -> (Material.Msg.Msg m -> m) -> Index -> Cmd m
open persistent lift idx =
    Helpers.cmd (lift (Material.Msg.DrawerMsg idx (Open persistent)))


close : (Material.Msg.Msg m -> m) -> Index -> Cmd m
close lift idx =
    Helpers.cmd (lift (Material.Msg.DrawerMsg idx Close))


toggle : Bool -> (Material.Msg.Msg m -> m) -> Index -> Cmd m
toggle permanent lift idx =
    Helpers.cmd (lift (Material.Msg.DrawerMsg idx (Toggle permanent)))


-- persistent


toolbarSpacer : List (Property m) -> List (Html m) -> Html m
toolbarSpacer options =
    styled Html.div
    ( cs "mdc-persistent-drawer__toolbar-spacer"
    :: options
    )
