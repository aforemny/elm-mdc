module Demo.Loading exposing (..)

import Html exposing (Html, text)
import Material.Options as Options exposing (div, css, cs, when)
import Material.Progress as Loading
import Material.Spinner as Loading
import Material.Grid as Grid
import Material.Color as Color
import Material.Button as Button
import Material
import Material.Helpers as Helpers exposing (map2nd)
import Material.Typography as Typography
import Demo.Code as Code
import Demo.Page as Page


type alias Model =
    { mdl : Material.Model
    , running : Bool
    , progress : Float
    }


model : Model
model =
    { mdl = Material.model
    , running = False
    , progress = 14
    }


type Msg
    = Tick
    | Toggle
    | Mdl (Material.Msg Msg)



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        -- 'Simulate' a process that takes some time
        Tick ->
            let
                nextProgress =
                    model.progress + 1

                progress =
                    if nextProgress > 100 then
                        0
                    else
                        nextProgress

                finishedLoading =
                    nextProgress > 100
            in
                ( { model
                    | progress = progress
                    , running = model.running && not finishedLoading
                  }
                , if model.running && not finishedLoading then
                    Helpers.delay 100 Tick
                  else
                    Cmd.none
                )

        Toggle ->
            ( { model | running = not model.running }
            , if model.running == False then
                Helpers.delay 200 Tick
              else
                Cmd.none
            )

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


demoBars : Model -> List (Grid.Cell a)
demoBars model =
    let
        k =
            toString model.progress

        buffered =
            min 100.0 (3.0 * model.progress)
    in
        [ ( Loading.progress model.progress
          , "Loading.progress " ++ k
          )
        , ( Loading.buffered model.progress buffered
          , "Loading.buffered " ++ k ++ " " ++ toString buffered
          )
        , ( Loading.indeterminate
          , "Loading.indeterminate"
          )
        , ( Loading.spinner [ Loading.active model.running ]
          , """
        Loading.spinner
          [ Loading.active """ ++ toString model.running ++ " ]"
          )
        , ( Loading.spinner [ Loading.active model.running, Loading.singleColor True ]
          , """
        Loading.spinner
          [ Loading.active """ ++ toString model.running ++ """
          , Loading.singleColor True ]"""
          )
        ]
            |> List.map demoContainer


view : Model -> Html Msg
view model =
    [ div
        []
        [ Html.p [] [ text "Example use:" ]
        , Grid.grid []
            ((Grid.cell
                [ Grid.size Grid.All 12 ]
                [ Code.code [ css "margin" "24px 0" ] """
                               import Material.Spinner as Loading
                               import Material.Progress as Loading
                               """
                ]
                :: demoBars model
             )
                ++ [ Grid.cell
                        [ Grid.size Grid.All 4
                        , css "text-align" "right"
                        , Color.text Color.primary
                        , Grid.align Grid.Bottom
                        ]
                        [ Options.span
                            [ Typography.display4, Typography.contrast 1.0 ]
                            [ text <| toString model.progress ]
                        ]
                   , Grid.cell
                        [ Grid.size Grid.All 4 ]
                        [ div [ Options.css "padding-top" "30px" ] []
                        , div []
                            [ Button.render Mdl
                                [ 4 ]
                                model.mdl
                                [ Button.raised
                                , Button.colored
                                , Button.ripple
                                , Button.disabled |> when model.running
                                , Options.onClick Toggle
                                ]
                                [ text "Resume" ]
                            , Options.div [ css "width" "2em", css "display" "inline-block" ] []
                            , Button.render Mdl
                                [ 5 ]
                                model.mdl
                                [ Button.raised
                                , Button.colored
                                , Button.ripple
                                , Button.disabled |> when (not model.running)
                                , Options.onClick Toggle
                                ]
                                [ text "Pause" ]
                            ]
                        ]
                   ]
            )
        ]
    ]
        |> Page.body2 "Loading" srcUrl intro references


demoContainer : ( Html m, String ) -> Grid.Cell m
demoContainer ( html, code ) =
    Grid.cell
        [ Grid.size Grid.All 4 ]
        [ div [ css "text-align" "center" ] [ html ]
        , Code.code [ css "margin" "32px 0" ] code
        ]


intro : Html m
intro =
    Page.fromMDL "https://www.getmdl.io/components/index.html#loading-section" """
> The Material Design Lite (MDL) progress component is a visual indicator of
> background activity in a web page or application. A progress indicator
> consists of a (typically) horizontal bar containing some animation that
> conveys a sense of motion. While some progress devices indicate an
> approximate or specific percentage of completion, the MDL progress component
> simply communicates the fact that an activity is ongoing and is not yet
> complete.

> Progress indicators are an established but non-standardized feature in user
> interfaces, and provide users with a visual clue to an application's status.
> Their design and use is therefore an important factor in the overall user
> experience. See the progress component's Material Design specifications page
> for details.
"""


srcUrl : String
srcUrl =
    "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Loading.elm"


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Loading"
    , Page.mds "https://material.google.com/components/progress-activity.html"
    , Page.mdl "https://getmdl.io/components/index.html#loading-section"
    ]
