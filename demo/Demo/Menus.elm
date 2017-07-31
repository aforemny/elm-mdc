module Demo.Menus exposing (model, Model, view, update, Msg(Mdl))

import Html.Attributes as Html exposing (href)
import Html exposing (Html, text, p, a)
import Material
import Material.Button as Button
import Material.List as Lists
import Material.Menu as Menu
import Material.Options as Options exposing (cs, css, div, nop, when)
import Set exposing (Set)


-- MODEL


type alias Model =
    { mdl : Material.Model
    , selected : Maybe ( Int, Int )
    , checked : Set Int
    , icon : Maybe String
    , ripple : Bool
    }


model : Model
model =
    { mdl = Material.model
    , selected = Nothing
    , checked = Set.fromList [ 0, 2 ]
    , icon = Nothing
    , ripple = True
    }



-- ACTION, UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | Select Int


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Mdl action_ ->
            Material.update Mdl action_ model

        Select index ->
            let
                _ = Debug.log "select" index
            in
            model ! []


-- VIEW


view : Model -> Html Msg
view model =
    div []
    [ div
      [ css "position" "relative"
      ]
      [ div
        [ cs "mdc-menu-anchor"
        , css "position" "absolute"
        ]
        [ Button.render Mdl [0] model.mdl
          [ Button.raised
          , Button.primary
          , Menu.attach Mdl [1]
          ]
          [ Html.text "Reveal"
          ]

        , Menu.render Mdl [1] model.mdl
          [ -- Menu.open
          ]
          ( Menu.ul Lists.ul []
            [ Menu.li Lists.li
              [ Options.onClick (Select 0)
              , Options.attribute (Html.tabindex 0)
              ]
              [ Html.text "Back"
              ]
            , Menu.li Lists.li
              [ Options.onClick (Select 1)
              , Options.attribute (Html.tabindex 0)
              ]
              [ Html.text "Forward"
              ]
            , Menu.li Lists.li
              [ Options.onClick (Select 2)
              , Options.attribute (Html.tabindex 0)
              ]
              [ Html.text "Reload"
              ]
            , Menu.li (\options nodes -> Lists.divider options) [] []
            , Menu.li Lists.li
              [ Options.onClick (Select 3)
              , Options.attribute (Html.tabindex 0)
              ]
              [ Html.text "Save As..."
              ]
            ]
          )
        ]
      ]
    ]
