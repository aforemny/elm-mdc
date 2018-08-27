module Demo.Menus exposing (Model, Msg(..), defaultModel, subscriptions, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Html.Events as Html
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.List as Lists
import Material.Menu as Menu
import Material.Options as Options exposing (cs, css, nop, styled, when)


type alias Model m =
    { mdc : Material.Model m
    , selected : Maybe ( Int, String )
    , position : List String
    , anchorCorner : Menu.Corner
    , topMargin : String
    , bottomMargin : String
    , leftMargin : String
    , rightMargin : String
    , rtl : Bool
    , rememberSelectedItem : Bool
    , openAnimation : Bool
    , menuSize : MenuSize
    , anchorWidth : AnchorWidth
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , selected = Nothing
    , position = [ "top", "left" ]
    , anchorCorner = Menu.topStartCorner
    , topMargin = "0"
    , bottomMargin = "0"
    , leftMargin = "0"
    , rightMargin = "0"
    , rtl = False
    , rememberSelectedItem = False
    , openAnimation = True
    , menuSize = Regular
    , anchorWidth = Comparable
    }


type MenuSize
    = Regular
    | Large
    | ExtraTall


type AnchorWidth
    = Small
    | Comparable
    | Wider


type Msg m
    = Mdc (Material.Msg m)
    | Select ( Int, String )
    | SetPosition (List String)
    | SetAnchorCorner Menu.Corner
    | SetTopMargin String
    | SetBottomMargin String
    | SetLeftMargin String
    | SetRightMargin String
    | ToggleRtl
    | ToggleRememberSelectedItem
    | ToggleOpenAnimation
    | SetMenuSize MenuSize
    | SetAnchorWidth AnchorWidth


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        Select value ->
            ( { model | selected = Just value }, Cmd.none )

        SetPosition position ->
            ( { model | position = position }, Cmd.none )

        SetAnchorCorner anchorCorner ->
            ( { model | anchorCorner = anchorCorner }, Cmd.none )

        SetTopMargin topMargin ->
            ( { model | topMargin = topMargin }, Cmd.none )

        SetBottomMargin bottomMargin ->
            ( { model | bottomMargin = bottomMargin }, Cmd.none )

        SetLeftMargin leftMargin ->
            ( { model | leftMargin = leftMargin }, Cmd.none )

        SetRightMargin rightMargin ->
            ( { model | rightMargin = rightMargin }, Cmd.none )

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )

        ToggleRememberSelectedItem ->
            ( { model | rememberSelectedItem = not model.rememberSelectedItem }, Cmd.none )

        ToggleOpenAnimation ->
            ( { model | openAnimation = not model.openAnimation }, Cmd.none )

        SetMenuSize menuSize ->
            ( { model | menuSize = menuSize }, Cmd.none )

        SetAnchorWidth anchorWidth ->
            ( { model | anchorWidth = anchorWidth }, Cmd.none )


menuItems : MenuSize -> List ( Int, String )
menuItems menuSize =
    case menuSize of
        Regular ->
            [ ( 0, "Back" )
            , ( 1, "Forward" )
            , ( 2, "Reload" )
            , ( -1, "-" )
            , ( 3, "Save As…" )
            , ( 4, "Help" )
            ]

        Large ->
            [ ( 0, "Back" )
            , ( 1, "Forward" )
            , ( 2, "Reload" )
            , ( -1, "-" )
            , ( 3, "Save As…" )
            , ( 4, "Help" )
            , ( 5, "Settings" )
            , ( 6, "Feedback" )
            , ( 7, "Options…" )
            , ( 8, "Item 1" )
            , ( 9, "Item 2" )
            ]

        ExtraTall ->
            [ ( 0, "Back" )
            , ( 1, "Forward" )
            , ( 2, "Reload" )
            , ( -1, "-" )
            , ( 3, "Save As…" )
            , ( 4, "Help" )
            , ( 5, "Settings" )
            , ( 6, "Feedback" )
            , ( 7, "Options…" )
            , ( 8, "Item 1" )
            , ( 9, "Item 2" )
            , ( 10, "Item 3" )
            , ( 11, "Item 4" )
            , ( 12, "Item 5" )
            , ( 13, "Item 6" )
            , ( 14, "Item 7" )
            , ( 15, "Item 8" )
            , ( 16, "Item 9" )
            ]


