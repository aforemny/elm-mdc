module Internal.Select.Implementation
    exposing
        ( Property
        , box
        , disabled
        , label
        , option
        , preselected
        , react
        , selected
        , value
        , view
        )

import Html exposing (Html, text)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Internal.Ripple.Implementation as Ripple
import Internal.Select.Model exposing (Model, Msg(..), defaultModel)


update : (Msg msg -> msg) -> Msg msg -> Model -> ( Maybe Model, Cmd msg )
update lift msg model =
    case msg of
        Change value ->
            let
                dirty =
                    value /= ""
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


type alias Config =
    { label : String
    , box : Bool
    , disabled : Bool
    , preselected : Bool
    , id_ : String
    }


defaultConfig : Config
defaultConfig =
    { label = ""
    , box = False
    , disabled = False
    , preselected = False
    , id_ = ""
    }


type alias Property m =
    Options.Property Config m


label : String -> Property m
label =
    Options.option << (\value config -> { config | label = value })


preselected : Property m
preselected =
    Options.option (\config -> { config | preselected = True })


disabled : Property m
disabled =
    Options.option (\config -> { config | disabled = True })


box : Property m
box =
    cs "mdc-select--box"


select :
    (Msg m -> m)
    -> Model
    -> List (Property m)
    -> List (Html m)
    -> Html m
select lift model options items_ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        isDirty =
            model.isDirty

        focused =
            model.focused && not config.disabled

        items =
            if config.preselected then
                items_
            else
                Html.option
                    [ Html.value ""
                    , Html.disabled True
                    , Html.selected True
                    ]
                    []
                    :: items_
    in
    Options.apply summary
        Html.div
        [ cs "mdc-select"
        , when config.disabled (cs "mdc-select--disabled")
        , Options.role "listbox"
        ]
        [ Html.tabindex 0
        ]
        [ styled Html.select
            [ cs "mdc-select__native-control"
            , Options.id config.id_
            , Options.onFocus (lift Focus)
            , Options.onBlur (lift Blur)
            , Options.onChange (lift << Change)
            , when config.disabled (Options.attribute (Html.disabled True))
            ]
            items
        , styled Html.label
            [ cs "mdc-floating-label"
            , Options.for config.id_
            , when (focused || isDirty || config.preselected)
                (cs "mdc-floating-label--float-above")
            ]
            [ text config.label
            ]
        , styled Html.div
            [ cs "mdc-line-ripple"
            , when focused (cs "mdc-line-ripple--active")
            ]
            []
        ]


option : List (Property m) -> List (Html m) -> Html m
option =
    styled Html.option


value : String -> Property m
value =
    Options.attribute << Html.value


selected : Property m
selected =
    Options.attribute (Html.selected True)


type alias Store s =
    { s | select : Indexed Model }


( get, set ) =
    Component.indexed .select (\x y -> { y | select = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Internal.Msg.SelectMsg update


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
            select
            Internal.Msg.SelectMsg
            lift
            index
            store
            (Options.id_ index :: options)
