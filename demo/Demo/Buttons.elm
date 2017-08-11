module Demo.Buttons exposing (Model,defaultModel,Msg(Mdl),update,view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Platform.Cmd exposing (Cmd)
import String
import Material.Button as Button exposing (..)
import Material.Options as Options exposing (Style, cs, css, when)
import Material


type alias Model =
    { mdl : Material.Model
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    }


type Msg = Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> Html Msg
view model =
    div
    [
    ]
    ( [ { headline = "Buttons", link = False, disabled = False }
      , { headline = "Links with Button Style", link = True, disabled = False }
      , { headline = "Disabled", link = False, disabled = True }
      ]
      |> List.concat << List.map (\row ->
           ( List.concat
             [ [ div
                 [ class "mdc-typography--title"
                 , style
                   [ ("padding", "64px 16px 24px")
                   ]
                 ]
                 [ text row.headline
                 ]
               ]
             , [ { dense = False, compact = False }
               , { dense = True, compact = False }
               , { dense = False, compact = True }
               ]
               |> List.map (\button ->
                      [ { dense = button.dense
                        , compact = button.compact
                        , raised = False
                        }
                      , { dense = button.dense
                        , compact = button.compact
                        , raised = True
                        }
                      ]
                  )
               |> List.concat
               |> List.map (\button ->
                    Button.render Mdl [9,0,0,1] model.mdl
                    [ css "margin" "16px"
                    , Button.link "" |> when row.link
                    , Button.disabled |> when row.disabled
                    , Button.raised |> when button.raised
                    , Button.ripple
                    , Button.compact |> when button.compact
                    , Button.dense |> when button.dense
                    ]
                    [ [ if button.dense then Just "Dense" else Nothing
                      , if button.compact then Just "Compact" else Nothing
                      , if button.raised then Just "Raised" else Just "Default"
                      ]
                      |> List.filterMap identity
                      |> String.join " "
                      |> text
                    ]
                  )
             , [ { primary = False }
               , { primary = True }
               ]
               |> List.map (\button ->
                      [ { primary = button.primary
                        , raised = False
                        }
                      , { primary = button.primary
                        , raised = True
                        }
                      ]
                  )
               |> List.concat
               |> List.map (\button ->
                    Button.render Mdl [9,0,0,1] model.mdl
                    [ css "margin" "16px"
                    , Button.link "" |> when row.link
                    , Button.disabled |> when row.disabled
                    , Button.ripple
                    , if button.primary then
                          Button.primary
                        else
                          Button.accent
                    , Button.raised |> when button.raised
                    ]
                    [ [ if button.raised then "Raised" else "Default"
                      , "width"
                      , if button.primary then "Primary" else "Accent"
                      ]
                      |> String.join " "
                      |> text
                    ]
                  )
             ]
           )
         )
    )
