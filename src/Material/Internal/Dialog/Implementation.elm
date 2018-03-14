module Material.Internal.Dialog.Implementation exposing
    ( accept
    , backdrop
    , body
    , Property
    , cancel
    , footer
    , header
    , open
    , scrollable
    , surface
    , title
    , view
    , openOn
    , react
    )

import DOM
import Html exposing (..)
import Json.Decode as Json exposing (Decoder)
import Material.Internal.Button.Implementation as Button
import Material.Internal.Component as Component exposing (Index, Indexed)
import Material.Internal.Dialog.Model exposing (Model, defaultModel, Msg(..))
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (styled, cs, css, when) 
import Material.Internal.Options.Internal as Internal


update : (Msg -> m) -> Msg -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    case msg of
        NoOp ->
            ( Nothing, Cmd.none )

        Open ->
            ( Just { model | open = True, animating = True }, Cmd.none )

        Close ->
            ( Just { model | open = False, animating = True }, Cmd.none )

        AnimationEnd ->
            ( Just { model | animating = False }, Cmd.none )


type alias Store s =
    { s | dialog : Indexed Model }


( get, set ) =
    Component.indexed .dialog (\x c -> { c | dialog = x }) defaultModel


react
    : (Material.Internal.Msg.Msg m -> msg)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd msg )
react =
    Component.react get set Material.Internal.Msg.DialogMsg update


view
    : (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m       
view lift index store options =
    Component.render get dialog Material.Internal.Msg.DialogMsg lift index store
        (Internal.dispatch lift :: options)


type alias Config =
    {}


defaultConfig : Config
defaultConfig =
    {}


type alias Property m =
    Options.Property Config m


dialog : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
dialog lift model options =
    styled Html.aside
    ( cs "mdc-dialog"
    :: ( when model.open << Options.many <|
         [ cs "mdc-dialog--open"
         , Options.data "focustrap" "mdc-dialog__footer__button--accept"
         ]
       )
    :: when model.animating (cs "mdc-dialog--animating")
    :: Options.on "click" (Json.map lift close)
    :: Options.on "transitionend" (Json.succeed (lift AnimationEnd))
    :: options
    )


open : Property m
open =
    cs "mdc-dialog--open"


surface : List (Property m) -> List (Html m) -> Html m
surface options =
    styled Html.div (cs "mdc-dialog__surface" :: options)


backdrop : List (Property m) -> List (Html m) -> Html m
backdrop options =
    styled Html.div (cs "mdc-dialog__backdrop" :: options)


body : List (Property m) -> List (Html m) -> Html m
body options =
    styled Html.div (cs "mdc-dialog__body"::options)


scrollable : Property m
scrollable =
    cs "mdc-dialog__body--scrollable"


header : List (Property m) -> List (Html m) -> Html m
header options =
    styled Html.div (cs "mdc-dialog__header"::options)


title : Options.Property c m
title =
    cs "mdc-dialog__header__title"


footer : List (Property m) -> List (Html m) -> Html m
footer options =
    styled Html.div (cs "mdc-dialog__footer"::options)


cancel : Button.Property m
cancel =
    cs "mdc-dialog__footer__button mdc-dialog__footer__button--cancel"


accept : Button.Property m
accept =
    cs "mdc-dialog__footer__button mdc-dialog__footer__button--accept"


openOn : (Material.Internal.Msg.Msg m -> m) -> Index -> String -> Options.Property c m
openOn lift index event =
    Options.on event (Json.succeed (lift (Material.Internal.Msg.DialogMsg index Open)))


close : Decoder Msg
close =
    DOM.target <|
    Json.map (\ className ->
         let
           hasClass class =
               String.contains (" " ++ class ++ " ") (" " ++ className ++ " ")
         in
         if hasClass "mdc-dialog__backdrop" then
             Close
         else if hasClass "mdc-dialog__footer__button" then
             Close
         else
             NoOp
       )
       (Json.at ["className"] Json.string)
