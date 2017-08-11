module Demo.Elevation exposing (Model,defaultModel,Msg(Mdl),update,view)

import Html exposing (..)
import Material
import Material.Elevation as Elevation
import Material.Options as Options exposing (cs, css, Style, when)


-- MODEL


type alias Model =
    { transition : Bool
    , elevation : Int
    , mdl : Material.Model
    }


defaultModel : Model
defaultModel =
    { transition = False
    , elevation = 1
    , mdl = Material.defaultModel
    }


type Msg
    = Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model


-- VIEW


view : Model -> Html Msg
view model =
    div []
    [ Options.div
      [ css "display" "flex"
      , css "flex-flow" "row wrap"
      ]
      ( List.map (\z ->
            Options.div
            [ Elevation.elevation z
            , css "width" "200px"
            , css "height" "100px"
            , css "margin" "0 60px 80px"
            , css "line-height" "100px"
            , css "color" "#9e9e9e"
            , css "font-size" "0.8em"
            , css "border-radius" "3px"
            ]
            [ text (toString z ++ "dp")
            ]
          )
          (List.range 0 24)
      )
    ]
