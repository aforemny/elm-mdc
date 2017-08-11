module Demo.Tabs exposing (Model,defaultModel,Msg(Mdl),update,view)

import Dict exposing (Dict)
import Html exposing (..)
import Material
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Tabs as TabBar
import Material.Toolbar as Toolbar
import Material.Typography as Typography
import Material.Theme as Theme
import Platform.Cmd exposing (Cmd, none)


-- MODEL


type alias Model =
    { mdl : Material.Model
    , examples : Dict Int Example
    }


type alias Example =
    { tab : Int
    }


defaultExample : Example
defaultExample =
    { tab = 0
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , examples = Dict.empty
    }



-- ACTION, UPDATE


type Msg
    = SelectTab Int Int
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectTab index tabIndex ->
            let
                example =
                    Dict.get index model.examples
                    |> Maybe.withDefault defaultExample
                    |> \example ->
                       { example | tab = tabIndex }
            in
            { model | examples = Dict.insert index example model.examples } ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


view : Model -> Html Msg
view model =
    div
    [
    ]
    [ example0  model.mdl  0 (Dict.get  0 model.examples |> Maybe.withDefault defaultExample)
    , example1  model.mdl  1 (Dict.get  1 model.examples |> Maybe.withDefault defaultExample)
    , example2  model.mdl  2 (Dict.get  2 model.examples |> Maybe.withDefault defaultExample)
    , example3  model.mdl  3 (Dict.get  3 model.examples |> Maybe.withDefault defaultExample)
    , example4  model.mdl  4 (Dict.get  4 model.examples |> Maybe.withDefault defaultExample)
    , example5  model.mdl  5 (Dict.get  5 model.examples |> Maybe.withDefault defaultExample)
    , example6  model.mdl  6 (Dict.get  6 model.examples |> Maybe.withDefault defaultExample)
    , example7  model.mdl  7 (Dict.get  7 model.examples |> Maybe.withDefault defaultExample)
    , example8  model.mdl  8 (Dict.get  8 model.examples |> Maybe.withDefault defaultExample)
    , example9  model.mdl  9 (Dict.get  9 model.examples |> Maybe.withDefault defaultExample)
    , example10 model.mdl 10 (Dict.get 10 model.examples |> Maybe.withDefault defaultExample)
    ]


example0 : Material.Model -> Int -> Example -> Html Msg
example0 mdl index model =
    styled Html.section
    [
    ]
    [ styled Html.legend
      [ Typography.title
      ]
      [ text "Basic Tab Bar"
      ]
    , TabBar.render Mdl [index] mdl
      [ TabBar.indicator
      ]
      [ TabBar.tab [] [ text "Item One" ]
      , TabBar.tab [] [ text "Item Two" ]
      , TabBar.tab [] [ text "Item Three" ]
      ]
    ]


-- TODO: Scroller

example1 : Material.Model -> Int -> Example -> Html Msg
example1 mdl index model =
    styled Html.section
    [
    ]
    [ styled Html.legend
      [ Typography.title
      ]
      [ text "Tab Bar with Scroller"
      ]
    , TabBar.render Mdl [index] mdl
      [ TabBar.indicator
      , TabBar.scroller
      ]
      [ TabBar.tab [] [ text "Item One" ]
      , TabBar.tab [] [ text "Item Two" ]
      , TabBar.tab [] [ text "Item Three" ]
      , TabBar.tab [] [ text "Item Four" ]
      , TabBar.tab [] [ text "Item Five" ]
      , TabBar.tab [] [ text "Item Six" ]
      , TabBar.tab [] [ text "Item Seven" ]
      , TabBar.tab [] [ text "Item Eight" ]
      , TabBar.tab [] [ text "Item Nine" ]
      ]
    ]


example2 : Material.Model -> Int -> Example -> Html Msg
example2 mdl index model =
    styled Html.section
    [
    ]
    [ styled Html.legend
      [ Typography.title
      ]
      [ text "Icon Tab Labels"
      ]
    , TabBar.render Mdl [index] mdl
      [ TabBar.indicator
      ]
      [ TabBar.tab [] [ TabBar.icon [] "phone" ]
      , TabBar.tab [] [ TabBar.icon [] "favorite" ]
      , TabBar.tab [] [ TabBar.icon [] "person_pin" ]
      ]
    ]


