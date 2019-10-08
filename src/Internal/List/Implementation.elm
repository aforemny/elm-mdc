module Internal.List.Implementation exposing
    ( ListItem
    , Property
    , aRippled
    , activated
    , asListItem
    , avatarList
    , defaultConfig
    , dense
    , disabled
    , divider
    , graphic
    , graphicClass
    , graphicIcon
    , graphicImage
    , group
    , hr
    , inset
    , li
    , listItemClass
    , meta
    , metaClass
    , metaIcon
    , metaImage
    , metaText
    , node
    , nonInteractive
    , onSelectListItem
    , padded
    , primaryText
    , radioGroup
    , react
    , secondaryText
    , selected
    , selectedIndex
    , singleSelection
    , subheader
    , subheaderClass
    , text
    , twoLine
    , ul
    , update
    , useActivated
    , view
    )

import Array exposing (Array)
import Browser.Dom
import Dict
import Html exposing (Html)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Icon.Implementation as Icon
import Internal.List.Model exposing (Model, Msg(..), defaultModel)
import Internal.Msg
import Internal.Options as Options exposing (aria, cs, role, styled, tabindex, when)
import Internal.Ripple.Implementation as Ripple
import Internal.Ripple.Model as Ripple
import Json.Decode as Decode exposing (Decoder)
import Task


update : (Msg m -> m) -> Msg m -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
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

        ResetFocusedItem ->
            ( Just { model | focused = Nothing }, Cmd.none )

        FocusItem _ id ->
            ( Just { model | focused = Nothing }, Task.attempt (\_ -> lift NoOp) (Browser.Dom.focus id) )

        SelectItem index m ->
            ( Just { model | focused = Nothing }, send (m index) )

        NoOp ->
            ( Nothing, Cmd.none )



{- Turn msg into Cmd msg -}

send : msg -> Cmd msg
send msg =
    Task.succeed msg
        |> Task.perform identity


{- State between ul and li is shared to make the interface easier. -}
type alias Config m =
    { node : Maybe (List (Html.Attribute m) -> List (Html m) -> Html m)

    -- list only properties
    , isSingleSelectionList : Bool
    , isRadioGroup : Bool
    , selectedIndex : Maybe Int
    , onSelectListItem : Maybe (Int -> m)
    , useActivated : Bool

    -- list item only properties
    , activated : Bool
    , selected : Bool
    , disabled : Bool
    }


