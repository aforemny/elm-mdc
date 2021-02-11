module Internal.Select.Implementation exposing
    ( Property
    , disabled
    , fullWidth
    , label
    , onSelect
    , option
    , outlined
    , react
    , required
    , selected
    , selectedText
    , subs
    , subscriptions
    , value
    , view
    )

import Browser.Dom
import Html exposing (Html, text)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Helpers as Helpers
import Internal.Keyboard as Keyboard exposing (decodeMeta, decodeKey, decodeKeyCode)
import Internal.List.Implementation as Lists
import Internal.Menu.Implementation as Menu
import Internal.Menu.Model as Menu
import Internal.Msg
import Internal.Options as Options exposing (aria, cs, role, styled, when)
import Internal.Ripple.Implementation as Ripple
import Internal.Select.Model exposing (Model, Msg(..), defaultModel)
import Json.Decode as Decode
import Task
import Svg exposing (polygon)
import Svg.Attributes as Svg exposing (stroke, fillRule, points, viewBox)


subscriptions : Model -> Sub (Msg m)
subscriptions model =
    Sub.map MenuMsg (Menu.subscriptions model.menu)


update : (Msg msg -> msg) -> Msg msg -> Model -> ( Maybe Model, Cmd msg )
update lift msg model =
    case msg of
        NoOp ->
            ( Nothing, Cmd.none )

        Change changedValue ->
            let
                dirty =
                    changedValue /= ""
            in
            ( Just { model | isDirty = dirty }, Cmd.none )

        Blur ->
            ( Just { model | focused = False }, Cmd.none )

        Focus ->
            ( Just { model | focused = True }, Cmd.none )

        RippleMsg msg_ ->
            let
                ( ripple, effects ) =
                    Ripple.update msg_ model.ripple
            in
            ( Just { model | ripple = ripple }, Cmd.map (lift << RippleMsg) effects )

        KeyDown menuIndex key keyCode ->
            let
                isEscape =
                    key == "Escape" || keyCode == 27

                isSpace =
                    key == "Space" || keyCode == 32

                isEnter =
                    key == "Enter" || keyCode == 13

                isArrowDown =
                    key == "ArrowDown" || keyCode == 40
            in
            if isEscape || isSpace || isEnter || isArrowDown then
                ( Nothing, Helpers.delayedCmd 16 (lift (OpenMenu menuIndex)) )
            else
                ( Nothing, Cmd.none )

        OpenMenu menuIndex ->
            ( Nothing, Helpers.cmd ( lift (MenuMsg Menu.Open) ) )

        ToggleMenu ->
            update lift (MenuMsg Menu.Toggle) model

        MenuSelection index onSelect_ v ->
            ( Nothing
            , Cmd.batch
                [ Helpers.cmd (onSelect_ v)
                , Task.attempt (\_ -> lift NoOp) (Browser.Dom.focus index)
                ]
            )

        MenuMsg msg_ ->
            Menu.update (lift << MenuMsg) msg_ model.menu
                |> Tuple.mapFirst
                    (\maybeNewMenu ->
                        case maybeNewMenu of
                            Just newMenu ->
                                Just { model | menu = newMenu }

                            Nothing ->
                                Nothing
                    )


type alias Config m =
    { label : String
    , disabled : Bool
    , required : Bool
    , outlined : Bool
    , id_ : Index
    , selectedText : String
    , onSelect : Maybe (String -> m)
    }


defaultConfig : Config m
defaultConfig =
    { label = ""
    , disabled = False
    , required = False
    , outlined = False
    , id_ = ""
    , selectedText = ""
    , onSelect = Nothing
    }


type alias Property m =
    Options.Property (Config m) m


label : String -> Property m
label stringLabel =
    Options.option (\config -> { config | label = stringLabel })


required : Property m
required =
    Options.option (\config -> { config | required = True })


disabled : Property m
disabled =
    Options.option (\config -> { config | disabled = True })


fullWidth : Property m
fullWidth =
    modifier "fullwidth"


outlined : Property m
outlined =
    Options.option (\config -> { config | outlined = True })


selectedText : String -> Property m
selectedText v =
    Options.option (\config -> { config | selectedText = v } )


onSelect : (String -> m) -> Property m
onSelect msg =
    Options.option (\config -> { config | onSelect = Just msg } )


select :
    Component.Index
    -> (Msg m -> m)
    -> Model
    -> List (Property m)
    -> List (Menu.Item m)
    -> Html m
