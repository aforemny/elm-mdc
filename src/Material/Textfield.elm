module Material.Textfield
    exposing
        ( -- VIEW
          view
        , Property
        
          -- OPTIONS
        , label
        , disabled
        , dense
        , value
        , fullWidth
        , placeholder
        , autofocus
        , maxlength

        , pattern
        , required

        , textfield
        , multiline
        , rows
        , cols
        , maxRows

        , password
        , email
        , type_
          
          -- TEA
        , Model
        , defaultModel
        , Msg
        , update
          
          -- RENDER
        , render
        , Store
        , react
        )

{-|
> The MDC Text Field component provides a textual input field adhering to the
> Material Design Specification. It is fully accessible, ships with RTL
> support, and includes a gracefully-degraded version that does not require any
> javascript.

## Design & API Documentation

- (Material Design guidelines: Text Fields)[https://material.io/guidelines/components/text-fields.html]
- (Demo)[https://aforemny.github.io/elm-mdc/#text-field]

-}

import Html.Attributes as Html exposing (class, type_, style)
import Html.Events as Html exposing (defaultOptions)
import Html exposing (div, span, Html, text)
import Json.Decode as Decode
import Json.Encode as Json
import Material.Component as Component exposing (Indexed)
import Material.Internal.Options as Internal
import Material.Internal.Textfield exposing (Msg(..))
import Material.Msg exposing (Index) 
import Material.Options as Options exposing (cs, css, nop, Style, when)
import Material.Ripple as Ripple
import Regex


type alias Config m =
    { labelText : Maybe String
    , labelFloat : Bool
    , value : Maybe String
    , defaultValue : Maybe String
    , disabled : Bool
    , input : List (Options.Style m)
    , container : List (Options.Style m)
    , maxRows : Maybe Int
    , dense : Bool
    , required : Bool
    , type_ : Maybe String
    , textfieldBox : Bool
    , pattern : Maybe String
    , multiline : Bool
    , fullWidth : Bool
    , invalid : Bool
    }


defaultConfig : Config m
defaultConfig =
    { labelText = Nothing
    , labelFloat = False
    , value = Nothing
    , defaultValue = Nothing
    , disabled = False
    , input = []
    , container = []
    , maxRows = Nothing
    , dense = False
    , required = False
    , type_ = Just "text"
    , textfieldBox = False
    , pattern = Nothing
    , multiline = False
    , fullWidth = False
    , invalid = False
    }


type alias Property m =
    Options.Property (Config m) m


label : String -> Property m
label =
    Internal.option
        << (\str config -> { config | labelText = Just str })


value : String -> Property m
value =
    Internal.option
        << (\str config -> { config | value = Just str })


autofocus : Property m
autofocus =
    Options.attribute <| Html.autofocus True


maxlength : Int -> Property m
maxlength k =
    Options.attribute <| Html.maxlength k


disabled : Property m
disabled =
    Internal.option
        (\config -> { config | disabled = True })


input : List (Options.Style m) -> Property m
input =
    Options.input


password : Property m
password =
    Internal.option (\config -> { config | type_ = Just "password" })


email : Property m
email =
    Internal.option (\config -> { config | type_ = Just "email" })


textfield : Property m
textfield =
    Internal.option (\config -> { config | textfieldBox = True })


pattern : String -> Property m
pattern =
    Internal.option << (\value config -> { config | pattern = Just value })


rows : Int -> Property m
rows k =
    Internal.input [ Options.attribute <| Html.rows k ]


cols : Int -> Property m
cols k =
    Internal.input [ Options.attribute <| Html.cols k ]


maxRows : Int -> Property m
maxRows k =
    Internal.option (\config -> { config | maxRows = Just k })


dense : Property m
dense =
    Internal.option (\config -> { config | dense = True })


required : Property m
required =
    Internal.option (\config -> { config | required = True })


type_ : String -> Property m
type_ =
    Internal.option << (\value config -> { config | type_ = Just value })


fullWidth : Property m
fullWidth =
    Internal.option (\config -> { config | fullWidth = True })


invalid : Property m
invalid =
    Internal.option (\config -> { config | invalid = True })


multiline : Property m
multiline =
    Internal.option (\config -> { config | multiline = True })


placeholder : String -> Property m
placeholder value =
    Internal.input [ Options.attribute <| Html.attribute "placeholder" value ]


type alias Model =
    { isFocused : Bool
    , isDirty : Bool
    , value : Maybe String
    , ripple : Ripple.Model
    }


defaultModel : Model
defaultModel =
    { isFocused = False
    , isDirty = False
    , value = Nothing
    , ripple = Ripple.defaultModel
    }


type alias Msg
    = Material.Internal.Textfield.Msg


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
            ( Just { model | isFocused = False }, Cmd.none )

        Focus ->
            ( Just { model | isFocused = True }, Cmd.none )

        NoOp ->
            ( Just model, Cmd.none )

        RippleMsg msg_ ->
            let
                ( ripple, effects ) =
                    Ripple.update msg_ model.ripple
            in
            ( Just { model | ripple = ripple }, Cmd.map (RippleMsg >> lift) effects )



view : (Msg -> m) -> Model -> List (Property m) -> x -> Html m
view lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        isDirty =
            model.isDirty || Maybe.withDefault False (Maybe.map ((/=) "") config.value)

        preventEnterWhenMaxRowsExceeded =
            Options.onWithOptions "keydown"
                { defaultOptions
                  | preventDefault = True
                }
                ( Decode.map2 (,) Html.keyCode Html.targetValue
                  |> Decode.andThen (\ (keyCode, value) ->
                      let
                          rows =
                              value
                              |> String.split "\n"
                              |> List.length
                      in
                      if (rows >= Maybe.withDefault 0 config.maxRows) && (keyCode == 13) then
                            Decode.succeed (lift NoOp)
                          else
                            Decode.fail ""
                    )
                )
            |> when (config.multiline && (config.maxRows /= Nothing))

        isFocused =
            model.isFocused && not config.disabled

        ( rippleOptions, rippleStyle ) =
            Ripple.view False (RippleMsg >> lift) model.ripple [] []

        isInvalid =
            case config.pattern of
                Just pattern ->
                    model.value
                    |> Maybe.map (not << Regex.contains (Regex.regex ("^" ++ pattern ++ "$")))
                    |> Maybe.withDefault False
                Nothing -> False
    in
        Internal.applyContainer summary
            div
            [ cs "mdc-textfield"
            , cs "mdc-textfield--upgraded"
            , Internal.on1 "focus" lift Focus
            , Internal.on1 "blur" lift Blur
            , cs "mdc-textfield--focused" |> when isFocused 
            , cs "mdc-textfield--disabled" |> when config.disabled
            , cs "mdc-textfield--dense" |> when config.dense
            , cs "mdc-textfield--fullwidth" |> when config.fullWidth
            , cs "mdc-textfield--invalid" |> when isInvalid
            , cs "mdc-textfield--multiline" |> when config.multiline
            , when config.textfieldBox << Options.many <|
              [ cs "mdc-textfield--box"
              , rippleOptions
              ]
            , preventEnterWhenMaxRowsExceeded
            ]
            [ Internal.applyInput summary
                (if config.multiline then Html.textarea else Html.input)
                [
                  cs "mdc-textfield__input"
                , css "outline" "none"
                , Internal.on1 "focus" lift Focus
                , Internal.on1 "blur" lift Blur
                , Options.onInput (Input >> lift)
                , Options.many << List.map Internal.attribute << List.filterMap identity <|
                  [ Html.type_ (Maybe.withDefault "text" config.type_)
                    |> if not config.multiline then Just else always Nothing
                    -- TODO: ^^^^ can crash Elm runtime
                  , Html.disabled True
                    |> if config.disabled then Just else always Nothing
                  , Html.property "required" (Json.bool True)
                    |> if config.required then Just else always Nothing
                  , Html.property "pattern" (Json.string (Maybe.withDefault "" config.pattern))
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
                        (Decode.succeed (lift NoOp))
                  , Options.onWithOptions "keyup"
                        { preventDefault = False
                        , stopPropagation = True
                        }
                        (Decode.succeed (lift NoOp))
                  ]
                ]
                []
            , Options.styled Html.label
                [ cs "mdc-textfield__label"
                , cs "mdc-textfield__label--float-above" |> when (isFocused || isDirty)
                ]
                ( case config.labelText of
                    Just str ->
                        [ text str ]

                    Nothing ->
                        []
                )
            , Options.styled div
              [ cs "mdc-textfield__bottom-line"
              ]
              [
              ]

            , rippleStyle
            ]


type alias Store s =
    { s | textfield : Indexed Model }


( get, set ) =
    Component.indexed .textfield (\x c -> { c | textfield = x }) defaultModel


react
    : (Material.Msg.Msg m -> msg)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd msg )
react =
    Component.react get
        set
        Material.Msg.TextfieldMsg update


render
    : (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> x
    -> Html m       
render lift index store options =
    Component.render get view Material.Msg.TextfieldMsg lift index store
        (Internal.dispatch lift :: options)


-- TODO: use inject ^^^^^
