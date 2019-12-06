module Demo.TabBar exposing (Model, Msg(..), defaultModel, subscriptions, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, h3, text)
import Material
import Material.Options as Options exposing (styled)
import Material.TabBar as TabBar
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , states : Dict Material.Index Int
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , states = Dict.empty
    }


type Msg m
    = Mdc (Material.Msg m)
    | SelectTab Material.Index Int


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        SelectTab index tabIndex ->
            ( { model | states = Dict.insert index tabIndex model.states }, Cmd.none )


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model


tab :
    (Msg m -> m)
    -> Model m
    -> Material.Index
    -> Int
    -> String
    -> TabBar.Tab m
tab lift model index tab_index label =
    TabBar.tab
        [ Options.onClick (lift (SelectTab index tab_index)) ]
        [ text label ]


heroTabs : (Msg m -> m) -> Model m -> Material.Index -> Html m
heroTabs lift model index =
    let
        active_tab_index =
            Dict.get index model.states |> Maybe.withDefault 0
    in
    TabBar.view (lift << Mdc)
        index
        model.mdc
        [ TabBar.activeTab active_tab_index ]
        [ tab lift model index 0 "Home"
        , tab lift model index 1 "Merchandise"
        , tab lift model index 2 "About Us"
        ]


tabsWithIcons : (Msg m -> m) -> Model m -> Material.Index -> List (TabBar.Property m) -> Html m
tabsWithIcons lift model index options =
    let
        active_tab_index =
            Dict.get index model.states |> Maybe.withDefault 0
    in
    TabBar.view (lift << Mdc)
        index
        model.mdc
        [ TabBar.activeTab active_tab_index ]
        [ iconTab lift model index 0 "access_time" "Recents" options
        , iconTab lift model index 1 "near_me" "Nearby" options
        , iconTab lift model index 2 "favorite" "Favorites" options
        ]


tabsWithStackedIcons : (Msg m -> m) -> Model m -> Material.Index -> Html m
tabsWithStackedIcons lift model index =
    let
        active_tab_index =
            Dict.get index model.states |> Maybe.withDefault 0
    in
    TabBar.view (lift << Mdc)
        index
        model.mdc
        [ TabBar.activeTab active_tab_index ]
        [ stackedTab lift model index 0 "access_time" "Recents"
        , stackedTab lift model index 1 "near_me" "Nearby"
        , stackedTab lift model index 2 "favorite" "Favorites"
        ]


scrollingTabs : (Msg m -> m) -> Model m -> Material.Index -> Html m
scrollingTabs lift model index =
    let
        active_tab_index =
            Dict.get index model.states |> Maybe.withDefault 0
    in
    TabBar.view (lift << Mdc)
        index
        model.mdc
        [ TabBar.activeTab active_tab_index
        ]
        ([ "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve" ]
            |> List.indexedMap (\i v -> tab lift model index i ("Tab " ++ v))
        )


iconTab :
    (Msg m -> m)
    -> Model m
    -> Material.Index
    -> Int
    -> String
    -> String
    -> List (TabBar.Property m)
    -> TabBar.Tab m
iconTab lift model index tab_index icon label options =
    TabBar.tab
        ([ Options.onClick (lift (SelectTab index tab_index))
         , TabBar.icon icon
         ]
            ++ options
        )
        [ text label ]


stackedTab :
    (Msg m -> m)
    -> Model m
    -> Material.Index
    -> Int
    -> String
    -> String
    -> TabBar.Tab m
stackedTab lift model index tab_index icon label =
    TabBar.tab
        [ Options.onClick (lift (SelectTab index tab_index))
        , TabBar.icon icon
        , TabBar.stacked
        , TabBar.smallIndicator
        ]
        [ text label ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Tab Bar"
              , Hero.intro "Tabs organize and allow navigation between groups of content that are related and at the same level of hierarchy. The Tab Bar contains the Tab Scroller and Tab components."
              , Hero.component [] [ heroTabs lift model "tabs-hero-tabs" ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "tabs" "tabs" "mdc-tab-bar"
        , Page.demos
            [ styled h3 [ Typography.subtitle1 ] [ text "Tabs with icons next to labels" ]
            , tabsWithIcons lift model "tabs-with-icons" []
            , styled h3 [ Typography.subtitle1 ] [ text "Tabs with icons above labels and indicators restricted to content" ]
            , tabsWithStackedIcons lift model "tabs-with-stacked-icons"
            , styled h3 [ Typography.subtitle1 ] [ text "Scrolling tabs" ]
            , scrollingTabs lift model "scrolling-tabs"
            ]
        ]
