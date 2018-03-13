module Material.Internal.Textfield.Implementation exposing
    ( box
    , cols
    , dense
    , disabled
    , email
    , fullwidth
    , iconUnclickable
    , invalid
    , label
    , leadingIcon
    , maxlength
    , maxRows
    , Model
    , outlined
    , password
    , pattern
    , placeholder
    , Property
    , react
    , required
    , rows
    , textarea
    , trailingIcon
    , type_
    , value
    , view
    )
{-|
Text fields allow users to input, edit, and select text.


# Resources

- [Material Design guidelines: Text Fields](https://material.io/guidelines/components/text-fields.html)
- [Demo](https://aforemny.github.io/elm-mdc/#text-field)


# Example

```elm
import Material.Textfield as Textfield

Textfield.view Mdc [0] model.mdc
    [ Textfield.label "Text field"
    ]
    []
```


# Usage

@docs Property
@docs view
@docs label
@docs value
@docs placeholder
@docs box
@docs outlined
@docs fullwidth
@docs disabled
@docs dense
@docs email
@docs password
@docs type_
@docs textarea
@docs rows
@docs cols
@docs maxRows
@docs leadingIcon
@docs trailingIcon
@docs iconUnclickable
@docs required
@docs invalid
@docs pattern
@docs maxlength


# Internal
@docs react
@docs Model

-}

import DOM
import Html.Attributes as Html
import Html.Events as Html
import Html exposing (Html, text)
import Json.Decode as Json exposing (Decoder)
import Json.Encode as Encode
import Material.Internal.Component as Component exposing (Indexed, Index)
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (styled, cs, css, when)
import Material.Internal.Options.Internal as Internal
import Material.Internal.Ripple.Implementation as Ripple
import Material.Internal.Textfield.Model exposing (Msg(..), Geometry, defaultGeometry)
import Regex
import Svg
import Svg.Attributes


type alias Config =
    { labelText : Maybe String
    , labelFloat : Bool
    , value : Maybe String
    , defaultValue : Maybe String
    , disabled : Bool
    , maxRows : Maybe Int
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
    }


defaultConfig : Config
defaultConfig =
    { labelText = Nothing
    , labelFloat = False
    , value = Nothing
    , defaultValue = Nothing
    , disabled = False
    , maxRows = Nothing
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
    }


{-| Make textfield icons unclickable.
-}
iconUnclickable : Property m
iconUnclickable =
    Internal.option (\ config -> { config | iconClickable = False })


{-| Add a leading icon to the textfield.
-}
leadingIcon : String -> Property m
leadingIcon icon =
    Internal.option (\ config -> { config | leadingIcon = Just icon })


{-| Add a trailing icon to the textfield.
-}
trailingIcon : String -> Property m
trailingIcon icon =
    Internal.option (\ config -> { config | trailingIcon = Just icon })


{-| Style the textfield as an outlined textfield.
-}
outlined : Property m
outlined =
    Internal.option (\ config -> { config | outlined = True })


{-| Textfield property.
-}
type alias Property m =
    Options.Property Config m


{-| Set a label for the textfield.
-}
label : String -> Property m
label =
    Internal.option
        << (\str config -> { config | labelText = Just str })


{-| Set the textfield's value.
-}
value : String -> Property m
value =
    Internal.option
        << (\str config -> { config | value = Just str })


{-| Set the maximum length of input text in characters.
-}
maxlength : Int -> Property m
maxlength k =
    Options.attribute <| Html.maxlength k


{-| Disable the textfield.
-}
disabled : Property m
disabled =
    Internal.option
        (\config -> { config | disabled = True })


{-| Set the textfield's `type` to `password`.
-}
password : Property m
password =
    Internal.option (\config -> { config | type_ = Just "password" })


{-| Set the textfield's `type` to `email`.
-}
email : Property m
email =
    Internal.option (\config -> { config | type_ = Just "email" })


{-| Style the textfield as a box textfield.
-}
box : Property m
box =
    Internal.option (\config -> { config | box = True })


{-| Set a pattern to validate the textfield's input against.
-}
pattern : String -> Property m
pattern pattern =
    Internal.option (\ config -> { config | pattern = Just pattern })


{-| Set the number of rows in a `textarea` textfield.
-}
rows : Int -> Property m
rows rows =
    Internal.option (\ config -> { config | rows = Just rows })


{-| Set the number of columns in a `textarea` textfield.
-}
cols : Int -> Property m
cols cols =
    Internal.option (\ config -> { config | cols = Just cols })


{-| Set the number of maximum rows in a `textarea` textfield that a user can
input.

The implementation prevents pressing enter when the maximum number of rows
would be exceeded.
-}
maxRows : Int -> Property m
maxRows k =
    Internal.option (\config -> { config | maxRows = Just k })


{-| Style the textfield as a dense textfield.
-}
dense : Property m
dense =
    Internal.option (\config -> { config | dense = True })


{-| Mark the textfield as required.
-}
required : Property m
required =
    Internal.option (\config -> { config | required = True })


{-| Set the textfield's type.
-}
type_ : String -> Property m
type_ =
    Internal.option << (\value config -> { config | type_ = Just value })


{-| Make the textfield take up all the available horizontal space.
-}
fullwidth : Property m
fullwidth =
    Internal.option (\config -> { config | fullWidth = True })


{-| Mark the textfield as invalid.
-}
invalid : Property m
invalid =
    Internal.option (\config -> { config | invalid = True })


{-| Make the textfield a `textarea` element instead of `input`.
-}
textarea : Property m
textarea =
    Internal.option (\config -> { config | textarea = True })


{-| Sets the placeholder of the textfield.
-}
placeholder : String -> Property m
placeholder placeholder =
    Internal.option (\ config -> { config | placeholder = Just placeholder })


{-| Textfield model.

Internal use only.
-}
type alias Model =
    { focused : Bool
    , isDirty : Bool
    , value : Maybe String
    , ripple : Ripple.Model
    , geometry : Maybe Geometry
    }


defaultModel : Model
defaultModel =
    { focused = False
    , isDirty = False
    , value = Nothing
    , ripple = Ripple.defaultModel
    , geometry = Nothing
    }


type alias Msg
    = Material.Internal.Textfield.Model.Msg


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
            ( Just { model | focused = False, geometry = Nothing }, Cmd.none )

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
            Internal.collect defaultConfig options

        isDirty =
            model.isDirty || Maybe.withDefault False (Maybe.map ((/=) "") config.value)

        preventEnterWhenMaxRowsExceeded =
            Options.onWithOptions "keydown"
                { stopPropagation = False
                , preventDefault = True
                }
                ( Json.map2 (,) Html.keyCode Html.targetValue
                  |> Json.andThen (\ (keyCode, value) ->
                      let
                          rows =
                              value
                              |> String.split "\n"
                              |> List.length
                      in
                      if (rows >= Maybe.withDefault 0 config.maxRows) && (keyCode == 13) then
                            Json.succeed (lift NoOp)
                          else
                            Json.fail ""
                    )
                )
            |> when (config.textarea && (config.maxRows /= Nothing))

        focused =
            model.focused && not config.disabled

        ripple =
            Ripple.view False (lift << RippleMsg) model.ripple []

        isInvalid =
            case config.pattern of
                Just pattern ->
                    model.value
                    |> Maybe.map (not << Regex.contains (Regex.regex ("^" ++ pattern ++ "$")))
                    |> Maybe.withDefault False
                Nothing -> False
    in
        Internal.apply summary Html.div
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
        , when config.box << Options.many <|
          [ cs "mdc-text-field--box"
          , ripple.properties
          ]
        , preventEnterWhenMaxRowsExceeded
        ]
        []
        ( List.concat
          [
            [ styled
                (if config.textarea then Html.textarea else Html.input)
                [
                  cs "mdc-text-field__input"
                , css "outline" "none"
                , if config.outlined then
                      Options.on "focus" (Json.map (lift << Focus) decodeGeometry)
                  else
                      Options.on "focus" (Json.succeed (lift (Focus defaultGeometry)))
                , Options.on "blur" (Json.succeed (lift Blur))
                , Options.onInput (lift << Input)
                , Options.many << List.map Internal.attribute << List.filterMap identity <|
                  [ Html.type_ (Maybe.withDefault "text" config.type_)
                    |> if not config.textarea then Just else always Nothing
                  , Html.disabled True
                    |> if config.disabled then Just else always Nothing
                  , Html.property "required" (Encode.bool True)
                    |> if config.required then Just else always Nothing
                  , Html.property "pattern" (Encode.string (Maybe.withDefault "" config.pattern))
                    |> if config.pattern /= Nothing then Just else always Nothing
                  , Html.attribute "outline" "medium none"
                    |> Just
                  , Html.value (Maybe.withDefault "" config.value)
                    |> if config.value /= Nothing then Just else always Nothing
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
                , when (config.placeholder /= Nothing) <| Options.attribute <|
                  Html.placeholder (Maybe.withDefault "" config.placeholder)
                , when (config.textarea && (config.rows /= Nothing)) <|
                  Options.attribute <| Html.rows (Maybe.withDefault 0 config.rows)
                , when (config.textarea && (config.cols /= Nothing)) <|
                  Options.attribute <| Html.cols (Maybe.withDefault 0 config.cols)
                ]
                []
            , styled Html.label
                [ cs "mdc-text-field__label"
                , cs "mdc-text-field__label--float-above" |> when (focused || isDirty)
                ]
                ( case config.labelText of
                    Just str ->
                        [ text str ]

                    Nothing ->
                        []
                )
            ]
          ,
            if (not config.outlined) && (not config.textarea)then
                [ styled Html.div
                  [ cs "mdc-line-ripple"
                  , cs "mdc-line-ripple--active" |> when model.focused
                  ]
                  []
                ]
            else
                []
          ,
            if config.outlined then
                let
                    isRtl =
                        False

                    d =
                        let
                            { labelWidth
                            , width
                            , height
                            } =
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
                                , toString (height - (2*cornerWidth))
                                , "a"
                                , toString radius
                                , ","
                                , toString radius
                                , " 0 0 1 "
                                , toString (-radius)
                                , ","
                                , toString radius
                                , "h"
                                , toString (-width + (2*cornerWidth))
                                , "a"
                                , toString radius
                                , ","
                                , toString radius
                                , " 0 0 1 "
                                , toString (-radius)
                                , ","
                                , toString (-radius)
                                , "v"
                                , toString (-height + (2*cornerWidth))
                                , "a"
                                , toString radius
                                , ","
                                , toString radius
                                , " 0 0 1 "
                                , toString radius
                                , ","
                                , toString (-radius)
                                ]
                                |> String.join ""
                        in
                        if not isRtl then
                            [ "M"
                            , toString (cornerWidth + leadingStrokeLength + paddedLabelWidth)
                            , ",1h"
                            , toString (width - (2*cornerWidth) - paddedLabelWidth - leadingStrokeLength)
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
                            , toString (width - (2*cornerWidth) - paddedLabelWidth - leadingStrokeLength)
                            ]
                            |> String.join ""
                in
                [ styled Html.div
                  [ cs "mdc-text-field__outline"
                  , ripple.properties
                  ]
                  [ Svg.svg []
                    [ Svg.path
                      [ Svg.Attributes.d d
                      , Svg.Attributes.class "mdc-text-field__outline-path"
                      ]
                      []
                    ]
                  ]
                ,
                  styled Html.div
                  [ cs "mdc-text-field__idle-outline"
                  ]
                  []
                ]
            else
                []

          ,
            let
                icon =
                    config.leadingIcon
                    |> Maybe.map Just
                    |> Maybe.withDefault config.trailingIcon
            in
            case icon of
                Just icon ->
                    [ styled Html.i
                      [ cs "material-icons mdc-text-field__icon"
                      , Options.attribute << Html.tabindex <|
                        if config.iconClickable then 0 else -1
                      ]
                      [ text icon
                      ]
                    ]

                Nothing ->
                    []
          ,
            [ ripple.style
            ]
          ]
        )


type alias Store s =
    { s | textfield : Indexed Model }


( get, set ) =
    Component.indexed .textfield (\x c -> { c | textfield = x }) defaultModel


{-| Textfield react.

Internal use only.
-}
react
    : (Material.Internal.Msg.Msg m -> msg)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd msg )
react =
    Component.react get set Material.Internal.Msg.TextfieldMsg update


{-| Textfield view.
-}
view
    : (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m       
view lift index store options =
    Component.render get textField Material.Internal.Msg.TextfieldMsg lift index store
        (Internal.dispatch lift :: options)


-- TODO: use inject ^^^^^


decodeGeometry : Decoder Geometry
decodeGeometry =
    DOM.target <|   -- .mdc-text-field__input
    DOM.parentElement <|   -- .mdc-text-field
    Json.map3 Geometry
        (DOM.childNode 2 DOM.offsetWidth)   -- .mdc-text-field__outline
        (DOM.childNode 2 DOM.offsetHeight)  -- .mdc-text-field__outline
        (DOM.childNode 1 DOM.offsetWidth)   -- .mdc-text-field__label