defaultConfig : Config m
defaultConfig =
    { node = Nothing
    , isSingleSelectionList = False
    , isRadioGroup = False
    , selectedIndex = Nothing
    , onSelectListItem = Nothing
    , useActivated = False
    , activated = False
    , selected = False
    , disabled = False
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

        listItemIds =
            Array.fromList (List.indexedMap (doListItemDomId domId) items)

        -- Only at the parent level we know what list item's tabindex must be set.
        -- Order:
        -- 1. If user has moved focused with keyboarde, that item  gets the focus.
        -- 2. If client has selected an item to receive the tab index, use that.
        -- 3. If no index has set, set the index on the activated item.
        -- 4. Else select the first item.
        focusedIndex =
            case model.focused of
                Just focused -> focused

                Nothing ->
                    case config.selectedIndex of
                        Just index -> index
                        Nothing ->
                            case findIndex liIsSelectedOrActivated items of
                                Just i -> i
                                Nothing -> 0

        list_nodes =
            List.indexedMap (listItemView domId lift model config listItemIds focusedIndex) items
    in
    Options.apply summary
        (Maybe.withDefault Html.ul config.node)
        [ cs "mdc-list"
        , role "listbox" |> when config.isSingleSelectionList
        , role "radiogroup" |> when config.isRadioGroup
        , Options.id domId

        -- If user tabs out of list, we reset the focused item to the
        -- selected one, so when the user tabs back in, that is the
        -- selected index.
        , Options.on "focusout" <|
            Decode.map (always (lift ResetFocusedItem)) (succeedIfLeavingList domId)
        ]
        []
        list_nodes



-- Perhaps we need to pick up any custom id set explicitly on the list item?


doListItemDomId : String -> Int -> ListItem m -> String
doListItemDomId domId index listItem =
    if listItem.focusable then
        listItemDomId domId index

    else
        ""



{- Decoder functions to detect if focus moves away from the list itself.

   These functions check if a given DOM element is equal to another DOM
   element, or contained by it.

   Thanks: https://github.com/xarvh/elm-onclickoutside/blob/master/src/Html/OnClickOutside.elm
-}


succeedIfContainerOrChildOfContainer : String -> Decoder ()
succeedIfContainerOrChildOfContainer targetId =
    Decode.field "id" Decode.string
        |> Decode.andThen
            (\id ->
                if id == targetId then
                    Decode.succeed ()

                else
                    Decode.field "parentNode" (succeedIfContainerOrChildOfContainer targetId)
            )


invertDecoder : Decoder a -> Decoder ()
invertDecoder decoder =
    Decode.maybe decoder
        |> Decode.andThen
            (\maybe ->
                if maybe == Nothing then
                    Decode.succeed ()

                else
                    Decode.fail ""
            )


succeedIfLeavingList : String -> Decoder ()
succeedIfLeavingList targetId =
    succeedIfContainerOrChildOfContainer targetId
        |> Decode.field "relatedTarget"
        |> invertDecoder


{-| Format a single item in the list.
-}
listItemView :
    Index
    -> (Msg m -> m)
    -> Model
    -> Config m
    -> Array String
    -> Int
    -> Int
    -> ListItem m
    -> Html m
listItemView domId lift model config listItemsIds focusedIndex index li_ =
    li_.view domId lift model config listItemsIds focusedIndex index li_.options li_.children


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
    , focusable : Bool
    , view : Index -> (Msg m -> m) -> Model -> Config m -> Array String -> Int -> Int -> List (Property m) -> List (Html m) -> Html m
    }


li : List (Property m) -> List (Html m) -> ListItem m
li options children =
    { options = options
    , children = children
    , focusable = True
    , view = liView
    }


{-| Single list item view.

`focusedIndex` is the index that currently has the keyboard focus.
-}
liView :
    Index
    -> (Msg m -> m)
    -> Model
    -> Config m
    -> Array String
    -> Int
    -> Int
    -> List (Property m)
    -> List (Html m)
    -> Html m
