module Material.Internal.Select.Implementation exposing
    ( box
    , disabled
    , label
    , preselected
    , Property
    , react
    , view
    )

import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json exposing (Decoder)
import Material.Internal.Component as Component exposing (Indexed, Index)
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (cs, css, styled, when)
import Material.Internal.Ripple.Implementation as Ripple
import Material.Internal.Select.Model exposing (Model, defaultModel, Msg(..), Geometry, defaultGeometry)


update : (Msg msg -> msg) -> Msg msg -> Model -> ( Maybe Model, Cmd msg )
update lift msg model =
    case msg of
        Input value ->
            let
                dirty =
                    value /= ""
            in
            ( Just { model | value = Just value, isDirty = dirty }, Cmd.none )

        Blur ->
            ( Just { model | focused = False }, Cmd.none )

        Focus geometry ->
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
    }


defaultConfig : Config
defaultConfig =
    { label = ""
    , box = False
    , disabled = False
    , preselected= False
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


select
    : (Msg m -> m)
    -> Model
    -> List (Property m)
    -> List (Html m)
    -> Html m
select lift model options items =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        isDirty = model.isDirty

        focused =
            model.focused && not config.disabled

        isOpen = False -- TODO

        myItems =
            if config.preselected then
                items
            else
                Html.option
                    [ Html.value ""
                    , Html.disabled True
                    , Html.selected True ]
                []
                :: items

    in
    Options.apply summary Html.div
    [ cs "mdc-select"
    , cs "mdc-select--disabled" |> when config.disabled
    ]
    [ Html.attribute "role" "listbox"
    , Html.tabindex 0
    ]
    [ styled Html.select
          [ cs "mdc-select__native-control"
          , Options.on "focus" (Json.succeed (lift (Focus defaultGeometry)))
          , Options.onBlur (lift Blur)
          , Options.onInput (lift << Input)
          ]
          myItems
    , styled Html.label
        [ cs "mdc-floating-label"
        , cs "mdc-floating-label--float-above" |> when (focused || isDirty || config.preselected)
        ]
        [ text config.label
        ]
    , styled Html.div
        [ cs "mdc-line-ripple"
        , cs "mdc-line-ripple--active" |> when focused
        ]
        []
    ]


type alias Store s =
    { s | select : Indexed Model }


( get, set ) =
    Component.indexed .select (\x y -> { y | select = x }) defaultModel


react :
    (Material.Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Internal.Msg.SelectMsg update


view :
    (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render get select Material.Internal.Msg.SelectMsg
