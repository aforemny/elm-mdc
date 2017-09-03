module Demo.Menus exposing (Model, defaultModel, Msg(Mdl), view, update, subscriptions)

import Demo.Page as Page exposing (Page)
import Html.Attributes as Html
import Html.Events as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.List as Lists
import Material.Menu as Menu
import Material.Options as Options exposing (styled, cs, css, nop, when)
import Material.Theme as Theme


type alias Model =
    { mdl : Material.Model
    , position : List String
    , darkMode : Bool
    , selected : Maybe ( Int, String )
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , position = [ "top", "left" ]
    , darkMode = False
    , selected = Nothing
    }


type Msg m
    = Mdl (Material.Msg m)
    | SetPosition ( List String )
    | Select ( Int, String )
    | ToggleDarkMode


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model

        SetPosition v ->
            ( { model | position = v }, Cmd.none )

        Select v ->
            ( { model | selected = Just v }, Cmd.none )

        ToggleDarkMode ->
            ( { model | darkMode = not model.darkMode }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    page.body "Simple Menu"
    [
      Page.hero []
      [ Menu.render (Mdl >> lift) [0] model.mdl
        [ cs "mdc-simple-menu--open"
        , css "transform" "scale(1,1)"
        , css "top" "unset"
        , css "left" "unset"
        , css "bottom" "unset"
        , css "right" "unset"
        ]
        ( Menu.ul Lists.ul []
          [ Menu.li Lists.li []
            [ text "Back"
            ]
          , Menu.li Lists.li []
            [ text "Forward"
            ]
          , Menu.li Lists.li []
            [ text "Reload"
            ]
          , Menu.li Lists.divider [] []
          , Menu.li Lists.li []
            [ text "Help & Feedback"
            ]
          , Menu.li Lists.li []
            [ text "Settings"
            ]
          ]
        )
      ]

    , styled Html.div
      [ cs "demo-content"
      , css "position" "relative"
      , css "flex" "1"
      , css "margin-top" "16px"
      , when model.darkMode << Options.many <|
        [ Theme.dark
        , css "background-color" "#333"
        ]
      ]
      [ styled Html.div
        [ cs "mdc-menu-anchor"
        , css "margin" "16px"
        , css "position" "absolute"
        , model.position
          |> List.map (\ c -> css c "0" )
          |> Options.many
        ]
        [ Button.render (Mdl >> lift) [1] model.mdl
          [ Button.raised
          , Button.primary
          , Menu.attach (Mdl >> lift) [2]
          ]
          [ text "Reveal menu"
          ]

        , Menu.render (Mdl >> lift) [2] model.mdl
          [ when model.darkMode Menu.themeDark
          ]
          ( Menu.ul Lists.ul []
            [ Menu.li Lists.li
              [ Menu.onSelect (lift (Select (0, "Back")))
              , Options.attribute (Html.tabindex 0)
              ]
              [ text "Back"
              ]
            , Menu.li Lists.li
              [ Menu.onSelect (lift (Select (1, "Forward")))
              , Options.attribute (Html.tabindex 0)
              ]
              [ text "Forward"
              ]
            , Menu.li Lists.li
              [ Menu.onSelect (lift (Select (2, "Reload")))
              , Options.attribute (Html.tabindex 0)
              ]
              [ text "Reload"
              ]
            , Menu.li Lists.divider [] []
            , Menu.li Lists.li
              [ Menu.onSelect (lift (Select (3, "Save As…")))
              , Options.attribute (Html.tabindex 0)
              ]
              [ text "Save As…"
              ]
            ]
          )
        ]
      , styled Html.div
        [ cs "demo-controls-container"
        , css "width" "100%"
        , css "height" "100%"
        ]
        [ styled Html.div
          [ cs "demo-controls"
          , css "width" "320px"
          , css "margin-left" "auto"
          , css "margin-right" "auto"
          ]
          [ Html.p []
            [ text "Button position:"
            ]

          , Html.div []
            [ Html.label []
              [ Html.input
                [ Html.type_ "radio"
                , Html.checked ( model.position == [ "top", "left" ] )
                , Html.on "change" (Json.succeed (lift (SetPosition [ "top", "left" ])))
                ]
                []
              , text "Top left"
              ]
            ]

          , Html.div []
            [ Html.label []
              [ Html.input
                [ Html.type_ "radio"
                , Html.checked ( model.position == [ "top", "right" ] )
                , Html.on "change" (Json.succeed (lift (SetPosition [ "top", "right" ])))
                ]
                []
              , text "Top right"
              ]
            ]

          , Html.div []
            [ Html.label []
              [ Html.input
                [ Html.type_ "radio"
                , Html.checked ( model.position == [ "bottom", "left" ] )
                , Html.on "change" (Json.succeed (lift (SetPosition [ "bottom", "left" ])))
                ]
                []
              , text "Bottom left"
              ]
            ]

          , Html.div []
            [ Html.label []
              [ Html.input
                [ Html.type_ "radio"
                , Html.checked ( model.position == [ "bottom", "right" ] )
                , Html.on "change" (Json.succeed (lift (SetPosition [ "bottom", "right" ])))
                ]
                []
              , text "Bottom right"
              ]
            ]

          , Html.p [] []

          , Html.p []
            [ Html.label []
              [ Html.input
                [ Html.type_ "checkbox"
                , Html.checked model.darkMode
                , Html.on "change" (Json.succeed (lift ToggleDarkMode))
                ]
                []
              , text "Dark mode"
              ]
            ]

          , Html.div []
            [ Html.span []
              [ text "Last Selected item: "
              ]
            , Html.em []
              [ text <|
                case model.selected of
                    Just ( index, label ) ->
                        "\"" ++ label ++ "\" at index " ++ toString index
                    Nothing ->
                        "<none selected>"
              ]
            ]
          ]
        ]
      ]
    ]


subscriptions : (Msg m -> m) -> Model -> Sub m
subscriptions lift model =
    Menu.subs (Mdl >> lift) model.mdl