menuAnchor : (Msg m -> m) -> Model m -> Html m
menuAnchor lift model =
    let
        anchorMargin =
            { top = Maybe.withDefault 0 (String.toFloat model.topMargin)
            , left = Maybe.withDefault 0 (String.toFloat model.leftMargin)
            , bottom = Maybe.withDefault 0 (String.toFloat model.bottomMargin)
            , right = Maybe.withDefault 0 (String.toFloat model.rightMargin)
            }
    in
    styled Html.div
        [ cs "mdc-menu-anchor"
        , css "margin" "16px"
        , css "position" "absolute"
        , model.position
            |> List.map
                (\c ->
                    if c == "middle" then
                        css "top" "35%"
                    else
                        css c "0"
                )
            |> Options.many
        ]
        [ Button.view (lift << Mdc)
            "menus-menu-button"
            model.mdc
            [ Button.raised
            , Menu.attach (lift << Mdc) "menus-menu"
            ]
            [ text <|
                case model.anchorWidth of
                    Small ->
                        "Show"

                    Comparable ->
                        "Show Menu"

                    Wider ->
                        "Show Menu from here now!"
            ]
        , Menu.view (lift << Mdc)
            "menus-menu"
            model.mdc
            [ Menu.anchorCorner model.anchorCorner
            , Menu.anchorMargin anchorMargin
            , Menu.quickOpen |> when (not model.openAnimation)
            ]
            (Menu.ul []
                (menuItems model.menuSize
                    |> List.map
                        (\( index, label ) ->
                            if label == "-" then
                                Menu.divider [] []
                            else
                                let
                                    isSelected =
                                        Just ( index, label ) == model.selected
                                in
                                Menu.li
                                    [ Menu.onSelect (lift (Select ( index, label )))
                                    , Lists.selected |> when (model.rememberSelectedItem && isSelected)
                                    ]
                                    [ text label
                                    ]
                        )
                )
            )
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body "Menu"
        [ Page.hero []
            [ Menu.view (lift << Mdc)
                "menus-hero-menu"
                model.mdc
                [ cs "mdc-menu--open"
                ]
                (Menu.ul []
                    [ Menu.li []
                        [ text "Back"
                        ]
                    , Menu.li []
                        [ text "Forward"
                        ]
                    , Menu.li []
                        [ text "Reload"
                        ]
                    , Menu.divider [] []
                    , Menu.li []
                        [ text "Help & Feedback"
                        ]
                    , Menu.li []
                        [ text "Settings"
                        ]
                    ]
                )
            ]
        , styled Html.div
            [ cs "demo-content"
            , css "position" "relative"
            , css "flex" "1"
            , css "top" "64px"
            ]
            [ styled Html.div
                [ cs "demo-wrapper"
                , Options.attribute (Html.dir "rtl") |> when model.rtl
                ]
                [ menuAnchor lift model
                ]
            , demoControls lift model
            ]
        ]


demoControls : (Msg m -> m) -> Model m -> Html m
demoControls lift model =
    styled Html.div
        [ cs "demo-controls-container"
        , css "width" "100%"
        , css "height" "calc(100vh - 80px)"
        ]
        [ styled Html.div
            [ cs "demo-controls"
            , css "width" "360px"
            , css "margin-left" "auto"
            , css "margin-right" "auto"
            ]
            [ buttonPositions lift model
            , defaultMenuPosition lift model
            , Html.p [] [ text "Anchor Margins" ]
            , marginInputs lift model
            , Html.p [] []
            , styled Html.div
                []
                [ styled Html.label
                    []
                    [ Html.input
                        [ Html.type_ "checkbox"
                        , Html.checked model.rtl
                        , Html.on "click" (Json.succeed (lift ToggleRtl))
                        ]
                        []
                    , text " "
                    , text "RTL"
                    ]
                ]
            , styled Html.div
                []
                [ styled Html.label
                    []
                    [ Html.input
                        [ Html.type_ "checkbox"
                        , Html.checked model.rememberSelectedItem
                        , Html.on "click" (Json.succeed (lift ToggleRememberSelectedItem))
                        ]
                        []
                    , text " "
                    , text "Remember Selected Item"
                    ]
                ]
            , styled Html.div
                []
                [ styled Html.label
                    []
                    [ Html.input
                        [ Html.type_ "checkbox"
                        , Html.checked (not model.openAnimation)
                        , Html.on "click" (Json.succeed (lift ToggleOpenAnimation))
                        ]
                        []
                    , text " "
                    , text "Disable Open Animation"
                    ]
                ]
            , Html.p [] []
            , menuSizes lift model
            , anchorWidths lift model
            , Html.p [] []
            , Html.hr [] []
            , Html.div []
                [ Html.span []
                    [ text "Last Selected item: "
                    ]
                , Html.em []
                    [ text <|
                        case model.selected of
                            Just ( index, label ) ->
                                "\"" ++ label ++ "\" at index " ++ String.fromInt index

                            Nothing ->
                                "<none selected>"
                    ]
                ]
            ]
        ]


buttonPositions : (Msg m -> m) -> Model m -> Html m
buttonPositions lift model =
    styled Html.div
        [ css "display" "inline-block"
        , css "vertical-align" "top"
        ]
        (List.concat
            [ [ text "Button Position:"
              ]
            , [ { label = "Top left", position = [ "top", "left" ] }
              , { label = "Top right", position = [ "top", "right" ] }
              , { label = "Middle left", position = [ "middle", "left" ] }
              , { label = "Middle right", position = [ "middle", "right" ] }
              , { label = "Bottom left", position = [ "bottom", "left" ] }
              , { label = "Bottom right", position = [ "bottom", "right" ] }
              ]
                |> List.map
                    (\{ label, position } ->
                        styled Html.div
                            []
                            [ styled Html.label
                                []
                                [ Html.input
                                    [ Html.type_ "radio"
                                    , Html.checked (model.position == position)
                                    , Html.on "click" (Json.succeed (lift (SetPosition position)))
                                    ]
                                    []
                                , text " "
                                , text label
                                ]
                            ]
                    )
            ]
        )


defaultMenuPosition : (Msg m -> m) -> Model m -> Html m
defaultMenuPosition lift model =
    styled Html.div
        [ css "display" "inline-block"
        , css "vertical-align" "top"
        , css "margin-left" "2rem"
        ]
        (List.concat
            [ [ text "Default Menu Position:"
              ]
            , [ { label = "Top start", anchorCorner = Menu.topStartCorner }
              , { label = "Top end", anchorCorner = Menu.topEndCorner }
              , { label = "Bottom start", anchorCorner = Menu.bottomStartCorner }
              , { label = "Bottom end", anchorCorner = Menu.bottomEndCorner }
              ]
                |> List.map
                    (\{ label, anchorCorner } ->
                        styled Html.div
                            []
                            [ styled Html.label
                                []
                                [ Html.input
                                    [ Html.type_ "radio"
                                    , Html.checked (model.anchorCorner == anchorCorner)
                                    , Html.on "click" (Json.succeed (lift (SetAnchorCorner anchorCorner)))
                                    ]
                                    []
                                , text " "
                                , text label
                                ]
                            ]
                    )
            ]
        )


marginInputs : (Msg m -> m) -> Model m -> Html m
marginInputs lift model =
    styled Html.div
        []
        ([ { label = "T", msg = SetTopMargin, value = .topMargin }
         , { label = "B", msg = SetBottomMargin, value = .bottomMargin }
         , { label = "L", msg = SetLeftMargin, value = .leftMargin }
         , { label = "R", msg = SetRightMargin, value = .rightMargin }
         ]
            |> List.map
                (\{ label, msg, value } ->
                    styled Html.label
                        []
                        [ text (label ++ ":")
                        , text " "
                        , styled Html.input
                            [ Options.many
                                << List.map Options.attribute
                              <|
                                [ Html.type_ "text"
                                , Html.size 3
                                , Html.maxlength 3
                                , Html.value (value model)
                                ]
                            , css "width" "2rem"
                            , Options.on "change" (Json.map (lift << msg) Html.targetValue)
                            ]
                            []
                        ]
                )
            |> List.intersperse (text " ")
        )


menuSizes : (Msg m -> m) -> Model m -> Html m
menuSizes lift model =
    styled Html.div
        [ css "display" "inline-block"
        , css "vertical-align" "top"
        ]
        (List.concat
            [ [ text "Menu Sizes:"
              ]
            , [ { label = "Regular menu", size = Regular }
              , { label = "Large menu", size = Large }
              , { label = "Extra tall menu", size = ExtraTall }
              ]
                |> List.map
                    (\{ label, size } ->
                        styled Html.div
                            []
                            [ styled Html.label
                                []
                                [ Html.input
                                    [ Html.type_ "radio"
                                    , Html.checked (model.menuSize == size)
                                    , Html.on "click" (Json.succeed (lift (SetMenuSize size)))
                                    ]
                                    []
                                , text " "
                                , text label
                                ]
                            ]
                    )
            ]
        )


anchorWidths : (Msg m -> m) -> Model m -> Html m
anchorWidths lift model =
    styled Html.div
        [ css "display" "inline-block"
        , css "vertical-align" "top"
        , css "margin-left" "2rem"
        ]
        (List.concat
            [ [ text "Anchor Widths:"
              ]
            , [ { label = "Small button", width = Small }
              , { label = "Comparable to menu", width = Comparable }
              , { label = "Wider than menu", width = Wider }
              ]
                |> List.map
                    (\{ label, width } ->
                        styled Html.div
                            []
                            [ styled Html.label
                                []
                                [ Html.input
                                    [ Html.type_ "radio"
                                    , Html.checked (model.anchorWidth == width)
                                    , Html.on "click" (Json.succeed (lift (SetAnchorWidth width)))
                                    ]
                                    []
                                , text " "
                                , text label
                                ]
                            ]
                    )
            ]
        )


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
