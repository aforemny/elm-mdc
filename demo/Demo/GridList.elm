module Demo.GridList exposing (Model, defaultModel, Msg, subscriptions, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.Checkbox as Checkbox
import Material.GridList as GridList
import Material.Options as Options exposing (styled, css, cs, when)


type alias Model =
    { rtl : Bool
    , mdl : Material.Model
    }


defaultModel : Model
defaultModel =
    { rtl = False
    , mdl = Material.defaultModel
    }


type Msg m
    = Mdl (Material.Msg m)
    | ToggleRtl


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model
        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        h2 options =
            styled Html.h2
              ( css "font-size" "1.3em"
              :: css "margin-bottom" "0.8em"
              :: css "margin-top" "0.8em"
              :: options
              )
    in
    page.body "Grid list"
    [
      Page.hero []
      [ GridList.render (lift << Mdl) [0] model.mdl
        [ css "width" "340px"
        ]
        ( List.repeat 12 <|
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
      [ styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Checkbox.render (Mdl >> lift) [0] model.mdl
          [ Options.onClick (lift ToggleRtl)
          , Checkbox.checked |> when model.rtl
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
      [
        h2 [] [ text "Grid List (Default): empty grid" ]
      , GridList.render (lift << Mdl) [1] model.mdl [] []

      , h2 [] [ text "Grid List (Default): tile aspect ratio 1x1 with oneline footer caption" ]
      , GridList.render (lift << Mdl) [2] model.mdl []
        ( ( GridList.tile []
            [ GridList.primary []
              [ GridList.image [] "images/1-1.jpg"
              ]
            , GridList.secondary []
              [ GridList.title []
                [ text "Single Very Long Grid Title Line"
                ]
              ]
            ]
          )
          |> List.repeat 6
        )

      , h2 [] [ text "Grid List: tile aspect ratio 1x1 with 1px gutter" ]
      , GridList.render (lift << Mdl) [3] model.mdl
        [ GridList.gutter1
        ]
        ( ( GridList.tile
            [
            ]
            [ GridList.primary []
              [ GridList.image [] "images/1-1.jpg"
              ]
            , GridList.secondary []
              [ GridList.title []
                [ text "Single Very Long Grid Title Line"
                ]
              ]
            ]
          )
          |> List.repeat 6
        )

      , h2 [] [ text "Grid List: tile aspect ratio 1x1 image only" ]
      , GridList.render (lift << Mdl) [4] model.mdl []
        ( ( GridList.tile []
            [ GridList.primary []
              [ GridList.image [] "images/1-1.jpg"
              ]
            ]
          )
          |> List.repeat 6
        )

      , h2 [] [ text "Grid List: tile aspect ratio 1x1 with oneline header caption" ]
      , GridList.render (lift << Mdl) [5] model.mdl
        [ GridList.headerCaption
        ]
        ( ( GridList.tile []
            [ GridList.primary []
              [ GridList.image [] "images/1-1.jpg"
              ]
            , GridList.secondary []
              [ GridList.title []
                [ text "Single Very Long Grid Title Line"
                ]
              ]
            ]
          )
          |> List.repeat 6
        )

      , h2 [] [ text "Grid List: tile aspect ratio 1x1 with twoline footer caption" ]
      , GridList.render (lift << Mdl) [6] model.mdl
        [ GridList.twolineCaption
        ]
        ( ( GridList.tile []
            [ GridList.primary []
              [ GridList.image [] "images/1-1.jpg"
              ]
            , GridList.secondary []
              [ GridList.title []
                [ text "Single Very Long Grid Title Line"
                ]
              , GridList.supportingText []
                [ text "Support text"
                ]
              ]
            ]
          )
          |> List.repeat 6
        )

      , h2 [] [ text "Grid List: tile aspect ratio 1x1 with oneline footer caption and icon at start of the caption" ]
      , GridList.render (lift << Mdl) [7] model.mdl
        [ GridList.iconAlignStart
        ]
        ( ( GridList.tile []
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
          )
          |> List.repeat 6
        )

      , h2 [] [ text "Grid List: tile aspect ratio 1x1 with twoline footer caption and icon at start of the caption" ]
      , GridList.render (lift << Mdl) [8] model.mdl
        [ GridList.iconAlignStart
        , GridList.twolineCaption
        ]
        ( ( GridList.tile []
            [ GridList.primary []
              [ GridList.image [] "images/1-1.jpg"
              ]
            , GridList.secondary []
              [ GridList.icon [] "star_border"
              , GridList.title []
                [ text "Single Very Long Grid Title Line"
                ]
              , GridList.supportingText []
                [ text "Support text"
                ]
              ]
            ]
          )
          |> List.repeat 6
        )

      , h2 [] [ text "Grid List: tile aspect ratio 1x1 with oneline footer caption and icon at end of the caption" ]
      , GridList.render (lift << Mdl) [9] model.mdl
        [ GridList.iconAlignEnd
        ]
        ( ( GridList.tile []
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
          )
          |> List.repeat 6
        )

      , h2 [] [ text "Grid List: tile aspect ratio 1x1 with twoline footer caption and icon at end of the caption" ]
      , GridList.render (lift << Mdl) [10] model.mdl
        [ GridList.twolineCaption
        , GridList.iconAlignEnd
        ]
        ( ( GridList.tile []
            [ GridList.primary []
              [ GridList.image [] "images/1-1.jpg"
              ]
            , GridList.secondary []
              [ GridList.icon [] "star_border"
              , GridList.title []
                [ text "Single Very Long Grid Title Line"
                ]
              , GridList.supportingText []
                [ text "Support text"
                ]
              ]
            ]
          )
          |> List.repeat 6
        )

      , h2 [] [ text "Grid List: tile aspect ratio 16x9 with oneline footer caption (Support: 16:9, 4:3, 3:4, 2:3, 3:2 as well)" ]
      , GridList.render (lift << Mdl) [11] model.mdl
        [ GridList.tileAspect16x9
        ]
        ( ( GridList.tile []
            [ GridList.primary []
              [ GridList.image [] "images/16-9.jpg"
              ]
            , GridList.secondary []
              [ GridList.title []
                [ text "Single Very Long Grid Title Line"
                ]
              ]
            ]
          )
          |> List.repeat 6
        )

      , h2 [] [ text "Grid List: use div's background instead of img tag (useful when image ratio cannot be ensured)" ]
      , GridList.render (lift << Mdl) [12] model.mdl
        [ GridList.headerCaption
        ]
        ( ( GridList.tile []
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
          )
          |> List.repeat 6
        )
      ]
    ]


subscriptions : (Msg m -> m) -> Model -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdl) model
