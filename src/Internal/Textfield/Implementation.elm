module Internal.Textfield.Implementation
    exposing
        ( Property
        , box
        , cols
        , dense
        , disabled
        , email
        , fullwidth
        , iconUnclickable
        , invalid
        , label
        , leadingIcon
        , nativeControl
        , outlined
        , password
        , pattern
        , placeholder
        , react
        , required
        , rows
        , textarea
        , trailingIcon
        , type_
        , value
        , view
        )

import DOM
import Html exposing (Html, text)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Internal.Ripple.Implementation as Ripple
import Internal.Textfield.Model exposing (Geometry, Model, Msg(..), defaultGeometry, defaultModel)
import Json.Decode as Json exposing (Decoder)
import Json.Encode as Encode
import Regex
import Svg
import Svg.Attributes


type alias Config m =
    { labelText : Maybe String
    , labelFloat : Bool
    , value : Maybe String
    , defaultValue : Maybe String
    , disabled : Bool
    , dense : Bool
    , required : Bool
    , type_ : Maybe String
    , box : Bool
    , pattern : Maybe String
    , textarea : Bool
    , fullWidth : Bool
    , invalid : Bool
    , outlined : Bool
    , leadingIcon : Maybe String
    , trailingIcon : Maybe String
    , iconClickable : Bool
    , placeholder : Maybe String
    , cols : Maybe Int
    , rows : Maybe Int
    , nativeControl : List (Options.Property () m)
    , id_ : String
    }


defaultConfig : Config m
defaultConfig =
    { labelText = Nothing
    , labelFloat = False
    , value = Nothing
    , defaultValue = Nothing
    , disabled = False
    , dense = False
    , required = False
    , type_ = Just "text"
    , box = False
    , pattern = Nothing
    , textarea = False
    , fullWidth = False
    , invalid = False
    , outlined = False
    , leadingIcon = Nothing
    , trailingIcon = Nothing
    , iconClickable = True
    , placeholder = Nothing
    , cols = Nothing
    , rows = Nothing
    , nativeControl = []
    , id_ = ""
    }


iconUnclickable : Property m
iconUnclickable =
    Options.option (\config -> { config | iconClickable = False })


leadingIcon : String -> Property m
leadingIcon icon =
    Options.option (\config -> { config | leadingIcon = Just icon })


trailingIcon : String -> Property m
trailingIcon icon =
    Options.option (\config -> { config | trailingIcon = Just icon })


outlined : Property m
outlined =
    Options.option (\config -> { config | outlined = True })


type alias Property m =
    Options.Property (Config m) m


label : String -> Property m
label =
    Options.option
        << (\str config -> { config | labelText = Just str })


value : String -> Property m
value =
    Options.option
        << (\str config -> { config | value = Just str })


disabled : Property m
disabled =
    Options.option
        (\config -> { config | disabled = True })


password : Property m
password =
    Options.option (\config -> { config | type_ = Just "password" })


email : Property m
email =
    Options.option (\config -> { config | type_ = Just "email" })


box : Property m
box =
    Options.option (\config -> { config | box = True })


pattern : String -> Property m
pattern pattern =
    Options.option (\config -> { config | pattern = Just pattern })


rows : Int -> Property m
rows rows =
    Options.option (\config -> { config | rows = Just rows })


cols : Int -> Property m
cols cols =
    Options.option (\config -> { config | cols = Just cols })


dense : Property m
dense =
    Options.option (\config -> { config | dense = True })


required : Property m
required =
    Options.option (\config -> { config | required = True })


type_ : String -> Property m
type_ =
    Options.option << (\value config -> { config | type_ = Just value })


fullwidth : Property m
fullwidth =
    Options.option (\config -> { config | fullWidth = True })


invalid : Property m
invalid =
    Options.option (\config -> { config | invalid = True })


textarea : Property m
textarea =
    Options.option (\config -> { config | textarea = True })


placeholder : String -> Property m
placeholder placeholder =
    Options.option (\config -> { config | placeholder = Just placeholder })


nativeControl : List (Options.Property () m) -> Property m
nativeControl =
    Options.nativeControl


update : (Msg -> m) -> Msg -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    case msg of
        Input str ->
            let
                dirty =
                    str /= ""
            in
            ( Just { model | value = Just str, isDirty = dirty }, Cmd.none )

        Blur ->
            let
                geometry =
                    case model.value of
                        Nothing ->
                            Nothing

                        Just _ ->
                            model.geometry
            in
            ( Just { model | focused = False, geometry = geometry }, Cmd.none )

        Focus geometry ->
            ( Just { model | focused = True, geometry = Just geometry }, Cmd.none )

        NoOp ->
            ( Just model, Cmd.none )

        RippleMsg msg_ ->
            let
                ( ripple, effects ) =
                    Ripple.update msg_ model.ripple
            in
            ( Just { model | ripple = ripple }, Cmd.map (lift << RippleMsg) effects )


