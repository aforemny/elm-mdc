module Demo.Menus exposing (model, Model, view, update, Msg(Mdl))

import Demo.Code as Code
import Demo.Page as Page
import Html.Attributes exposing (href)
import Html exposing (Html, text, p, a)
import Material
import Material.Button as Button
import Material.Color as Color
import Material.Dropdown.Item as Item
import Material.Elevation as Elevation
import Material.Grid as Grid
import Material.Icon as Icon
import Material.List as Lists
import Material.Menu as Menu
import Material.Options as Options exposing (cs, css, div, nop, when)
import Material.Textfield as Textfield
import Set exposing (Set)
import String


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
    | Select Int Int
    | SetIcon String
    | Flip Int
    | Nop


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Mdl action_ ->
            Material.update Mdl action_ model

        Select menu item ->
            ( { model | selected = Just ( menu, item ) }
            , Cmd.none
            )

        SetIcon s ->
            ( { model
                | icon =
                    if s == "" then
                        Nothing
                    else
                        Just s
              }
            , Cmd.none
            )

        Flip k ->
            ( { model
                | checked =
                    if Set.member k model.checked then
                        Set.remove k model.checked
                    else
                        Set.insert k model.checked
              }
            , Cmd.none
            )

        Nop ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Page.body1_ "Menus" srcUrl intro references []
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
            [ Menu.li Lists.li [] [ Html.text "Back" ]
            , Menu.li Lists.li [] [ Html.text "Forward" ]
            , Menu.li Lists.li [] [ Html.text "Reload" ]
            , Menu.li (\options nodes -> Lists.divider options) [] []
            , Menu.li Lists.li [] [ Html.text "Save As..." ]
            ]
          )
        ]
      ]
    ]


intro : Html m
intro =
    Page.fromMDL "https://www.getmdl.io/components/#menus-section" """

> The Material Design Lite (MDL) menu component is a user interface element
> that allows users to select one of a number of options. The selection
> typically results in an action initiation, a setting change, or other
> observable effect. Menu options are always presented in sets of two or more,
> and options may be programmatically enabled or disabled as required. The menu
> appears when the user is asked to choose among a series of options, and is
> usually dismissed after the choice is made.
>
> Menus are an established but non-standardized feature in user interfaces, and
> allow users to make choices that direct the activity, progress, or
> characteristics of software. Their design and use is an important factor in
> the overall user experience. See the menu component's <a href="http://www.google.com/design/spec/components/menus.html">Material Design
> specifications page</a> for details.

"""


srcUrl : String
srcUrl =
    "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Menus.elm"


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Menu"
    , Page.mds "https://www.google.com/design/spec/components/menus.html"
    , Page.mdl "https://www.getmdl.io/components/#menus-section"
    ]
