module Demo.Typography exposing (Model, defaultModel, Msg(Mdl), update, view)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)


--import Html.Attributes as Html

import Material
import Material.Options as Options exposing (Style, styled, cs, css, nop)
import Material.Typography as Typography


-- MODEL


type alias Model =
    { mdl : Material.Model
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    }



-- ACTION, UPDATE


type Msg
    = Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


view : Model -> Html Msg
view model =
    div []
    [ example "Styles" nop
    , example "Styles with margin adjustments" Typography.adjustMargin
    ]


example : String -> Style m -> Html m
example title adjustMargin =
    styled Html.section
    [ cs "demo-typography--section"
    , css "margin" "24px"
    , css "padding" "24px"
    , css "border" "1px solid #ddd"
    , Typography.typography
    ]
    [ styled Html.h2
      [ Typography.display1
      ]
      [ text title
      ]

    , styled Html.h1 [ Typography.display4, adjustMargin ] [ text "Display 4" ]
    , styled Html.h1 [ Typography.display3, adjustMargin ] [ text "Display 3" ]
    , styled Html.h1 [ Typography.display2, adjustMargin ] [ text "Display 2" ]
    , styled Html.h1 [ Typography.display1, adjustMargin ] [ text "Display 1" ]
    , styled Html.h1 [ Typography.headline, adjustMargin ] [ text "Headline" ]

    , styled Html.h2 [ Typography.title, adjustMargin ]
      [ text "Title"
      , styled Html.span [ Typography.caption, adjustMargin ] [ text "Caption." ]
      ]

    , styled Html.h3 [ Typography.subheading2, adjustMargin ] [ text "Subheading 2" ]
    , styled Html.h4 [ Typography.subheading1, adjustMargin ] [ text "Subheading 1" ]

    , styled Html.p
      [ Typography.body2
      , adjustMargin
      ]
      [ text """Body 1 paragraph. Lorem ipsum dolor sit amet, consectetur
      adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore
      magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
      laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in
      reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
      pariatur."""
      ]
    , styled Html.aside
      [ Typography.body2
      , adjustMargin
      ]
      [ text "Body 2 text, calling something out."
      ]
    ]
