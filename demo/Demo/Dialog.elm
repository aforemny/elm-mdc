module Demo.Dialog exposing (model, update, view, Model, Msg, element)

import Html.Attributes exposing (..)
import Html exposing (..)
import Material
import Material.Button as Button
import Material.Dialog as Dialog
import Material.Options exposing (css)
import Demo.Page as Page
import Demo.Code as Code


-- MODEL


type alias Model =
    { mdl : Material.Model
    }


model : Model
model =
    { mdl = Material.model
    }



-- ACTION/UPDATE


type Msg
    = Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Mdl action_ ->
            Material.update Mdl action_ model



-- VIEW


element : Model -> Html Msg
element model =
    Dialog.view
        []
        [ Dialog.title [] [ text "Greetings" ]
        , Dialog.content []
            [ p [] [ text "A strange game—the only winning move is not to play." ]
            , p [] [ text "How about a nice game of chess?" ]
            ]
        , Dialog.actions []
            [ Button.render Mdl
                [ 0 ]
                model.mdl
                [ Dialog.closeOn "click" ]
                [ text "Chess" ]
            , Button.render Mdl
                [ 1 ]
                model.mdl
                [ Button.disabled ]
                [ text "GTNW" ]
            ]
        ]


view : Model -> Html Msg
view model =
    [ div
      [ style
        [ ("font-weight", "bold")
        , ("margin-bottom", "30px")
        ]
      ]
      [ text "Dialogs are experimental. Be sure to check out the "
      , a
        [ href "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Dialog"
        , style [("font-weight", "inherit")]
        ]
        [ text "Package documentation"
        ]
      , text " for the required polyfill."
      ]

    , Button.render Mdl
        [ 1 ]
        model.mdl
        [ Dialog.openOn "click" ]
        [ text "Open dialog" ]
      {-
         , Button.render Mdl [2] model.mdl
             [ Dialog.closeOn "click" ]
             [ text "Close dialog" ]
      -}

    , Code.code
      [ css "margin" "32px 0"
      ]
      """

-- Define the dialog

dialog : Model -> Html Msg
dialog model =
    Dialog.view
        []
        [ Dialog.title [] [ text "Greetings" ]
        , Dialog.content []
            [ p [] [ text "A strange game—the only winning move is not to play." ]
            , p [] [ text "How about a nice game of chess?" ]
            ]
        , Dialog.actions []
            [ Button.render Mdl
                [ 0 ]
                model.mdl
                [ Dialog.closeOn "click" ]
                [ text "Chess" ]
            , Button.render Mdl
                [ 1 ]
                model.mdl
                [ Button.disabled ]
                [ text "GTNW" ]
            ]
        ]

-- 2. Add it to your view function's outmost div

view =
    div
    [ …
    ]
    [ …
    , dialog model
    ]

-- 3. Attach it to a button

Button.render Mdl
  [ 1 ]
  model.mdl
  [ Dialog.openOn "click" ]
  [ text "Open dialog" ]
      """
    ]
    |> Page.body2 "Dialog" srcUrl intro references


intro : Html m
intro =
    Page.fromMDL "https://getmdl.io/components/#dialog-section" """
> The Material Design Lite (MDL) dialog component allows for verification of user
> actions, simple data input, and alerts to provide extra information to users.
>
> To use the dialog component, you must be using a browser that supports the
> dialog element. Only Chrome and Opera have native support at the time of
> writing. For other browsers you will need to include the dialog polyfill
> or create your own.
"""


srcUrl : String
srcUrl =
    "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Dialog.elm"


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Dialog"
    , Page.mds "https://material.google.com/components/dialogs.html"
    , Page.mdl "https://getmdl.io/components/#dialog-section"
    ]
