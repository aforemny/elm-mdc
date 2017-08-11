module Demo.Menus exposing (Model, defaultModel, Msg(Mdl), view, update, subscriptions)

import Html.Attributes as Html exposing (href)
import Html exposing (Html, text, p, a)
import Material
import Material.Button as Button
import Material.List as Lists
import Material.Menu as Menu
import Material.Options as Options exposing (cs, css, div, nop, when)
import Set exposing (Set)
import Demo.Page exposing (Page)


type alias Model =
    { mdl : Material.Model
    , selected : Maybe ( Int, Int )
    , checked : Set Int
    , icon : Maybe String
    , ripple : Bool
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , selected = Nothing
    , checked = Set.fromList [ 0, 2 ]
    , icon = Nothing
    , ripple = True
    }


type Msg m
    = Mdl (Material.Msg m)
    | Select Int


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model

        Select index ->
            model ! []


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    page.body "Menus"
    [ div
      [ css "position" "relative"
      ]
      [ div
        [ cs "mdc-menu-anchor"
        , css "position" "absolute"
        ]
        [ Button.render (Mdl >> lift) [0] model.mdl
          [ Button.raised
          , Button.primary
          , Menu.attach (Mdl >> lift) [1]
          ]
          [ Html.text "Reveal"
          ]

        , Menu.render (Mdl >> lift) [1] model.mdl
          [ -- Menu.open
          ]
          ( Menu.ul Lists.ul []
            [ Menu.li Lists.li
              [ Options.onClick (lift (Select 0))
              , Options.attribute (Html.tabindex 0)
              ]
              [ Html.text "Back"
              ]
            , Menu.li Lists.li
              [ Options.onClick (lift (Select 1))
              , Options.attribute (Html.tabindex 0)
              ]
              [ Html.text "Forward"
              ]
            , Menu.li Lists.li
              [ Options.onClick (lift (Select 2))
              , Options.attribute (Html.tabindex 0)
              ]
              [ Html.text "Reload"
              ]
            , Menu.li Lists.divider [] []
            , Menu.li Lists.li
              [ Options.onClick (lift (Select 3))
              , Options.attribute (Html.tabindex 0)
              ]
              [ Html.text "Save As..."
              ]
            ]
          )
        ]
      ]
    ]


subscriptions : (Msg m -> m) -> Model -> Sub m
subscriptions lift model =
    Menu.subs (Mdl >> lift) model.mdl
