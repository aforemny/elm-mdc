module Demo.Toolbar exposing ( view )

import Demo.Page exposing (Page)
import Html.Attributes as Html
import Html exposing (Html, text)
import Material.Options as Options exposing (styled, cs, css)
import Material.Toolbar as Toolbar
import Material.Typography as Typography


view : Page m -> Html m
view page =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ example "Normal Toolbar" example0
    , example "Fixed Toolbar" example1
    , example "Waterfall Toolbar" example2
    , example "Default Flexible Toolbar" example3
    , example "Waterfall Flexible Toolbar" example4
    , example "Waterfall Toolbar Fix Last Row" example5
    , example "Waterfall Flexible Toolbar with Custom Style" example6
    ]


example : String -> Html msg -> Html msg
example title example =
    styled Html.div
    [
    ]
    [ Html.h2 [] [ text title ]
    , example
    ]


example0 : Html m
example0 =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.view
      [
      ]
      [ Toolbar.row
        [
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]
    , body
    ]


example1 : Html m
example1 =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.view
      [ Toolbar.fixed
      ]
      [ Toolbar.row
        [
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]
    , body
    ]


example2 : Html m
example2 =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.view
      [ Toolbar.fixed
      , Toolbar.waterfall
      , Toolbar.flexibleSpaceMaximized
      ]
      [ Toolbar.row
        [
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]
    , body
    ]


example3 : Html m
example3 =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.view
      [ Toolbar.fixed
      , Toolbar.waterfall
      , Toolbar.flexible
      , Toolbar.flexibleDefaultBehavior
      , Toolbar.flexibleSpaceMaximized
      ]
      [ Toolbar.row
        [ css "height" "224px"
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]
    , body
    ]


example4 : Html m
example4 =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.view
      [ Toolbar.fixed
      , Toolbar.waterfall
      , Toolbar.flexible
      , Toolbar.flexibleDefaultBehavior
      , Toolbar.flexibleSpaceMaximized
      ]
      [ Toolbar.row
        [ css "height" "224px"
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        ]
      , Toolbar.row
        [
        ]
        [ Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]
    , body
    ]


example5 : Html m
example5 =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.view
      [ Toolbar.fixed
      , Toolbar.waterfall
      , Toolbar.flexible
      , Toolbar.flexibleDefaultBehavior
      , Toolbar.flexibleSpaceMaximized
      ]
      [ Toolbar.row
        [ css "height" "224px"
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        ]
      , Toolbar.row
        [
        ]
        [ Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]
    , body
    ]


example6 : Html m
example6 =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.view
      [ Toolbar.fixed
      , Toolbar.waterfall
      , Toolbar.flexible
      , Toolbar.flexibleDefaultBehavior
      , Toolbar.flexibleSpaceMaximized
      ]
      [ Toolbar.row
        [ css "height" "224px"
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        ]
      , Toolbar.row
        [
        ]
        [ Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]
    , body
    ]


body : Html msg
body =
    Html.div []
    ( styled Html.p
      [ cs "demo-paragraph"
      ]
      [ text """Pellentesque habitant morbi tristique senectus et netus et
malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae,
ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas
semper. Aenean ultricies mi vitae est. Pellentesque habitant morbi tristique
senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam,
feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet
quam egestas semper. Aenean ultricies mi vitae est."""
      ]
      |> List.repeat 3
    )
