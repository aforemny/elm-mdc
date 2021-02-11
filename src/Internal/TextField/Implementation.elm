module Internal.TextField.Implementation exposing
    ( Property
    , cols
    , disabled
    , email
    , fullwidth
    , internalCounter
    , invalid
    , label
    , leadingIcon
    , name
    , nativeControl
    , onLeadingIconClick
    , onTrailingIconClick
    , outlined
    , password
    , pattern
    , placeholder
    , prefix
    , react
    , required
    , rows
    , suffix
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
import Internal.Options as Options exposing (cs, styled, when, viewJust)
import Internal.TextField.Model exposing (Geometry, Model, Msg(..), defaultGeometry, defaultModel)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Regex


type alias Config m =
    { labelText : Maybe String
    , labelFloat : Bool
    , value : Maybe String
    , defaultValue : Maybe String
    , disabled : Bool
    , required : Bool
    , prefix : Maybe String
    , suffix : Maybe String
    , type_ : Maybe String
    , name : Maybe String
    , pattern : Maybe String
    , textarea : Bool
    , fullWidth : Bool
    , invalid : Bool
    , outlined : Bool
    , leadingIcon : Maybe String
    , trailingIcon : Maybe String
    , onLeadingIconClick : Maybe m
    , onTrailingIconClick : Maybe m
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
    , required = False
    , prefix = Nothing
    , suffix = Nothing
    , type_ = Just "text"
    , name = Nothing
    , pattern = Nothing
    , textarea = False
    , fullWidth = False
    , invalid = False
    , outlined = False
    , leadingIcon = Nothing
    , trailingIcon = Nothing
    , onLeadingIconClick = Nothing
    , onTrailingIconClick = Nothing
    , placeholder = Nothing
    , cols = Nothing
    , rows = Nothing
    , nativeControl = []
    , id_ = ""
    }


leadingIcon : String -> Property m
leadingIcon icon =
    Options.option (\config -> { config | leadingIcon = Just icon })


trailingIcon : String -> Property m
trailingIcon icon =
    Options.option (\config -> { config | trailingIcon = Just icon })


onLeadingIconClick : m -> Property m
onLeadingIconClick handler =
    Options.option (\config -> { config | onLeadingIconClick = Just handler })


onTrailingIconClick : m -> Property m
onTrailingIconClick handler =
    Options.option (\config -> { config | onTrailingIconClick = Just handler })


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
value value_ =
    Options.option (\config -> { config | value = Just value_ })


disabled : Property m
disabled =
    Options.option
        (\config -> { config | disabled = True })


prefix : String -> Property m
prefix text =
    Options.option
        (\config -> { config | prefix = Just text })


suffix : String -> Property m
suffix text =
    Options.option
        (\config -> { config | suffix = Just text })


password : Property m
password =
    Options.option (\config -> { config | type_ = Just "password" })


email : Property m
email =
    Options.option (\config -> { config | type_ = Just "email" })


pattern : String -> Property m
pattern pattern_ =
    Options.option (\config -> { config | pattern = Just pattern_ })


rows : Int -> Property m
rows value_ =
    Options.option (\config -> { config | rows = Just value_ })


cols : Int -> Property m
cols cols_ =
    Options.option (\config -> { config | cols = Just cols_ })


internalCounter : Property m
internalCounter =
    modifier "with-internal-counter"


required : Property m
required =
    Options.option (\config -> { config | required = True })


type_ : String -> Property m
type_ value_ =
    Options.option (\config -> { config | type_ = Just value_ })


name : String -> Property m
name value_ =
    Options.option (\config -> { config | name = Just value_ })


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
placeholder value_ =
    Options.option (\config -> { config | placeholder = Just value_ })


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


textField : Index -> (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
textField domId lift model options list =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        isDirty =
            model.isDirty || Maybe.withDefault False (Maybe.map ((/=) "") config.value)

        isFilled =
            not config.outlined

        isOutlined =
            config.outlined

        focused =
            model.focused && not config.disabled

        isInvalid =
            (||) config.invalid <|
                case config.pattern of
                    Just pattern_ ->
                        model.value
                            |> Maybe.map2 (\regex -> not << Regex.contains regex)
                                (Regex.fromString ("^" ++ pattern_ ++ "$"))
                            |> Maybe.withDefault False

                    Nothing ->
                        False

        shouldAlwaysFloat =
            case config.type_ of
                Just t ->
                    t == "color" || t == "date" || t == "datetime-local" || t == "month" || t == "range" || t == "time" || t == "week"
                Nothing ->
                    False

        shouldFloat =
            shouldAlwaysFloat || focused || isDirty

        canHaveLabel =
            not (config.fullWidth || config.outlined || config.textarea)

        hasLabel = config.labelText /= Nothing

        htmlLabel =
            styled Html.label
                [ cs "mdc-floating-label"
                , cs "mdc-floating-label--float-above" |> when shouldFloat
                , cs "mdc-floating-label--required" |> when config.required
                , Options.for config.id_
                ]
                (case config.labelText of
                    Just str ->
                        [ text str ]

                    Nothing ->
                        []
                )

        leadingIcon_ =
            iconView lift config.leadingIcon "leading" config.onLeadingIconClick

        trailingIcon_ =
            iconView lift config.trailingIcon "trailing" config.onTrailingIconClick

        input =
            Options.applyNativeControl summary
                (if config.textarea then
                    Html.textarea

                 else
                    Html.input
                )
                [ cs "mdc-text-field__input"
                , Options.id config.id_
                , if config.outlined && not config.textarea then
                    Options.on "focus" (Decode.map (lift << Focus) decodeGeometry)

                  else
                    Options.on "focus" (Decode.succeed (lift (Focus defaultGeometry)))
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
                    , Html.name (Maybe.withDefault "" config.name)
                        |> (if config.name /= Nothing then
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
                    , Html.value (Maybe.withDefault "" config.value)
                        |> (if config.value /= Nothing then
                                Just

                            else
                                always Nothing
                           )
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

        viewPrefix s =
            styled Html.span
                [ element "affix"
                , element "affix--prefix"
                ]
                [ Html.text s ]

        viewSuffix s =
            styled Html.span
                [ element "affix"
                , element "affix--suffix"
                ]
                [ Html.text s ]

    in
    Options.apply summary
        Html.div
        [ block
        , modifier "focused" |> when focused
        , modifier "label-floating" |> when shouldFloat
        , modifier "no-label" |> when (canHaveLabel && not hasLabel)
        , modifier "disabled" |> when config.disabled
        , modifier "fullwidth" |> when config.fullWidth
        , modifier "invalid" |> when isInvalid
        , modifier "filled" |> when isFilled
        , modifier "outlined" |> when isOutlined
        , modifier "with-leading-icon" |> when (config.leadingIcon /= Nothing)
        , modifier "with-trailing-icon" |> when (config.trailingIcon /= Nothing)
        , modifier "textarea" |> when config.textarea
        ]
        []
        (list
            ++ [ if isFilled then
                     styled Html.span [ element "ripple" ] []
                 else
                     text ""
               , leadingIcon_
               , if hasLabel && canHaveLabel then
                    htmlLabel
                 else
                    text ""
               , if not config.outlined && not config.textarea then
                    styled Html.div
                        [ cs "mdc-line-ripple"
                        , cs "mdc-line-ripple--active" |> when model.focused
                        ]
                        []

                 else
                    text ""
               , if config.outlined || config.textarea then
                    styled Html.div
                        [ cs "mdc-notched-outline"
                        , cs "mdc-notched-outline--notched" |> when (focused || isDirty)
                        ]
                        [ styled Html.div [ cs "mdc-notched-outline__leading" ] []
                        , styled Html.div
                            [ cs "mdc-notched-outline__notch" ]
                            [ htmlLabel ]
                        , styled Html.div
                            [ cs "mdc-notched-outline__trailing" ]
                            []
                        ]

                 else
                    text ""
               , if not config.textarea then
                     viewJust config.prefix viewPrefix
                 else
                     text ""
               , input
               , if not config.textarea then
                     viewJust config.suffix viewSuffix
                 else
                     text ""
               , trailingIcon_
               ]
        )


iconView : (Msg -> m) -> Maybe String -> String -> Maybe m -> Html m
iconView lift icon iconClass handler =
    case icon of
        Just name_ ->
            styled Html.i
                [ cs ( "material-icons mdc-text-field__icon mdc-text-field__icon--" ++ iconClass)
                , Options.tabindex 0 |> when (handler /= Nothing)
                , Options.role "button" |> when (handler /= Nothing)
                , handler
                    |> Maybe.map Options.onClick
                    |> Maybe.withDefault Options.nop
                ]
                [ text name_ ]

        Nothing ->
            text ""


type alias Store s =
    { s | textfield : Indexed Model }


getSet :
    { get : Index -> { a | textfield : Indexed Model } -> Model
    , set :
        Index
        -> { a | textfield : Indexed Model }
        -> Model
        -> { a | textfield : Indexed Model }
    }
getSet =
    Component.indexed .textfield (\x c -> { c | textfield = x }) defaultModel


react :
    (Internal.Msg.Msg m -> msg)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd msg )
react =
    Component.react getSet.get getSet.set Internal.Msg.TextFieldMsg update


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    \lift domId store options ->
        Component.render getSet.get
            (textField domId)
            Internal.Msg.TextFieldMsg
            lift
            domId
            store
            (Options.internalId domId :: options)


decodeGeometry : Decoder Geometry
decodeGeometry =
    DOM.target <|
        -- .mdc-text-field__input
        DOM.parentElement
        <|
            -- .mdc-text-field
            Decode.map3 Geometry
                (DOM.childNode 2 DOM.offsetWidth)
                -- .mdc-text-field__outline
                (DOM.childNode 2 DOM.offsetHeight)
                -- .mdc-text-field__outline
                (DOM.childNode 1 DOM.offsetWidth)


{- Make it easier to work with BEM conventions
-}
block : Property m
block =
    cs blockName

element : String -> Property m
element module_ =
    cs ( blockName ++ "__" ++ module_ )

modifier : String -> Property m
modifier modifier_ =
    cs ( blockName ++ "--" ++ modifier_ )

blockName : String
blockName =
    "mdc-text-field"