example3 : Material.Model -> Int -> Example -> Html Msg
example3 mdl index model =
    styled Html.section
    [
    ]
    [ styled Html.legend
      [ Typography.title
      ]
      [ text "Icon Tab Labels"
      ]
    , TabBar.render Mdl [index] mdl
      [ TabBar.indicator
      ]
      [ TabBar.tab [ TabBar.withIconAndText ] [ TabBar.icon [] "phone", TabBar.iconLabel [] "Recents" ]
      , TabBar.tab [] [ TabBar.icon [] "favorite", TabBar.iconLabel [] "Favorites" ]
      , TabBar.tab [] [ TabBar.icon [] "person_pin", TabBar.iconLabel [] "Nearby" ]
      ]
    ]


example4 : Material.Model -> Int -> Example -> Html Msg
example4 mdl index model =
    styled Html.section
    [
    ]
    [ styled Html.legend
        [ Typography.title
        ]
        [ text "Primary Color Indicator"
        ]
      , TabBar.render Mdl [index] mdl
        [ TabBar.indicator
        , TabBar.indicatorPrimary
        ]
        [ TabBar.tab [] [ text "Item One" ]
        , TabBar.tab [] [ text "Item Two" ]
        , TabBar.tab [] [ text "Item Three" ]
        ]
    ]


example5 : Material.Model -> Int -> Example -> Html Msg
example5 mdl index model =
    styled Html.section
    [
    ]
    [ styled Html.legend
      [ Typography.title
      ]
      [ text "Accent Color Indicator"
      ]
    , TabBar.render Mdl [index] mdl
      [ TabBar.indicator
      , TabBar.indicatorAccent
      ]
      [ TabBar.tab [] [ text "Item One" ]
      , TabBar.tab [] [ text "Item Two" ]
      , TabBar.tab [] [ text "Item Three" ]
      ]
    ]


example6 : Material.Model -> Int -> Example -> Html Msg
example6 mdl index model =
    styled Html.section
    [
    ]
    [ styled Html.legend
      [ Typography.title
      ]
      [ text "Within mdc-toolbar"
      ]
    , Toolbar.view
      [
      ]
      [ Toolbar.row []
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ TabBar.render Mdl [index] mdl
            [ TabBar.indicator
            ]
            [ TabBar.tab [] [ text "Item One" ]
            , TabBar.tab [] [ text "Item Two" ]
            , TabBar.tab [] [ text "Item Three" ]
            ]
          ]
        ]
      ]
    ]


example7 : Material.Model -> Int -> Example -> Html Msg
example7 mdl index model =
    styled Html.section
    [
    ]
    [ styled Html.legend
      [ Typography.title
      ]
      [ text "Within mdc-toolbar"
      ]
    , Toolbar.view
      [
      ]
      [ Toolbar.row []
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          , css "position" "absolute"
          , css "right" "0"
          , css "bottom" "-16px"
          ]
          [ TabBar.render Mdl [index] mdl
            [
            ]
            [ TabBar.tab [] [ text "Item One" ]
            , TabBar.tab [] [ text "Item Two" ]
            , TabBar.tab [] [ text "Item Three" ]
            ]
          ]
        ]
      ]
    ]


example8 : Material.Model -> Int -> Example -> Html Msg
example8 mdl index model =
    styled Html.section
    [
    ]
    [ styled Html.legend
      [ Typography.title
      ]
      [ text "Within mdc-toolbar + primary indicator"
      ]
    , Toolbar.view
      [ Theme.accentBg
      ]
      [ Toolbar.row []
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ TabBar.render Mdl [index] mdl
            [ TabBar.indicator
            , TabBar.indicatorPrimary
            ]
            [ TabBar.tab [] [ text "Item One" ]
            , TabBar.tab [] [ text "Item Two" ]
            , TabBar.tab [] [ text "Item Three" ]
            ]
          ]
        ]
      ]
    ]


example9 : Material.Model -> Int -> Example -> Html Msg
example9 mdl index model =
    styled Html.section
    [
    ]
    [ styled Html.legend
      [ Typography.title
      ]
      [ text "Within mdc-toolbar + accent indicator"
      ]
    , Toolbar.view
      [ Theme.primaryBg
      ]
      [ Toolbar.row []
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ TabBar.render Mdl [index] mdl
            [ TabBar.indicator
            , TabBar.indicatorAccent
            ]
            [ TabBar.tab [] [ text "Item One" ]
            , TabBar.tab [] [ text "Item Two" ]
            , TabBar.tab [] [ text "Item Three" ]
            ]
          ]
        ]
      ]
    ]