liView domId lift model config listItemIds focusedIndex index options children =
    let
        li_summary =
            Options.collect defaultConfig options

        li_config =
            li_summary.config

        list_item_dom_id =
            listItemDomId domId index

        is_selected =
            case config.selectedIndex of
                Just i ->
                    i == index

                Nothing ->
                    li_config.selected || li_config.activated

        tab_index =
            if focusedIndex == index then
                0
            else
                -1

        ripple =
            Ripple.view False
                list_item_dom_id
                (lift << RippleMsg list_item_dom_id)
                (Dict.get list_item_dom_id model.ripples
                    |> Maybe.withDefault Ripple.defaultModel
                )
                []
    in
    Options.apply li_summary
        (Maybe.withDefault Html.li li_config.node)
        [ listItemClass
        , tabindex tab_index
        , cs "mdc-list-item--selected" |> when (config.isSingleSelectionList && is_selected && not config.useActivated)
        , cs "mdc-list-item--activated" |> when (config.isSingleSelectionList && is_selected && config.useActivated)
        , aria "checked"
            (if is_selected then
                "True"

             else
                "False"
            )
            |> when config.isRadioGroup
        , role "option" |> when config.isSingleSelectionList
        , role "radio" |> when config.isRadioGroup
        , disabledClass |> when li_config.disabled
        , ripple.interactionHandler |> when ( not li_config.disabled )
        , ripple.properties |> when ( not li_config.disabled )
        , case config.onSelectListItem of
            Just onSelect ->
                if not li_config.disabled then
                    Options.onClick (onSelect index)
                else
                    Options.nop

            Nothing ->
                Options.nop
        , Options.onWithOptions "keydown" <|
            Decode.map2
                (\key keyCode ->
                    let
                        -- TODO: handle arrow left and right if horizontal list
                        ( index_to_focus, id_to_focus ) =
                            if key == Just "ArrowDown" || keyCode == 40 then
                                let
                                    focusable_element =
                                        firstNonEmptyId (index + 1) listItemIds
                                in
                                case focusable_element of
                                    Just ( next_index, next_item ) ->
                                        ( Just next_index, Just next_item )

                                    Nothing ->
                                        ( Just (index + 1), Nothing )

                            else if key == Just "ArrowUp" || keyCode == 38 then
                                let
                                    focusable_element =
                                        lastNonEmptyId index listItemIds
                                in
                                case focusable_element of
                                    Just ( previous_index, previous_item ) ->
                                        ( Just previous_index, Just previous_item )

                                    Nothing ->
                                        ( Just (index - 1), Nothing )

                            else if key == Just "Home" || keyCode == 36 then
                                ( Just 0, Array.get 0 listItemIds )

                            else if key == Just "End" || keyCode == 35 then
                                let
                                    last_index =
                                        Array.length listItemIds - 1
                                in
                                ( Just last_index, Array.get last_index listItemIds )

                            else
                                ( Nothing, Nothing )

                        selectItem =
                            key
                                == Just "Enter"
                                || keyCode
                                == 13
                                || key
                                == Just "Space"
                                || keyCode
                                == 32

                        msg =
                            if selectItem then
                                case config.onSelectListItem of
                                    Just onSelect ->
                                        SelectItem index onSelect

                                    Nothing ->
                                        NoOp

                            else
                                case ( index_to_focus, id_to_focus ) of
                                    ( Just idx, Just id ) ->
                                        FocusItem idx id

                                    ( _, _ ) ->
                                        NoOp
                    in
                    { message = lift msg
                    , preventDefault = index_to_focus /= Nothing || selectItem
                    , stopPropagation = False
                    }
                )
                (Decode.oneOf
                    [ Decode.map Just (Decode.at [ "key" ] Decode.string)
                    , Decode.succeed Nothing
                    ]
                )
                (Decode.at [ "keyCode" ] Decode.int)
        ]
        []
        children



-- Perhaps we need to pick up any custom id set explicitly on the list item?


listItemDomId : String -> Int -> String
listItemDomId domId index =
    domId ++ "--" ++ String.fromInt index


slicedIndexedList : Int -> Int -> Array a -> List ( Int, a )
slicedIndexedList from to array =
    Array.slice from to array
        |> Array.toIndexedList


firstNonEmptyId : Int -> Array String -> Maybe ( Int, String )
firstNonEmptyId from array =
    let
        list =
            slicedIndexedList from (Array.length array) array

        non_empty_id =
            find (\( _, id ) -> id /= "") list
    in
    non_empty_id


lastNonEmptyId : Int -> Array String -> Maybe ( Int, String )
lastNonEmptyId to array =
    let
        list =
            slicedIndexedList 0 to array

        non_empty_id =
            find (\( i, id ) -> id /= "") (List.reverse list)
    in
    non_empty_id



{- Thanks to List.Extra.find -}

find : (a -> Bool) -> List a -> Maybe a
find predicate list =
    case list of
        [] ->
            Nothing

        first :: rest ->
            if predicate first then
                Just first

            else
                find predicate rest


{- Thanks to List.Extra.findIndex -}

findIndex : (a -> Bool) -> List a -> Maybe Int
findIndex =
    findIndexHelp 0

findIndexHelp : Int-> (a -> Bool) -> List a -> Maybe Int
findIndexHelp index predicate list =
    case list of
        [] ->
            Nothing

        first :: rest ->
            if predicate first then
                Just index

            else
                findIndexHelp (index + 1) predicate rest


