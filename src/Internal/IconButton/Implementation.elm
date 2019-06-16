module Internal.IconButton.Implementation exposing
    ( Property
    , className
    , disabled
    , icon
    , icon1
    , iconElement
    , label
    , label1
    , on
    , onIconElement
    , react
    , view
    )

import Html exposing (Html, text)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.IconButton.Model exposing (Model, Msg(..), defaultModel)
import Internal.Msg
import Internal.Options as Options exposing (cs, styled, when)
import Internal.Ripple.Implementation as Ripple


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RippleMsg msg_ ->
            let
                ( ripple, effects ) =
                    Ripple.update msg_ model.ripple
            in
            ( { model | ripple = ripple }, Cmd.map RippleMsg effects )


type alias Config =
    { on : Bool
    , label : { on : String, off : String }
    , disabled : Bool
    , icon : { on : String, off : String }
    , alternativeIconLibrary : Maybe String
    }


defaultConfig : Config
defaultConfig =
    { on = False
    , label = { on = "", off = "" }
    , disabled = False
    , icon = { on = "", off = "" }
    , alternativeIconLibrary = Nothing
    }


type alias Property m =
    Options.Property Config m


on : Property m
on =
    Options.option (\config -> { config | on = True })


className : String -> Property m
className value =
    Options.option (\config -> { config | alternativeIconLibrary = Just value })


icon : { on : String, off : String } -> Property m
icon value =
    Options.option (\config -> { config | icon = value })


icon1 : String -> Property m
icon1 value =
    icon { on = value, off = value }


label : { on : String, off : String } -> Property m
label value =
    Options.option (\config -> { config | label = value })


label1 : String -> Property m
label1 value =
    label { on = value, off = value }


disabled : Property m
disabled =
    Options.option (\config -> { config | disabled = True })


iconElement : Property m
iconElement =
    cs "mdc-icon-button__icon"


onIconElement : Property m
onIconElement =
    cs "mdc-icon-button__icon--on"


iconButton : Index -> (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
iconButton domId lift model options list =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        ripple =
            Ripple.view True domId (lift << RippleMsg) model.ripple []

        isToggle =
            config.icon.on /= config.icon.off

        icons =
            [ styled Html.i
                [ iconElement
                , cs "material-icons"
                , onIconElement
                ]
                [ text config.icon.on ]
            , styled Html.i
                [ iconElement
                , cs "material-icons"
                ]
                [ text config.icon.off ]
            ]
    in
    Options.apply summary
        Html.button
        [ cs "mdc-icon-button"
        , cs "material-icons" |> when (config.alternativeIconLibrary == Nothing)
        , cs "mdc-icon-button--on" |> when config.on
        , Options.aria "label"
            (if config.on then
                config.label.on

             else
                config.label.off
            )
        , Options.aria "hidden" "True" |> when isToggle
        , Options.aria "pressed" "True" |> when (isToggle && config.on)
        , Options.aria "pressed" "False" |> when (isToggle && not config.on)
        , Options.attribute (Html.disabled True) |> when config.disabled
        , Options.many
            [ ripple.interactionHandler
            , ripple.properties
            ]
        ]
        []
        (list
            ++ (if config.alternativeIconLibrary /= Nothing then
                    [ styled Html.i
                        [ cs (Maybe.withDefault "material-icons" config.alternativeIconLibrary)
                        , if config.on then
                            cs config.icon.on

                          else
                            cs config.icon.off
                        ]
                        []
                    ]

                else if config.icon.on == config.icon.off then
                    [ text config.icon.on
                    ]

                else
                    icons
               )
        )


type alias Store s =
    { s
        | iconButton : Indexed Model
    }


getSet :
    { get : Index -> { a | iconButton : Indexed Model } -> Model
    , set :
        Index
        -> { a | iconButton : Indexed Model }
        -> Model
        -> { a | iconButton : Indexed Model }
    }
getSet =
    Component.indexed .iconButton (\x y -> { y | iconButton = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.IconButtonMsg (Component.generalise update)


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    \lift index ->
        Component.render getSet.get (iconButton index) Internal.Msg.IconButtonMsg lift index
