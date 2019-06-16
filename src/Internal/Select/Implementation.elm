module Internal.Select.Implementation exposing
    ( Property
    , disabled
    , label
    , option
    , outlined
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
import Internal.Options as Options exposing (cs, styled, when)
import Internal.Ripple.Implementation as Ripple
import Internal.Select.Model exposing (Model, Msg(..), defaultModel)


update : (Msg msg -> msg) -> Msg msg -> Model -> ( Maybe Model, Cmd msg )
update lift msg model =
    case msg of
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


type alias Config =
    { label : String
    , disabled : Bool
    , preselected : Bool
    , outlined : Bool
    , id_ : String
    }


defaultConfig : Config
defaultConfig =
    { label = ""
    , disabled = False
    , preselected = False
    , outlined = False
    , id_ = ""
    }


type alias Property m =
    Options.Property Config m


label : String -> Property m
label stringLabel =
    Options.option (\config -> { config | label = stringLabel })


preselected : Property m
preselected =
    Options.option (\config -> { config | preselected = True })


disabled : Property m
disabled =
    Options.option (\config -> { config | disabled = True })


outlined : Property m
outlined =
    Options.option (\config -> { config | outlined = True })


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

        htmlLabel =
            styled Html.label
                [ cs "mdc-floating-label"
                , Options.for config.id_
                , when (focused || isDirty || config.preselected)
                    (cs "mdc-floating-label--float-above")
                ]
                [ text config.label
                ]

        ripple_or_outline =
            if config.outlined then
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
                styled Html.div
                    [ cs "mdc-line-ripple"
                    , when focused (cs "mdc-line-ripple--active")
                    ]
                    []
    in
    Options.apply summary
        Html.div
        [ cs "mdc-select"
        , cs "mdc-select--focused" |> when focused
        , when config.disabled (cs "mdc-select--disabled")
        , cs "mdc-select--outlined" |> when config.outlined
        , Options.role "listbox"
        ]
        [ Html.tabindex 0
        ]
        [ styled Html.i [ cs "mdc-select__dropdown-icon" ] []
        , styled Html.select
            [ cs "mdc-select__native-control"
            , Options.id config.id_
            , Options.onFocus (lift Focus)
            , Options.onBlur (lift Blur)
            , Options.onChange (lift << Change)
            , when config.disabled (Options.attribute (Html.disabled True))
            ]
            items
        , if not config.outlined then
            htmlLabel

          else
            text ""
        , ripple_or_outline
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


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    \lift index store options ->
        Component.render getSet.get
            select
            Internal.Msg.SelectMsg
            lift
            index
            store
            (Options.internalId index :: options)