example10 : Material.Model -> Int -> Example -> Html Msg
example10 mdl index model =
    let
        items =
            [ "Item One", "Item Two", "Item Three" ]
    in
    styled Html.section
    [
    ]
    [ styled Html.legend
      [ Typography.title
      ]
      [ text "Within Toolbar, Dynamic Content Control"
      ]
    , TabBar.render Mdl [index] mdl
      [ TabBar.indicator
      ]
      ( items
        |> List.indexedMap (\i label ->
             TabBar.tab
             [ Options.onClick (SelectTab index i)
             ]
             [ text label
             ]
           )
      )
    , styled Html.section
      [ cs "panels"
      , css "padding" "8px"
      , css "border" "1px solid #ccc"
      , css "border-radius" "4px"
      , css "margin-top" "8px"
      ]
      ( [ "Item One"
        , "Item Two"
        , "Item Three"
        ]
        |> List.indexedMap (\i str ->
             let
                isActive =
                    model.tab == i
             in
             styled Html.p
             [ cs "panel"
             , cs "active" |> when isActive
             , css "display" "none" |> when (not isActive)
             ]
             [ text str
             ]
           )
      )
    , styled Html.section
      [ cs "dots"
      , css "display" "flex"
      , css "justify-content" "flex-start"
      , css "margin-top" "4px"
      , css "padding-bottom" "16px"
      ]
      ( List.range 0 2
        |> List.map (\i ->
             let
                isActive =
                    model.tab == i
             in
             styled Html.a
             [ cs "dot"
             , css "margin" "0 4px"
             , css "border-radius" "50%"
             , css "border" "1px solid #64DD17"
             , css "width" "20px"
             , css "height" "20px"
             , when isActive <|
               Options.many
               [ cs "active"
               , css "background-color" "#64DD17"
               , css "border-color" "#64DD17"
               ]
             ]
             [
             ]
           )
      )
    ]

--    <section>
--      <div class="panels">
--        <p class="panel" id="panel-1" role="tabpanel" aria-hidden="false">Item One</p>
--        <p class="panel" id="panel-2" role="tabpanel" aria-hidden="true">Item Two</p>
--        <p class="panel active" id="panel-3" role="tabpanel" aria-hidden="true">Item Three</p>
--      </div>
--      <div class="dots">
--        <a class="dot" data-trigger="panel-1" href="#panel-1"></a>
--        <a class="dot" data-trigger="panel-2" href="#panel-2"></a>
--        <a class="dot active" data-trigger="panel-3" href="#panel-3"></a>
--      </div>
--    </section>
--
--
--    <div class="mdc-toolbar" id="dynamic-demo-toolbar">
--      <div class="mdc-toolbar__row">
--        <div class="mdc-toolbar__section mdc-toolbar__section--align-start">
--
--          <nav id="dynamic-tab-bar" class="mdc-tab-bar mdc-tab-bar--indicator-accent mdc-tab-bar-upgraded" role="tablist">
--            <a role="tab" aria-controls="panel-1" class="mdc-tab mdc-ripple-upgraded" href="#panel-1" style="--mdc-ripple-surface-width:160px; --mdc-ripple-surface-height:48px; --mdc-ripple-fg-size:96px; --mdc-ripple-fg-scale:1.8442177514850917; --mdc-ripple-fg-translate-start:51px, -17.75px; --mdc-ripple-fg-translate-end:32px, -24px;">Item One</a>
--            <a role="tab" aria-controls="panel-2" class="mdc-tab mdc-ripple-upgraded" href="#panel-2" style="--mdc-ripple-surface-width:160px; --mdc-ripple-surface-height:48px; --mdc-ripple-fg-size:96px; --mdc-ripple-fg-scale:1.8442177514850917; --mdc-ripple-fg-translate-start:-1px, -18.75px; --mdc-ripple-fg-translate-end:32px, -24px;">Item Two</a>
--            <a role="tab" aria-controls="panel-3" class="mdc-tab mdc-ripple-upgraded mdc-tab--active" href="#panel-3" style="--mdc-ripple-surface-width:160px; --mdc-ripple-surface-height:48px; --mdc-ripple-fg-size:96px; --mdc-ripple-fg-scale:1.8442177514850917; --mdc-ripple-fg-translate-start:-15px, -17.75px; --mdc-ripple-fg-translate-end:32px, -24px;">Item Three</a>
--            <span class="mdc-tab-bar__indicator" style="transform: translateX(320px) scale(0.333333, 1); visibility: visible;"></span>
--          </nav>
--
--        </div>
--      </div>
--    </div>
