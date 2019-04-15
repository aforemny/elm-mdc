module Internal.List.Implementation exposing
    ( Property
    , a
    , activated
    , avatarList
    , defaultConfig
    , dense
    , divider
    , graphic
    , graphicIcon
    , graphicImage
    , group
    , hr
    , inset
    , li
    , ListItem
    , meta
    , metaClass
    , metaIcon
    , metaImage
    , metaText
    , onSelectListItem
    , nav
    , node
    , nonInteractive
    , ol
    , padded
    , primaryText
    , radioGroup
    , react
    , secondaryText
    , selected
    , selectedIndex
    , singleSelection
    , subheader
    , text
    , twoLine
    , ul
    , useActivated
    , view
    )

import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Icon.Implementation as Icon
import Internal.Msg
import Internal.Options as Options exposing (aria, cs, role, styled, tabindex, when)
import Internal.Ripple.Implementation as Ripple
import Internal.Ripple.Model as Ripple
import Internal.List.Model exposing (Model, Msg(..), defaultModel)


update : (Msg m -> m) -> Msg m -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    let
        isRtl =
            False

    in
    case msg of
        RippleMsg index msg_ ->
            let
                ( ripple, effects ) =
                    Ripple.update msg_
                        (Dict.get index model.ripples
                            |> Maybe.withDefault Ripple.defaultModel
                        )
            in
            ( Just { model | ripples = Dict.insert index ripple model.ripples }
            , Cmd.map (lift << RippleMsg index) effects
            )


        NoOp ->
            ( Nothing, Cmd.none )



type alias Config m =
    { node : Maybe (List (Html.Attribute m) -> List (Html m) -> Html m)
    , isSingleSelectionList : Bool
    , isRadioGroup : Bool
    , selectedIndex : Maybe Int
    , onSelectListItem : Maybe (Int -> m)
    , useActivated : Bool
    }


defaultConfig : Config m
defaultConfig =
    { node = Nothing
    , isSingleSelectionList = False
    , isRadioGroup = False
    , selectedIndex = Nothing
    , onSelectListItem = Nothing
    , useActivated = False
    }


type alias Property m =
    Options.Property (Config m) m


ul :
    Index
    -> (Msg m -> m)
    -> Model
    -> List (Property m)
    -> List (ListItem m)
    -> Html m
ul domId lift model options items =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        list_nodes =
            List.indexedMap (listItemView domId lift model config) items

    in
    Options.apply summary
        (Maybe.withDefault Html.ul config.node)
        [ cs "mdc-list"
        , role "listbox" |> when config.isSingleSelectionList
        , role "radiogroup" |> when config.isRadioGroup
        ]
        []
        list_nodes


{-| Format a single item in the list.
-}
listItemView :
    Index
    -> (Msg m -> m)
    -> Model
    -> Config m
    -> Int
    -> ListItem m
    -> Html m
listItemView domId lift model config index li_ =
    li_.view domId lift model config index li_.options li_.children


{-| I think this should be considered obsolete.
-}
ol : List (Property m) -> List (Html m) -> Html m
ol options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        (Maybe.withDefault Html.ol config.node)
        [ cs "mdc-list" ]
        []


nav : List (Property m) -> List (Html m) -> Html m
nav options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        (Maybe.withDefault Html.nav config.node)
        [ cs "mdc-list" ]
        []


node : (List (Html.Attribute m) -> List (Html m) -> Html m) -> Property m
node nodeFunc =
    Options.option (\config -> { config | node = Just nodeFunc })


nonInteractive : Property m
nonInteractive =
    cs "mdc-list--non-interactive"


dense : Property m
dense =
    cs "mdc-list--dense"


avatarList : Property m
avatarList =
    cs "mdc-list--avatar-list"


twoLine : Property m
twoLine =
    cs "mdc-list--two-line"


type alias ListItem m =
    { options : List (Property m)
    , children : List (Html m)
    , view : Index -> (Msg m -> m) -> Model -> Config m -> Int -> List (Property m) -> List (Html m) -> Html m
    }


li : List (Property m) -> List (Html m) -> ListItem m
li options children =
    { options = options
    , children = children
    , view = liView
    }


{-| Single list item view.
-}
liView :
    Index
    -> (Msg m -> m)
    -> Model
    -> Config m
    -> Int
    -> List (Property m)
    -> List (Html m)
    -> Html m
