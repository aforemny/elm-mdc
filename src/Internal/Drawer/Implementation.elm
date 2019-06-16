module Internal.Drawer.Implementation exposing
    ( Config
    , Property
    , Store
    , content
    , defaultConfig
    , emit
    , header
    , onClose
    , open
    , react
    , render
    , subTitle
    , title
    , update
    , view
    )

import Html exposing (Html)
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Drawer.Model exposing (Model, Msg(..), defaultModel)
import Internal.GlobalEvents as GlobalEvents
import Internal.Helpers as Helpers
import Internal.Msg
import Internal.Options as Options exposing (cs, styled, when)
import Json.Decode as Decode


update : (Msg -> m) -> Msg -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    case msg of
        NoOp ->
            ( Nothing, Cmd.none )

        StartAnimation isOpen ->
            ( Just
                { model
                    | open = True
                    , closeOnAnimationEnd = not isOpen
                    , animating = True
                }
            , Cmd.none
            )

        EndAnimation ->
            ( Just
                { model
                    | open =
                        if model.closeOnAnimationEnd then
                            False

                        else
                            model.open
                    , animating = False
                    , closeOnAnimationEnd = False
                }
            , Cmd.none
            )


type alias Config m =
    { onClose : Maybe m
    , open : Bool
    }


defaultConfig : Config m
defaultConfig =
    { onClose = Nothing
    , open = False
    }


type alias Property m =
    Options.Property (Config m) m


view : String -> (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view className lift model options nodes =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        stateChanged =
            not model.closeOnAnimationEnd && (config.open /= model.open)
    in
    styled Html.aside
        ([ cs "mdc-drawer"
         , cs className
         , when stateChanged <|
            GlobalEvents.onTick (Decode.succeed (lift (StartAnimation config.open)))

         -- In order for the closing animation to work, we need to
         -- keep the open class till the animation has ended
         , cs "mdc-drawer--open" |> when (config.open || model.open)

         -- Animate class needs to kick in as soon as drawer is
         -- opened. It's only used during opening.
         , cs "mdc-drawer--animate" |> when (config.open && (stateChanged || model.animating))

         -- Wait a frame once display is no longer "none", to establish basis for animation
         , cs "mdc-drawer--opening" |> when (config.open && model.animating)
         , cs "mdc-drawer--closing" |> when (not config.open && model.animating)
         , when model.animating (Options.on "transitionend" (Decode.succeed (lift EndAnimation)))
         , Options.data "focustrap" "{}" |> when (not (String.isEmpty className) && (config.open || model.open))
         , Options.on "keydown" <|
            Decode.map2
                (\key keyCode ->
                    if key == Just "Escape" || keyCode == 27 then
                        Maybe.withDefault (lift NoOp) config.onClose

                    else
                        lift NoOp
                )
                (Decode.oneOf
                    [ Decode.map Just (Decode.at [ "key" ] Decode.string)
                    , Decode.succeed Nothing
                    ]
                )
                (Decode.at [ "keyCode" ] Decode.int)
         ]
            ++ options
        )
        nodes


header : List (Property m) -> List (Html m) -> Html m
header options =
    styled Html.header (cs "mdc-drawer__header" :: options)


content : List (Property m) -> List (Html m) -> Html m
content options =
    styled Html.div (cs "mdc-drawer__content" :: options)


type alias Store s =
    { s | drawer : Indexed Model }


getSet :
    { get : Index -> { a | drawer : Indexed Model } -> Model
    , set :
        Index
        -> { a | drawer : Indexed Model }
        -> Model
        -> { a | drawer : Indexed Model }
    }
getSet =
    Component.indexed .drawer (\x y -> { y | drawer = x }) defaultModel


render :
    String
    -> (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render className =
    Component.render getSet.get (view className) Internal.Msg.DrawerMsg


react :
    (Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.DrawerMsg update


onClose : m -> Property m
onClose handler =
    Options.option (\config -> { config | onClose = Just handler })


open : Property m
open =
    Options.option (\config -> { config | open = True })


emit : (Internal.Msg.Msg m -> m) -> Index -> Msg -> Cmd m
emit lift idx msg =
    Helpers.cmd (lift (Internal.Msg.DrawerMsg idx msg))


title : Property m
title =
    cs "mdc-drawer__title"


subTitle : Property m
subTitle =
    cs "mdc-drawer__subtitle"
