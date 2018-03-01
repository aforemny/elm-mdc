module Material.Dialog
    exposing
        ( accept
        , backdrop
        , body
        , cancel
        , footer
        , header
        , open
        , scrollable
        , surface
        , title
        , view

        , openOn

        , Model
        , defaultModel
        , react
        , render
        )

{-| From the [Material Design Lite documentation](https://getmdl.io/components/#cards-section):

> The Material Design Lite (MDL) dialog component allows for verification of user
> actions, simple data input, and alerts to provide extra information to users.
>
> To use the dialog component, you must be using a browser that supports the
> dialog element. Only Chrome and Opera have native support at the time of
> writing. For other browsers you will need to include the dialog polyfill
> or create your own.

Refer to [this site](http://debois.github.io/elm-mdl/#dialog)
for a live demo.

@docs view
@docs open
@docs surface
@docs backdrop
@docs body
@docs scrollable
@docs header
@docs title
@docs footer
@docs cancel
@docs accept
-}

import DOM
import Html exposing (..)
import Json.Decode as Json exposing (Decoder)
import Material.Button as Button
import Material.Component as Component exposing (Index, Indexed)
import Material.Internal.Dialog exposing (Msg(..))
import Material.Internal.Options as Internal
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when) 


type alias Model =
    { open : Bool
    , animating : Bool
    }


defaultModel : Model
defaultModel =
    { open = False
    , animating = False
    }


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
    : (Material.Msg.Msg m -> msg)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd msg )
react =
    Component.react get set Material.Msg.DialogMsg update


render
    : (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m       
render lift index store options =
    Component.render get view Material.Msg.DialogMsg lift index store
        (Internal.dispatch lift :: options)


{-| Dialog configuration options
-}
type alias Config =
    {}


{-| Default dialog configuration
-}
defaultConfig : Config
defaultConfig =
    {}


{-| Dialog property
-}
type alias Property m =
    Options.Property Config m


{-| Dialog view
-}
view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options =
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


{-| Make the dialog visible
-}
open : Property m
open =
    Options.many
    [ cs "mdc-dialog--open"
    ]


{-| Dialog surface
-}
surface : List (Property m) -> List (Html m) -> Html m
surface options =
    styled Html.div (cs "mdc-dialog__surface" :: options)


{-| Dialog backdrop
-}
backdrop : List (Property m) -> List (Html m) -> Html m
backdrop options =
    styled Html.div (cs "mdc-dialog__backdrop" :: options)


{-| Dialog body
-}
body : List (Property m) -> List (Html m) -> Html m
body options =
    styled Html.div (cs "mdc-dialog__body"::options)


{-| Make the dialog's body scrollable
-}
scrollable : Property m
scrollable =
    cs "mdc-dialog__body--scrollable"


{-| Dialog header
-}
header : List (Property m) -> List (Html m) -> Html m
header options =
    styled Html.div (cs "mdc-dialog__header"::options)


{-| Dialog title
-}
title : Options.Property c m
title =
    cs "mdc-dialog__header__title"


{-| Dialog footer
-}
footer : List (Property m) -> List (Html m) -> Html m
footer options =
    styled Html.div (cs "mdc-dialog__footer"::options)


cancel : Button.Property m
cancel =
    cs "mdc-dialog__footer__button mdc-dialog__footer__button--cancel"


accept : Button.Property m
accept =
    cs "mdc-dialog__footer__button mdc-dialog__footer__button--accept"


openOn : (Material.Msg.Msg m -> m) -> List Int -> String -> Options.Property c m
openOn lift index event =
    Options.on event (Json.succeed (lift (Material.Msg.DialogMsg index Open)))


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
