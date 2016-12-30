module Demo.Dialog exposing (model, update, view, Model, Msg, element)

import Html exposing (..)
import Material.Dialog as Dialog
import Material.Button as Button
import Material
import Demo.Page as Page


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
    [ Button.render Mdl
        [ 1 ]
        model.mdl
        [ Dialog.openOn "click" ]
        [ text "Open dialog" ]
      {-
         , Button.render Mdl [2] model.mdl
             [ Dialog.closeOn "click" ]
             [ text "Close dialog" ]
      -}
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
