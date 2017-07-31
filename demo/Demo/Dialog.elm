module Demo.Dialog exposing (model, update, view, Model, Msg, element)

import Html exposing (..)
import Material
import Material.Button as Button
import Material.Dialog as Dialog


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
  div []
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