liView domId lift model config index options children =
    let
        li_summary =
            Options.collect defaultConfig options

        li_config =
            li_summary.config

        listItemDomId =
            domId ++ "--" ++ String.fromInt index

        is_selected =
            case config.selectedIndex of
                Just i -> i == index
                Nothing -> False

        selected_index = Maybe.withDefault 0 config.selectedIndex

        tab_index =
            if selected_index == index then
                0
            else
                -1

        ripple =
            Ripple.view False
                listItemDomId
                (lift << RippleMsg index)
                (Dict.get index model.ripples
                    |> Maybe.withDefault Ripple.defaultModel
                )
                []

    in
    Options.apply li_summary
        Html.li
        [ cs "mdc-list-item"
        , tabindex tab_index
        , selected |> when (config.isSingleSelectionList && is_selected && not config.useActivated)
        , activated |> when (config.isSingleSelectionList && is_selected && config.useActivated)
        , aria "checked" (if is_selected then "True" else "False") |> when config.isRadioGroup
        , role "option" |> when config.isSingleSelectionList
        , role "radio" |> when config.isRadioGroup
        , ripple.interactionHandler
        , ripple.properties
        , case config.onSelectListItem of
              Just onSelect -> Options.onClick (onSelect index)
              Nothing -> Options.nop
        ]
        []
        children



a : List (Property m) -> List (Html m) -> Html m
a options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        (Maybe.withDefault Html.a config.node)
        [ cs "mdc-list-item" ]
        []


text : List (Property m) -> List (Html m) -> Html m
text options =
    styled Html.span (cs "mdc-list-item__text" :: options)


primaryText : List (Property m) -> List (Html m) -> Html m
primaryText options =
    styled Html.span (cs "mdc-list-item__primary-text" :: options)


secondaryText : List (Property m) -> List (Html m) -> Html m
secondaryText options =
    styled Html.span (cs "mdc-list-item__secondary-text" :: options)


selected : Property m
selected =
    cs "mdc-list-item--selected"


selectedIndex : Int -> Property m
selectedIndex index =
    Options.option (\config -> { config | selectedIndex = Just index })


onSelectListItem : (Int -> m) -> Property m
onSelectListItem handler =
    Options.option (\config -> { config | onSelectListItem = Just handler })


singleSelection : Property m
singleSelection =
    Options.option (\config -> { config | isSingleSelectionList = True, isRadioGroup = False })


radioGroup : Property m
radioGroup =
    Options.option (\config -> { config | isSingleSelectionList = False, isRadioGroup = True })


useActivated : Property m
useActivated =
    Options.option (\config -> { config | useActivated = True })


activated : Property m
activated =
    cs "mdc-list-item--activated"


graphic : List (Property m) -> List (Html m) -> Html m
graphic options =
    styled Html.span (cs "mdc-list-item__graphic" :: options)


graphicIcon : List (Icon.Property m) -> String -> Html m
graphicIcon options =
    Icon.view (cs "mdc-list-item__graphic" :: options)


graphicImage : List (Property m) -> String -> Html m
graphicImage options url =
    styled Html.img
        (cs "mdc-list-item__graphic"
            :: Options.attribute (Html.src url)
            :: options
        )
        []


metaClass : Options.Property c m
metaClass =
    Options.cs "mdc-list-item__meta"


meta : List (Property m) -> List (Html m) -> Html m
meta options =
    styled Html.span (metaClass :: options)


metaText : List (Property m) -> String -> Html m
metaText options str =
    styled Html.span (metaClass :: options) [ Html.text str ]


metaIcon : List (Icon.Property m) -> String -> Html m
metaIcon options =
    Icon.view (metaClass :: options)


metaImage : List (Property m) -> String -> Html m
metaImage options url =
    styled Html.img
        (metaClass
            :: Options.attribute (Html.src url)
            :: options
        )
        []


group : List (Property m) -> List (Html m) -> Html m
group options =
    styled Html.div (cs "mdc-list-group" :: options)


subheader : List (Property m) -> List (Html m) -> Html m
subheader options =
    styled Html.div (cs "mdc-list-group__subheader" :: options)


divider : List (Property m) -> List (Html m) -> ListItem m
divider options children =
    { options = options
    , children = children
    , view = dividerView
    }


dividerView :
    Index
    -> (Msg m -> m)
    -> Model
    -> Config m
    -> Int
    -> List (Property m)
    -> List (Html m)
    -> Html m
dividerView domId lift model config index options children=
    let
        li_summary =
            Options.collect defaultConfig options
    in
    Options.apply li_summary
        Html.li
            [ cs "mdc-list-divider"
            , role "separator" ]
            []
            children


hr : List (Property m) -> List (Html m) -> Html m
hr options =
    styled Html.hr (cs "mdc-list-divider" :: options)


padded : Property m
padded =
    cs "mdc-list-divier--padded"


inset : Property m
inset =
    cs "mdc-list-divider--inset"


type alias Store s =
    { s | list : Indexed Model }


getSet =
    Component.indexed .list (\x y -> { y | list = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.ListMsg update


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (ListItem m)
    -> Html m
view =
    \lift domId ->
        Component.render getSet.get (ul domId) Internal.Msg.ListMsg lift domId
