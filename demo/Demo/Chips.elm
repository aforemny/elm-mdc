module Demo.Chips exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)


--import Html.Events as Html

import Material.Chip as Chip
import Material.Grid as Grid
import Material.Color as Color
import Material.Options as Options exposing (css, cs)
import Material
import Material.Card as Card
import Material.Button as Button
import Demo.Page as Page
import Demo.Code as Code
import Dict exposing (Dict)


-- MODEL


type alias Model =
    { mdl : Material.Model
    , chips : Dict Int String
    , value : String
    , details : String
    }


model : Model
model =
    { mdl = Material.model
    , chips = Dict.fromList [ ( 1, "Amazing Chip 1" ) ]
    , value = ""
    , details = ""
    }



-- ACTION, UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | AddChip String
    | RemoveChip Int
    | ChipClick Int


lastIndex : Dict Int b -> Int
lastIndex dict =
    Dict.keys dict
        |> List.reverse
        |> List.head
        |> Maybe.withDefault 0


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        ChipClick index ->
            let
                details =
                    Maybe.withDefault ""
                        (Dict.get index model.chips)
            in
                ( { model | details = details }, Cmd.none )

        AddChip content ->
            let
                index =
                    1 + lastIndex model.chips

                model_ =
                    { model | chips = Dict.insert index (content ++ " " ++ toString index) model.chips }
            in
                ( model_, Cmd.none )

        RemoveChip index ->
            let
                d_ =
                    Maybe.withDefault ""
                        (Dict.get index model.chips)

                details =
                    if d_ == model.details then
                        ""
                    else
                        model.details

                model_ =
                    { model
                        | chips = Dict.remove index model.chips
                        , details = details
                    }
            in
                ( model_, Cmd.none )



-- VIEW


demoContainer : ( Html m, String ) -> Grid.Cell m
demoContainer ( html, code ) =
    Grid.cell
        [ Grid.size Grid.All 6 ]
        [ Options.div
            [ css "text-align" "center" ]
            [ html ]
        , Code.code
            [ css "margin" "32px 0" ]
            code
        ]


demoChips : List (Grid.Cell m)
demoChips =
    [ ( Chip.span []
            [ Chip.content []
                [ text "Basic Chip" ]
            ]
      , """
      Chip.span []
        [ Chip.content []
            [ text "Basic Chip" ]
        ]
       """
      )
    , ( Chip.span
            [ Chip.deleteIcon "cancel" ]
            [ Chip.content []
                [ text "Deletable Chip" ]
            ]
      , """
      Chip.span
        [ Chip.deleteIcon "cancel" ]
        [ Chip.content []
            [ text "Deletable Chip" ]
        ]
       """
      )
    , ( Chip.button []
            [ Chip.content []
                [ text "Button Chip" ]
            ]
      , """
      Chip.button []
        [ Chip.content []
            [ text "Button Chip" ]
        ]
       """
      )
    , ( Chip.span []
            [ Chip.contact Html.span
                [ Color.background Color.primary
                , Color.text Color.white
                ]
                [ text "A" ]
            , Chip.content []
                [ text "Contact Chip" ]
            ]
      , """
        Chip.span []
          [ Chip.contact Html.span
              [ Color.background Color.primary
              , Color.text Color.white
              ]
              [ text "A" ]
          , Chip.content []
              [ text "Contact Chip" ]
          ]
        """
      )
    , ( Chip.span
            [ Chip.deleteLink "#chips" ]
            [ Chip.contact Html.span
                [ Color.background Color.primary
                , Color.text Color.white
                ]
                [ text "A" ]
            , Chip.text []
                "Deletable Contact Chip"
            ]
      , """
      Chip.span
        [ Chip.deleteLink "#chips"
        ]
        [ Chip.contact Html.span
            [ Color.background Color.primary
            , Color.text Color.white
            ]
            [ text "A" ]
        , Chip.content []
            [ text "Deletable Contact Chip" ]
        ]
       """
      )
    , ( Chip.span []
            [ Chip.contact Html.img
                [ Options.css "background-image" "url('assets/images/elm.png')"
                , Options.css "background-size" "cover"
                ]
                []
            , Chip.content []
                [ text "Chip with image" ]
            ]
      , """
      Chip.span []
        [ Chip.contact Html.img
            [ Options.css "background-image"
                "url('assets/images/elm.png')"
            , Options.css "background-size"
                "cover"
            ]
            []
        , Chip.content []
            [ text "Chip with image" ]
        ]
       """
      )
    ]
        |> List.map demoContainer