textField : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
textField lift model options _ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        isDirty =
            model.isDirty || Maybe.withDefault False (Maybe.map ((/=) "") config.value)

        focused =
            model.focused && not config.disabled

        ripple =
            Ripple.view False (lift << RippleMsg) model.ripple []

        isInvalid =
            (||) config.invalid <|
                case config.pattern of
                    Just pattern ->
                        model.value
                            |> Maybe.map (not << Regex.contains (Regex.regex ("^" ++ pattern ++ "$")))
                            |> Maybe.withDefault False

                    Nothing ->
                        False
    in
    Options.apply summary
        Html.div
        [ cs "mdc-text-field"
        , cs "mdc-text-field--upgraded"
        , cs "mdc-text-field--focused" |> when focused
        , cs "mdc-text-field--disabled" |> when config.disabled
        , cs "mdc-text-field--dense" |> when config.dense
        , cs "mdc-text-field--fullwidth" |> when config.fullWidth
        , cs "mdc-text-field--invalid" |> when isInvalid
        , cs "mdc-text-field--textarea" |> when config.textarea
        , cs "mdc-text-field--outlined" |> when config.outlined
        , cs "mdc-text-field--with-leading-icon"
            |> when ((config.leadingIcon /= Nothing) && (config.trailingIcon == Nothing))
        , cs "mdc-text-field--with-trailing-icon"
            |> when (config.trailingIcon /= Nothing)
        , when (config.box || config.outlined) <|
            ripple.interactionHandler
        , when config.box
            << Options.many
          <|
            [ cs "mdc-text-field--box"
            , ripple.properties
            ]
        ]
        []
        (List.concat
            [ [ Options.applyNativeControl summary
                    (if config.textarea then
                        Html.textarea
                     else
                        Html.input
                    )
                    [ cs "mdc-text-field__input"
                    , css "outline" "none"
                    , Options.id config.id_
                    , if config.outlined then
                        Options.on "focus" (Json.map (lift << Focus) decodeGeometry)
                      else
                        Options.on "focus" (Json.succeed (lift (Focus defaultGeometry)))
                    , Options.onBlur (lift Blur)
                    , Options.onInput (lift << Input)
                    , Options.many
                        << List.map Options.attribute
                        << List.filterMap identity
                      <|
                        [ Html.type_ (Maybe.withDefault "text" config.type_)
                            |> (if not config.textarea then
                                    Just
                                else
                                    always Nothing
                               )
                        , Html.disabled True
                            |> (if config.disabled then
                                    Just
                                else
                                    always Nothing
                               )
                        , Html.property "required" (Encode.bool True)
                            |> (if config.required then
                                    Just
                                else
                                    always Nothing
                               )
                        , Html.property "pattern" (Encode.string (Maybe.withDefault "" config.pattern))
                            |> (if config.pattern /= Nothing then
                                    Just
                                else
                                    always Nothing
                               )
                        , Html.attribute "outline" "medium none"
                            |> Just
                        , Html.value (Maybe.withDefault "" config.value)
                            |> (if config.value /= Nothing then
                                    Just
                                else
                                    always Nothing
                               )
                        ]
                    , -- Note: prevent ripple:
                      Options.many
                        [ Options.onWithOptions "keydown"
                            { preventDefault = False
                            , stopPropagation = True
                            }
                            (Json.succeed (lift NoOp))
                        , Options.onWithOptions "keyup"
                            { preventDefault = False
                            , stopPropagation = True
                            }
                            (Json.succeed (lift NoOp))
                        ]
                    , when (config.placeholder /= Nothing) <|
                        Options.attribute <|
                            Html.placeholder (Maybe.withDefault "" config.placeholder)
                    , when (config.textarea && (config.rows /= Nothing)) <|
                        Options.attribute <|
                            Html.rows (Maybe.withDefault 0 config.rows)
                    , when (config.textarea && (config.cols /= Nothing)) <|
                        Options.attribute <|
                            Html.cols (Maybe.withDefault 0 config.cols)
                    ]
                    []
              , if not config.fullWidth then
                    styled Html.label
                        [ cs "mdc-floating-label"
                        , cs "mdc-floating-label--float-above" |> when (focused || isDirty)
                        , Options.for config.id_
                        ]
                        (case config.labelText of
                            Just str ->
                                [ text str ]

                            Nothing ->
                                []
                        )
                else
                    text ""
              ]
            , if not config.outlined && not config.textarea && not config.fullWidth then
                [ styled Html.div
                    [ cs "mdc-line-ripple"
                    , cs "mdc-line-ripple--active" |> when model.focused
                    ]
                    []
                ]
              else
                []
            , if config.outlined then
                let
                    isRtl =
                        False

                    d =
                        let
                            { labelWidth, width, height } =
                                model.geometry
                                    |> Maybe.withDefault defaultGeometry

                            radius =
                                4

                            cornerWidth =
                                radius + 1.2

                            leadingStrokeLength =
                                abs (11 - cornerWidth)

                            labelScale =
                                if config.dense then
                                    0.923
                                else
                                    0.75

                            scaledLabelWidth =
                                labelScale * labelWidth

                            paddedLabelWidth =
                                scaledLabelWidth + 8

                            pathMiddle =
                                [ "a"
                                , toString radius
                                , ","
                                , toString radius
                                , " 0 0 1 "
                                , toString radius
                                , ","
                                , toString radius
                                , "v"
                                , toString (height - (2 * cornerWidth))
                                , "a"
                                , toString radius
                                , ","
                                , toString radius
                                , " 0 0 1 "
                                , toString -radius
                                , ","
                                , toString radius
                                , "h"
                                , toString (-width + (2 * cornerWidth))
                                , "a"
                                , toString radius
                                , ","
                                , toString radius
                                , " 0 0 1 "
                                , toString -radius
                                , ","
                                , toString -radius
                                , "v"
                                , toString (-height + (2 * cornerWidth))
                                , "a"
                                , toString radius
                                , ","
                                , toString radius
                                , " 0 0 1 "
                                , toString radius
                                , ","
                                , toString -radius
                                ]
                                    |> String.join ""
                        in
                        if not isRtl then
                            [ "M"
                            , toString (cornerWidth + leadingStrokeLength + paddedLabelWidth)
                            , ",1h"
                            , toString (width - (2 * cornerWidth) - paddedLabelWidth - leadingStrokeLength)
                            , pathMiddle
                            , "h"
                            , toString leadingStrokeLength
                            ]
                                |> String.join ""
                        else
                            [ "M"
                            , toString (width - cornerWidth - leadingStrokeLength)
                            , ",1h"
                            , toString leadingStrokeLength
                            , pathMiddle
                            , "h"
                            , toString (width - (2 * cornerWidth) - paddedLabelWidth - leadingStrokeLength)
                            ]
                                |> String.join ""
                in
                [ styled Html.div
                    [ cs "mdc-notched-outline"
                    , cs "mdc-notched-outline--notched" |> when (focused || isDirty)
                    ]
                    [ Svg.svg []
                        [ Svg.path
                            [ Svg.Attributes.class "mdc-notched-outline__path"
                            , Svg.Attributes.d d
                            ]
                            []
                        ]
                    ]
                , styled Html.div
                    [ cs "mdc-notched-outline__idle"
                    ]
                    []
                ]
              else
                []
            , let
                icon =
                    config.leadingIcon
                        |> Maybe.map Just
                        |> Maybe.withDefault config.trailingIcon
              in
              case icon of
                Just icon ->
                    [ styled Html.i
                        [ cs "material-icons mdc-text-field__icon"
                        , Options.attribute
                            << Html.tabindex
                          <|
                            if config.iconClickable then
                                0
                            else
                                -1
                        ]
                        [ text icon
                        ]
                    ]

                Nothing ->
                    []
            , [ ripple.style
              ]
            ]
        )


type alias Store s =
    { s | textfield : Indexed Model }


( get, set ) =
    Component.indexed .textfield (\x c -> { c | textfield = x }) defaultModel


react :
    (Internal.Msg.Msg m -> msg)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd msg )
react =
    Component.react get set Internal.Msg.TextfieldMsg update


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    \lift index store options ->
        Component.render get
            textField
            Internal.Msg.TextfieldMsg
            lift
            index
            store
            (Options.id_ index :: options)


decodeGeometry : Decoder Geometry
decodeGeometry =
    DOM.target <|
        -- .mdc-text-field__input
        DOM.parentElement
        <|
            -- .mdc-text-field
            Json.map3 Geometry
                (DOM.childNode 2 DOM.offsetWidth)
                -- .mdc-text-field__outline
                (DOM.childNode 2 DOM.offsetHeight)
                -- .mdc-text-field__outline
                (DOM.childNode 1 DOM.offsetWidth)



-- .mdc-text-field__label
