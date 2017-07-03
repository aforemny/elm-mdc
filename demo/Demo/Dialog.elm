module Demo.Dialog exposing (model, update, view, Model, Msg, element)

import Demo.Code as Code
import Demo.Page as Page
import Html.Attributes exposing (..)
import Html exposing (..)
import Material
import Material.Button as Button
import Material.Dialog as Dialog
import Material.Options as Options exposing (css)


-- MODEL


type alias Model =
    { scrolling : Bool
    , mdl : Material.Model
    }


model : Model
model =
    { scrolling = False
    , mdl = Material.model
    }



-- ACTION/UPDATE


type Msg
    = Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


element : Model -> Html Msg
element model =
    Dialog.view []
    [ Dialog.header []
      [ Dialog.title [] [ text "Use Google's location service?" ]
      ]
    , Dialog.body []
        [ text "Let Google help apps determine location. This means sending anonymous location data to Google, even when no apps are running."
        ]
    , Dialog.footer []
        [ Dialog.cancelButton
          (Button.render Mdl [0] model.mdl)
          [ Dialog.closeOn "click"
          ]
          [ text "Decline" ]
        , Dialog.acceptButton
          (Button.render Mdl [1] model.mdl)
          [ Dialog.closeOn "click"
          ]
          [ text "Accept" ]
        ]
    ]


element1 : Model -> Html Msg
element1 model =
    Dialog.view []
    [ -- TODO: scrolling demo
    ]


view : Model -> Html Msg
view model =
    Page.body1_ "Dialog" srcUrl intro references []
    [ Button.render Mdl [0] model.mdl
      [ Dialog.openOn "click"
      ]
      [ text "Show dialog"
      ]
    , Button.render Mdl [1] model.mdl
      [ Dialog.openOn "click"
      ]
      [ text "Show scrolling dialog"
      ]
    ]


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
