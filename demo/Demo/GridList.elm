module Demo.GridList exposing (view)

import Html exposing (Html, text)
import Material.GridList as GridList
import Material.Options exposing (styled, css, cs)


view : Html a
view =
    Html.div
    [
    ]
    [ styled Html.section
      [ cs "example"
      , cs "examples"
      ]
      [
        Html.h2 [] [ text "Grid List (Default): empty grid" ]
      , GridList.view [] []

      , Html.h2 [] [ text "Grid List (Default): tile aspect ratio 1x1 with oneline footer caption" ]
      , GridList.view []
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

      , Html.h2 [] [ text "Grid List: tile aspect ratio 1x1 with 1px gutter" ]
      , GridList.view
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

      , Html.h2 [] [ text "Grid List: tile aspect ratio 1x1 image only" ]
      , GridList.view []
        ( ( GridList.tile []
            [ GridList.primary []
              [ GridList.image [] "images/1-1.jpg"
              ]
            ]
          )
          |> List.repeat 6
        )

      , Html.h2 [] [ text "Grid List: tile aspect ratio 1x1 with oneline header caption" ]
      , GridList.view
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

      , Html.h2 [] [ text "Grid List: tile aspect ratio 1x1 with twoline footer caption" ]
      , GridList.view
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

      , Html.h2 [] [ text "Grid List: tile aspect ratio 1x1 with oneline footer caption and icon at start of the caption" ]
      , GridList.view
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

      , Html.h2 [] [ text "Grid List: tile aspect ratio 1x1 with twoline footer caption and icon at start of the caption" ]
      , GridList.view
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

      , Html.h2 [] [ text "Grid List: tile aspect ratio 1x1 with oneline footer caption and icon at end of the caption" ]
      , GridList.view
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

      , Html.h2 [] [ text "Grid List: tile aspect ratio 1x1 with twoline footer caption and icon at end of the caption" ]
      , GridList.view
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

      , Html.h2 [] [ text "Grid List: tile aspect ratio 16x9 with oneline footer caption (Support: 16:9, 4:3, 3:4, 2:3, 3:2 as well)" ]
      , GridList.view
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

      , Html.h2 [] [ text "Grid List: use div's background instead of img tag (useful when image ratio cannot be ensured)" ]
      , GridList.view
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