view : Model -> Html Msg
view model =
    let
        examples =
            [ Html.div []
                [ Html.p [] [ text "Example use:" ]
                , Grid.grid [] <|
                    (Grid.cell
                        [ Grid.size Grid.All 12 ]
                        [ Code.code [ css "margin" "24px 0" ]
                            """
                      import Material.Chip as Chip
                      """
                        ]
                        :: demoChips
                    )
                ]
            ]

        interactive =
            [ Html.h4 [] [ text "Interactive demo" ]
            , Html.p []
                [ text "Click on a chip to show its details on a card. Click on the delete icon to remove the chip" ]
            , Options.div
                [ Options.css "display" "flex"
                , Options.css "align-items" "flex-start"
                , Options.css "flex-flow" "row wrap"
                , Options.css "min-height" "200px"
                ]
                [ Options.div
                    [ Options.css "width" "200px"
                    , Options.css "flex-shrink" "0"
                    , Options.css "margin-right" "16px"
                    ]
                    (case model.details of
                        "" ->
                            []

                        _ ->
                            [ Card.view
                                [ Options.css "width" "200px"
                                , Color.background (Color.color Color.Pink Color.S500)
                                ]
                                [ Card.title []
                                    [ Card.head
                                        [ Color.text Color.white ]
                                        [ text model.details ]
                                    ]
                                , Card.text
                                    [ Color.text Color.white ]
                                    [ text "Touching a chip opens a full detailed view (either in a card or full screen) or a menu of options related to that chip." ]
                                ]
                            ]
                    )
                , Options.div
                    [ Options.css "flex-grow" "1"
                    , Options.css "width" "75%"
                    ]
                    [ Options.styled Html.div
                        [ Color.background Color.white
                        ]
                        ((Dict.toList model.chips
                            |> List.map
                                (\( index, value ) ->
                                    Chip.button
                                        [ Options.css "margin" "5px 5px"
                                        , Options.onClick (ChipClick index)
                                        , Chip.deleteClick (RemoveChip index)
                                        ]
                                        [ Chip.content []
                                            [ text value ]
                                        ]
                                )
                         )
                            ++ []
                        )
                    , Button.render Mdl
                        [ 0 ]
                        model.mdl
                        [ Button.colored
                        , Button.ripple
                        , Button.raised
                        , Options.onClick (AddChip "Amazing Chip")
                        ]
                        [ text "Add chip" ]
                    ]
                ]
            , Code.code
                [ Options.css "margin-top" "20px" ]
                """
            Chip.button
              [ Options.css "margin" "5px 5px"
              , Options.onClick (ChipClick index)
              , Chip.deleteClick (RemoveChip index)
              ]
              [ Chip.content []
                  [ text ("Amazing Chip " ++ toString index ) ]
              ]
           """
            ]
    in
        Page.body1_ "Chips"
            srcUrl
            intro
            references
            examples
            interactive


intro : Html m
intro =
    Page.fromMDL "https://www.getmdl.io/components/index.html#chips-section" """
> The Material Design Lite (MDL) chip component is a small, interactive element.
> Chips are commonly used for contacts, text, rules, icons, and photos.
"""


srcUrl : String
srcUrl =
    "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Chips.elm"


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Chip"
    , Page.mds "https://www.google.com/design/spec/components/chips.html"
    , Page.mdl "https://www.getmdl.io/components/index.html#chips-section"
    ]
