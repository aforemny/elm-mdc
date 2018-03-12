module Demo.Fabs exposing (Model, defaultModel, Msg(Mdc), update, view)

import Demo.Page as Page exposing (Page)
import Html.Attributes as Html
import Html.Events as Html
import Html exposing (Html, text)
import Material
import Material.Fab as Fab
import Material.Msg
import Material.Options as Options exposing (when, styled, cs, css)


type alias Model =
    { mdc : Material.Model
    , exited : Bool
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    , exited = False
    }


type Msg m
    = Mdc (Material.Msg.Msg m)
    | ToggleExited


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleExited ->
            ( { model | exited = not model.exited }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        fab idx options =
            Fab.view (lift << Mdc) [idx] model.mdc
                ( Fab.ripple
                :: css "margin" "16px"
                :: options
                )
                "favorite_border"

        legend options =
            styled Html.div
            ( css "padding" "64px 16px 24px"
            :: options
            )
    in
    page.body "Floating Action Button"
    [
      Page.hero [] [ fab 0 [] ]
    ,
      Html.section []
      [ Html.div []
        [
          legend [] [ text "FABs" ]
        , fab 1 []
        , fab 2 [ Fab.mini ]
        ]
      ]
    ,
      let
          fabMotionContainer options =
              styled Html.div
              ( cs "fab-motion-container"
              :: css "border" "1px solid #ccc"
              :: css "margin" "1rem"
              :: css "padding" "0 1rem"
              :: css "overflow" "hidden"
              :: css "position" "relative"
              :: css "height" "10rem"
              :: css "width" "20rem"
              :: options
              )

          fabMotionContainerView options =
              styled Html.div
              ( cs "fab-motion-container__view"
              :: css "background-color" "#fff"
              :: css "box-sizing" "border-box"
              :: css "position" "absolute"
              :: css "transition" "transform 375ms cubic-bezier(0.0, 0.0, 0.2, 1)"
              :: css "height" "100%"
              :: css "width" "100%"
              :: css "will-change" "transform"
              :: options
              )
      in
      Html.section []
      [ Html.div []
        [ legend [] [ text "Example of Enter and Exit Motions" ]
        , fabMotionContainer []
          [ fabMotionContainerView []
            [ Html.p [] [ text "View one (with FAB)" ]
            ]
          , fabMotionContainerView
            [ when (not model.exited) << Options.many <|
              [ css "transition-timing-function" "cubic-bezier(.4, 0, 1, 1)"
              , css "transform" "translateY(100%)"
              ]
            ]
            [ Html.p [] [ text "View two (without FAB)" ]
            , Html.p []
              [ Html.button
                [ Html.type_ "button"
                , Html.disabled (not model.exited)
                , Html.onClick (lift ToggleExited)
                ]
                [ text "Go back"
                ]
              ]
            ]
          , Fab.view (lift << Mdc) [3] model.mdc
                [ Fab.exited |> when model.exited
                , Options.onClick (lift ToggleExited)
                , css "position" "absolute"
                , css "right" "1rem"
                , css "bottom" "1rem"
                , css "z-index" "1"
                ]
                "add"
          ]
        ]
      ]
    ]
