module Demo.Toolbar exposing
    (
      Model
    , model
    , Msg
    , update
    , view
    )


import Html.Attributes as Html
import Html exposing (Html, text)
import Material
import Material.Options as Options exposing (styled, cs, css)
import Material.Toolbar as Toolbar
import Material.Typography as Typography


-- MODEL


type alias Model =
    { mdl : Material.Model
    }


model : Model
model =
    { mdl = Material.model
    }


type Msg
    = Mdl (Material.Msg Msg)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model


-- VIEW


view : Model -> Html Msg
view model =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ example model "Normal Toolbar" example0
    , example model "Fixed Toolbar" example1
    , example model "Waterfall Toolbar" example2
    , example model "Default Flexible Toolbar" example3
    , example model "Waterfall Flexible Toolbar" example4
    , example model "Waterfall Toolbar Fix Last Row" example5
    , example model "Waterfall Flexible Toolbar with Custom Style" example6
    ]


example : Model -> String -> (Model -> Html msg) -> Html msg
example model title view =
    styled Html.div
    [
    ]
    [ Html.h2 [] [ text title ]
    , view model
    ]


example0 : Model -> Html Msg
example0 model =
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


example1 : Model -> Html Msg
example1 model =
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


example2 : Model -> Html Msg
example2 model =
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


example3 : Model -> Html Msg
example3 model =
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


example4 : Model -> Html Msg
example4 model =
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


example5 : Model -> Html Msg
example5 model =
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


example6 : Model -> Html Msg
example6 model =
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
