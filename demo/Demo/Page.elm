module Demo.Page exposing (..)

import Html exposing (Html, text)
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Toolbar as Toolbar


type alias Page m =
    { toolbar : String -> Html m
    , clearTab : m
    }


toolbar : m -> Maybe Int -> String -> Html m
toolbar clearTab selectedTab title =
    Toolbar.view
    [ Toolbar.fixed
    ]
    [ Toolbar.row []
      [ Toolbar.section
        [ Toolbar.alignStart
        ]
        [ Toolbar.icon_
          [ Toolbar.menu
          ]
          [
--            case selectedTab of
--                Nothing ->
--                    Html.img
--                    [ Html.src "images/ic_component_24px_white.svg"
--                    ]
--                    []
--                Just _ ->
                    styled Html.i
                    [ cs "material-icons"
                    , Options.onClick clearTab
                    , css "cursor" "pointer"
                    ]
                    [ text "arrow_back" ]
          ]
        , Toolbar.title [] [ text title ]
        ]
      ]
    ]
