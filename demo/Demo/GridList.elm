module Demo.GridList exposing (Model, Msg, defaultModel, subscriptions, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.Checkbox as Checkbox
import Material.FormField as FormField
import Material.GridList as GridList
import Material.Options as Options exposing (cs, css, styled, when)


type alias Model m =
    { rtl : Bool
    , mdc : Material.Model m
    }


defaultModel : Model m
defaultModel =
    { rtl = False
    , mdc = Material.defaultModel
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleRtl


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    let
        h2 options =
            styled Html.h2
                (css "font-size" "1.3em"
                    :: css "margin-bottom" "0.8em"
                    :: css "margin-top" "0.8em"
                    :: options
                )
    in
    page.body "Grid list"
        [ Page.hero []
            [ GridList.view (lift << Mdc)
                "grid-list-hero-grid-list"
                model.mdc
                [ css "width" "340px"
                ]
                (List.repeat 12 <|
                    GridList.tile
                        [ css "width" "72px"
                        , css "margin" "2px 0"
                        ]
                        [ GridList.primary
                            [ css "background-color" "#000"
                            ]
                            []
                        ]
                )
            ]
        , styled Html.section
            [ cs "example"
            , css "padding" "24px"
            , css "marign" "24px"
            ]
            [ FormField.view []
                [ Checkbox.view (lift << Mdc)
                    "grid-list-toggle-rtl"
                    model.mdc
                    [ Options.onClick (lift ToggleRtl)
                    , Checkbox.checked model.rtl
                    ]
                    []
                , Html.label []
                    [ text "Toggle RTL"
                    ]
                ]
            ]
        , styled Html.section
            [ cs "example"
            , cs "examples"
            , css "padding" "24px"
            , css "marign" "24px"
            , Options.attribute (Html.dir "rtl") |> when model.rtl
            ]
            [ h2 [] [ text "Grid List (Default): empty grid" ]
            , GridList.view (lift << Mdc) "grid-list-default-grid-list" model.mdc [] []
            , h2 [] [ text "Grid List (Default): tile aspect ratio 1x1 with oneline footer caption" ]
            , GridList.view (lift << Mdc)
                "grid-list-online-footer-grid-list"
                model.mdc
                []
                (GridList.tile []
                    [ GridList.primary []
                        [ GridList.image [] "images/1-1.jpg"
                        ]
                    , GridList.secondary []
                        [ GridList.title []
                            [ text "Single Very Long Grid Title Line"
                            ]
                        ]
                    ]
                    |> List.repeat 6
                )
            , h2 [] [ text "Grid List: tile aspect ratio 1x1 with 1px gutter" ]
            , GridList.view (lift << Mdc)
                "grid-list-gutter-grid-list"
                model.mdc
                [ GridList.gutter1
                ]
                (GridList.tile
                    []
                    [ GridList.primary []
                        [ GridList.image [] "images/1-1.jpg"
                        ]
                    , GridList.secondary []
                        [ GridList.title []
                            [ text "Single Very Long Grid Title Line"
                            ]
                        ]
                    ]
                    |> List.repeat 6
                )
            , h2 [] [ text "Grid List: tile aspect ratio 1x1 image only" ]
            , GridList.view (lift << Mdc)
                "grid-list-image-only-grid-list"
                model.mdc
                []
                (GridList.tile []
                    [ GridList.primary []
                        [ GridList.image [] "images/1-1.jpg"
                        ]
                    ]
                    |> List.repeat 6
                )
            , h2 [] [ text "Grid List: tile aspect ratio 1x1 with oneline header caption" ]
            , GridList.view (lift << Mdc)
                "grid-list-oneline-header-grid-list"
                model.mdc
                [ GridList.headerCaption
                ]
                (GridList.tile []
                    [ GridList.primary []
                        [ GridList.image [] "images/1-1.jpg"
                        ]
                    , GridList.secondary []
                        [ GridList.title []
                            [ text "Single Very Long Grid Title Line"
                            ]
                        ]
                    ]
                    |> List.repeat 6
                )
            , h2 [] [ text "Grid List: tile aspect ratio 1x1 with twoline footer caption" ]
            , GridList.view (lift << Mdc)
                "grid-list-two-line-footer-grid-list"
                model.mdc
                [ GridList.twolineCaption
                ]
                (GridList.tile []
                    [ GridList.primary []
                        [ GridList.image [] "images/1-1.jpg"
                        ]
                    , GridList.secondary []
                        [ GridList.title []
                            [ text "Single Very Long Grid Title Line"
                            ]
                        , GridList.supportText []
                            [ text "Support text"
                            ]
                        ]
                    ]
                    |> List.repeat 6
                )
            , h2 [] [ text "Grid List: tile aspect ratio 1x1 with oneline footer caption and icon at start of the caption" ]
            , GridList.view (lift << Mdc)
                "grid-list-footer-oneline-footer-grid-list-with-icon"
                model.mdc
                [ GridList.iconAlignStart
                ]
                (GridList.tile []
                    [ GridList.primary []
                        [ GridList.image [] "images/1-1.jpg"
                        ]
                    , GridList.secondary []
                        [ GridList.icon [] "star_border"
                        , GridList.title []
                            [ text "Single Very Long Grid Title Line"
                            ]
                        ]
                    ]
                    |> List.repeat 6
                )
            , h2 [] [ text "Grid List: tile aspect ratio 1x1 with twoline footer caption and icon at start of the caption" ]
            , GridList.view (lift << Mdc)
                "grid-list-twoline-footer-grid-list-with-icon"
                model.mdc
                [ GridList.iconAlignStart
                , GridList.twolineCaption
                ]
                (GridList.tile []
                    [ GridList.primary []
                        [ GridList.image [] "images/1-1.jpg"
                        ]
                    , GridList.secondary []
                        [ GridList.icon [] "star_border"
                        , GridList.title []
                            [ text "Single Very Long Grid Title Line"
                            ]
                        , GridList.supportText []
                            [ text "Support text"
                            ]
                        ]
                    ]
                    |> List.repeat 6
                )
            , h2 [] [ text "Grid List: tile aspect ratio 1x1 with oneline footer caption and icon at end of the caption" ]
            , GridList.view (lift << Mdc)
                "grid-list-online-footer-grid-list-with-icon-at-end"
                model.mdc
                [ GridList.iconAlignEnd
                ]
                (GridList.tile []
                    [ GridList.primary []
                        [ GridList.image [] "images/1-1.jpg"
                        ]
                    , GridList.secondary []
                        [ GridList.icon [] "star_border"
                        , GridList.title []
                            [ text "Single Very Long Grid Title Line"
                            ]
                        ]
                    ]
                    |> List.repeat 6
                )
            , h2 [] [ text "Grid List: tile aspect ratio 1x1 with twoline footer caption and icon at end of the caption" ]
            , GridList.view (lift << Mdc)
                "grid-list-twoline-footer-gridlist-with-icon-at-end"
                model.mdc
                [ GridList.twolineCaption
                , GridList.iconAlignEnd
                ]
                (GridList.tile []
                    [ GridList.primary []
                        [ GridList.image [] "images/1-1.jpg"
                        ]
                    , GridList.secondary []
                        [ GridList.icon [] "star_border"
                        , GridList.title []
                            [ text "Single Very Long Grid Title Line"
                            ]
                        , GridList.supportText []
                            [ text "Support text"
                            ]
                        ]
                    ]
                    |> List.repeat 6
                )
            , h2 [] [ text "Grid List: tile aspect ratio 16x9 with oneline footer caption (Support: 16:9, 4:3, 3:4, 2:3, 3:2 as well)" ]
            , GridList.view (lift << Mdc)
                "grid-list-16-9-grid-list"
                model.mdc
                [ GridList.tileAspect16To9
                ]
                (GridList.tile []
                    [ GridList.primary []
                        [ GridList.image [] "images/16-9.jpg"
                        ]
                    , GridList.secondary []
                        [ GridList.title []
                            [ text "Single Very Long Grid Title Line"
                            ]
                        ]
                    ]
                    |> List.repeat 6
                )
            , h2 [] [ text "Grid List: use div's background instead of img tag (useful when image ratio cannot be ensured)" ]
            , GridList.view (lift << Mdc)
                "grid-list-background-image-grid-list"
                model.mdc
                [ GridList.headerCaption
                ]
                (GridList.tile []
                    [ GridList.primary []
                        [ GridList.primaryContent
                            [ css "background-image" "url(images/16-9.jpg)" ]
                            []
                        ]
                    , GridList.secondary []
                        [ GridList.title []
                            [ text "Single Very Long Grid Title Line"
                            ]
                        ]
                    ]
                    |> List.repeat 6
                )
            ]
        ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