select domId lift model options items_ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        isDirty =
            model.isDirty

        focused =
            ( model.focused && not config.disabled ) || model.menu.open

        items =
            if config.required then
                items_
            else
                option
                    [ value "" ]
                    []
                    :: items_

        floatAbove =
            focused || isDirty || config.selectedText /= ""

        htmlLabel =
            styled Html.span
                [ cs "mdc-floating-label"
                , cs "mdc-floating-label--float-above" |> when floatAbove
                , cs "mdc-floating-label--required" |> when config.required
                ]
                [ text config.label
                ]

        ripple_or_outline =
            if config.outlined then
                styled Html.div
                    [ cs "mdc-notched-outline"
                    , cs "mdc-notched-outline--notched" |> when floatAbove
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
                styled Html.div
                    [ cs "mdc-line-ripple"
                    , when focused (cs "mdc-line-ripple--active")
                    ]
                    []

        menuIndex = domId ++ "__menu"

        selectable msg =
            List.map
                (\item ->
                     case item of
                         Menu.ListItem options_ nodes ->
                             let
                                 maybe_value = dataValue options_
                             in
                                 case maybe_value of
                                     Just v ->
                                         Menu.ListItem ( Menu.onSelect (lift (MenuSelection anchorDomId msg v)) :: options_ ) nodes
                                     Nothing ->
                                         item
                         _ ->
                             item
                )

        anchorDomId =
            (domId ++ "__anchor")

    in
    Options.apply summary
        Html.div
        [ block
        , modifier "focused" |> when focused
        , modifier "activated" |> when model.menu.open
        , modifier "disabled" |> when config.disabled
        , modifier "outlined" |> when config.outlined
        , modifier "filled" |> when ( not config.outlined )
        , Options.id domId
        ]
        [ ]
        [ styled Html.div
              [ element "anchor"
              , role "button"
              , aria "haspopup" "listbox"
              , Options.aria "disabled" (if config.disabled then "true" else "false")
              , Options.aria "expanded" (if model.menu.open then "true" else "false")
              , Options.onClick (lift ToggleMenu)
              , Options.tabindex 0
              , Options.id anchorDomId
              , Options.onFocus (lift Focus)
              , Options.onBlur (lift Blur)
              , Options.on "keydown" <|
                  Decode.map lift <|
                      Decode.map2 (KeyDown menuIndex) decodeKey decodeKeyCode
              ]
              [ if not config.outlined then
                    styled Html.span [ element "ripple" ] []
                else
                    text ""
              , if not config.outlined then
                    htmlLabel
                else
                    text ""
              , styled Html.span
                  [ element "selected-text-container"
                  ]
                  [ styled Html.span
                        [ element "selected-text"
                        ]
                        [ text config.selectedText ]
                  ]
              , styled Html.span
                    [ element "dropdown-icon"
                    , Options.onClick (lift ToggleMenu)
                    ]
                    [ Svg.svg
                          [ Svg.class "mdc-select__dropdown-icon-graphic"
                          , viewBox "7 10 10 5"
                          ]
                          [ polygon
                                [ Svg.class "mdc-select__dropdown-icon-inactive"
                                , stroke "none"
                                , fillRule "evenodd"
                                , points "7 10 12 15 17 10"
                                ]
                                []
                          , polygon
                                [ Svg.class "mdc-select__dropdown-icon-active"
                                , stroke "none"
                                , fillRule "evenodd"
                                , points "7 15 12 10 17 15"
                                ]
                                []
                          ]
                    ]
              , ripple_or_outline
              ]
        , Menu.menu
            menuIndex
            ( lift << MenuMsg )
            model.menu
            [ cs "mdc-select__menu"
            , role "listbox"
            , Menu.anchorCorner Menu.bottomLeftCorner
            ]
            (Menu.ul [ Lists.singleSelection ]
                 ( case config.onSelect of
                       Just msg ->
                           selectable msg items
                       Nothing ->
                           items
                 )
            )
        ]


option : List (Lists.Property m) -> List (Html m) -> Menu.Item m
option options =
    Menu.li (Lists.rippleDisabled :: options)


{-| Find the data "value" property.
-}
dataValue : List (Lists.Property m) -> Maybe String
dataValue options =
    let
        ({ config } as summary) =
            Options.collect Lists.defaultConfig options
    in
        config.dataValue


value : String -> Lists.Property m
value v =
    Options.option (\config -> { config | dataValue = Just v } )


selected : Lists.Property m
selected =
    Lists.selected


type alias Store s =
    { s | select : Indexed Model }


getSet :
    { get : Index -> { a | select : Indexed Model } -> Model
    , set :
        Index
        -> { a | select : Indexed Model }
        -> Model
        -> { a | select : Indexed Model }
    }
getSet =
    Component.indexed .select (\x y -> { y | select = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.SelectMsg update


subs : (Internal.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Internal.Msg.SelectMsg .select subscriptions


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Menu.Item m)
    -> Html m
view =
    \lift index store options ->
        Component.render getSet.get
            ( select index )
            Internal.Msg.SelectMsg
            lift
            index
            store
            (Options.internalId index :: options)


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
    "mdc-select"