aRippled :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
aRippled =
    \lift domId ->
        Component.render getSet.get (aRippledView domId) Internal.Msg.ListMsg lift domId


aRippledView :
    Index
    -> (Msg m -> m)
    -> Model
    -> List (Property m)
    -> List (Html m)
    -> Html m
aRippledView domId lift model options items =
    let
        summary =
            Options.collect defaultConfig options

        config =
            summary.config

        ripple =
            Ripple.view False
                domId
                (lift << RippleMsg domId)
                (Dict.get domId model.ripples
                    |> Maybe.withDefault Ripple.defaultModel
                )
                []
    in
    Options.apply summary
        (Maybe.withDefault Html.a config.node)
        [ ripple.properties
        , ripple.interactionHandler
        ]
        []
        items


listItemClass : Property m
listItemClass =
    cs "mdc-list-item"


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
    Options.option (\config -> { config | activated = True } )


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
    Options.option (\config -> { config | activated = True } )


liIsSelectedOrActivated : ListItem m -> Bool
liIsSelectedOrActivated li_ =
    let
        li_summary =
            Options.collect defaultConfig li_.options

        li_config =
            li_summary.config
    in
        li_config.selected || li_config.activated


disabled : Property m
disabled =
    Options.option (\config -> { config | disabled = True } )


disabledClass : Property m
disabledClass =
    cs "mdc-list-item--disabled"


graphicClass : Options.Property c m
graphicClass =
    cs "mdc-list-item__graphic"


graphic : List (Property m) -> List (Html m) -> Html m
graphic options =
    styled Html.span (graphicClass :: options)


graphicIcon : List (Icon.Property m) -> String -> Html m
graphicIcon options =
    Icon.view (graphicClass :: options)


graphicImage : List (Property m) -> String -> Html m
graphicImage options url =
    styled Html.img
        (graphicClass
            :: Options.attribute (Html.src url)
            :: options
        )
        []


metaClass : Options.Property c m
metaClass =
    cs "mdc-list-item__meta"


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


asListItem : (List (Html.Attribute m) -> List (Html m) -> Html m) -> List (Property m) -> List (Html m) -> ListItem m
asListItem dom_node options children =
    { options = node dom_node :: options
    , children = children
    , focusable = False
    , view = asListItemView
    }


asListItemView :
    Index
    -> (Msg m -> m)
    -> Model
    -> Config m
    -> Array String
    -> Int
    -> Int
    -> List (Property m)
    -> List (Html m)
    -> Html m
asListItemView domId lift model config listItemsIds focusedIndex index options children =
    let
        summary =
            Options.collect defaultConfig options
    in
    Options.apply summary
        (Maybe.withDefault Html.div summary.config.node)
        []
        []
        children


group : List (Property m) -> List (Html m) -> Html m
group options =
    styled Html.div (cs "mdc-list-group" :: options)


subheader : List (Property m) -> List (Html m) -> Html m
subheader options =
    let
        summary =
            Options.collect defaultConfig options

        config =
            summary.config
    in
    styled (Maybe.withDefault Html.div config.node) (subheaderClass :: options)


subheaderClass : Options.Property c m
subheaderClass =
    cs "mdc-list-group__subheader"


divider : List (Property m) -> List (Html m) -> ListItem m
divider options =
    asListItem Html.li (cs "mdc-list-divider" :: role "separator" :: options)


hr : List (Property m) -> List (Html m) -> ListItem m
hr options =
    asListItem Html.hr (cs "mdc-list-divider" :: options)


padded : Property m
padded =
    cs "mdc-list-divier--padded"


inset : Property m
inset =
    cs "mdc-list-divider--inset"


type alias Store s =
    { s | list : Indexed Model }


getSet :
    { get : Index -> { a | list : Indexed Model } -> Model
    , set :
        Index
        -> { a | list : Indexed Model }
        -> Model
        -> { a | list : Indexed Model }
    }
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
