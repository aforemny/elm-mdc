module Demo.Dialog exposing (Model,defaultModel,Msg(Mdc),update,view)

import Demo.Page as Page exposing (Page)
import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Checkbox as Checkbox
import Material.Dialog as Dialog
import Material.List as Lists
import Material.Options as Options exposing (styled, cs, css, when)


type alias Model =
    { mdc : Material.Model
    , rtl : Bool
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    , rtl = False
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleRtl
    | Accept
    | Cancel


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )

        Accept ->
          let
            _ =
              Debug.log "click" "accept"
          in
          ( model, Cmd.none )

        Cancel ->
          let
            _ =
              Debug.log "click" "cancel"
          in
          ( model, Cmd.none )


heroDialog : (Msg m -> m) -> List Int -> Model -> Html m
heroDialog lift index model =
    Dialog.view (lift << Mdc) index model.mdc
    [ Dialog.open
    , css "position" "relative"
    , css "width" "320px"
    , css "z-index" "auto"
    ]
    [ Dialog.surface
      [ css "display" "inline-flex"
      , css "min-width" "640px"
      , css "max-width" "865px"
      , css "width" "calc(100% - 30px)"
      ]
      [
        Dialog.header []
        [ styled Html.h2
          [ Dialog.title
          ]
          [ text "Are you happy?"
          ]
        ]
      ,
        Dialog.body []
        [ text "Please check the left and right side of this element for fun."
        ]
      ,
        Dialog.footer []
        [
          Button.view (lift << Mdc) (index ++ [0]) model.mdc
          [ Button.ripple
          , Dialog.cancel
          ]
          [ text "Cancel"
          ]
        ,
          Button.view (lift << Mdc) (index ++ [1]) model.mdc
          [ Button.ripple
          , Dialog.accept
          ]
          [ text "Continue"
          ]
        ]
      ]
    ]


dialog : (Msg m -> m) -> List Int -> Model -> Html m
dialog lift index model =
    Dialog.view (lift << Mdc) index model.mdc []
    [ Dialog.surface []
      [
        Dialog.header []
        [ styled Html.h2
          [ Dialog.title
          ]
          [ text "Use Google's location service?"
          ]
        ]
      ,
        Dialog.body []
        [ text
            """
Let Google help apps determine location. This means sending anonymous location
data to Google, even when no apps are running.
            """
        ]
      ,
        Dialog.footer []
        [
          Button.view (lift << Mdc) (index ++ [0]) model.mdc
          [ Button.ripple
          , Dialog.cancel
          , Options.on "click" (Json.succeed (lift Cancel))
          ]
          [ text "Decline"
          ]
        ,
          Button.view (lift << Mdc) (index ++ [1]) model.mdc
          [ Button.ripple
          , Dialog.accept
          , Options.on "click" (Json.succeed (lift Accept))
          ]
          [ text "Continue"
          ]
        ]
      ]
    ,
      Dialog.backdrop [] []
    ]


scrollableDialog : (Msg m -> m) -> List Int -> Model -> Html m
scrollableDialog lift index model =
    Dialog.view (lift << Mdc) index model.mdc []
    [ Dialog.surface []
      [
        Dialog.header []
        [ styled Html.h2
          [ Dialog.title
          ]
          [ text "Choose a Ringtone"
          ]
        ]
      ,
        Dialog.body
        [ Dialog.scrollable
        ]
        [
          Lists.ul []
          ( [ "None"
            , "Callisto"
            , "Ganymede"
            , "Luna"
            , "Marimba"
            , "Schwifty"
            , "Callisto"
            , "Ganymede"
            , "Luna"
            , "Marimba"
            , "Schwifty"
            ]
            |> List.map (\ label ->
                 Lists.li []
                 [ text label
                 ]
               )
          )
        ]
      ,
        Dialog.footer []
        [
          Button.view (lift << Mdc) (index ++ [0]) model.mdc
          [ Button.ripple
          , Dialog.cancel
          , Options.on "click" (Json.succeed (lift Cancel))
          ]
          [ text "Decline"
          ]
        ,
          Button.view (lift << Mdc) (index ++ [1]) model.mdc
          [ Button.ripple
          , Dialog.accept
          , Options.on "click" (Json.succeed (lift Accept))
          ]
          [ text "Continue"
          ]
        ]
      ]
    ,
      Dialog.backdrop [] []
    ]


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
  page.body "Dialog"
  [
    Page.hero
    [ css "justify-content" "center"
    , Options.attribute (Html.attribute "dir" "rtl") |> when model.rtl
    ]
    [
      heroDialog lift [0] model
    ]
  ,
    styled Html.div
    [ css "padding" "24px"
    , css "marign" "0"
    , css "box-sizing" "border-box"
    , Options.attribute (Html.attribute "dir" "rtl") |> when model.rtl
    ]
    [
      dialog lift [1] model
    ,
      scrollableDialog lift [2] model
    ]
  ,
    styled Html.div
    [ css "padding" "24px"
    , css "margin" "24px"
    ]
    [
      Button.view (lift << Mdc) [3] model.mdc
      [ Button.raised
      , Button.ripple
      , Dialog.openOn (lift << Mdc) [1] "click"
      ]
      [ text "Show dialog"
      ]
    ,
      text " "
    ,
      Button.view (lift << Mdc) [4] model.mdc
      [ Button.raised
      , Button.ripple
      , Dialog.openOn (lift << Mdc) [2] "click"
      ]
      [ text "Show scrolling dialog"
      ]
    ,
      text " "
    ,
      styled Html.div
      [ cs "mdc-form-field"
      ]
      [ Checkbox.view (lift << Mdc) [5] model.mdc
        [ Checkbox.checked model.rtl
        , Options.on "click" (Json.succeed (lift ToggleRtl))
        ]
        []
      ,
        Html.label []
        [ text "Toggle RTL"
        ]
      ]
    ]
  ]
