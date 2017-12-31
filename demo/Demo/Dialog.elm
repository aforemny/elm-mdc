module Demo.Dialog exposing (Model,defaultModel,Msg(Mdl),update,view)

import Html exposing (..)
import Material
import Material.Button as Button
import Material.Dialog as Dialog
import Demo.Page exposing (Page)


-- MODEL


type alias Model =
    { scrolling : Bool
    , mdl : Material.Model
    }


defaultModel : Model
defaultModel =
    { scrolling = False
    , mdl = Material.defaultModel
    }



-- ACTION/UPDATE


type Msg m
    = Mdl (Material.Msg m)


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model



-- VIEW


element : (Msg m -> m) -> Model -> Html m
element lift model =
    Dialog.view []
    [ Dialog.header []
      [ Dialog.title [] [ text "Use Google's location service?" ]
      ]
    , Dialog.body []
        [ text "Let Google help apps determine location. This means sending anonymous location data to Google, even when no apps are running."
        ]
    , Dialog.footer []
        [ Dialog.cancelButton
          (Button.render (Mdl >> lift) [0] model.mdl)
          [ Dialog.closeOn "click"
          ]
          [ text "Decline" ]
        , Dialog.acceptButton
          (Button.render (Mdl >> lift) [1] model.mdl)
          [ Dialog.closeOn "click"
          ]
          [ text "Accept" ]
        ]
    ]


element1 : (Msg m -> m) -> Model -> Html m
element1 lift model =
    Dialog.view []
    [ -- TODO: scrolling demo
    ]


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
  page.body "Dialog"
  [ element lift model
  , Button.render (Mdl >> lift) [0] model.mdl
    [ Dialog.openOn "click"
    ]
    [ text "Show dialog"
    ]
  ]
