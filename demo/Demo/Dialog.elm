module Demo.Dialog exposing (Model,defaultModel,Msg(Mdl),update,view)

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


-- MODEL


type alias Model =
    { mdl : Material.Model
    , rtl : Bool
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , rtl = False
    }



-- ACTION/UPDATE


type Msg m
    = Mdl (Material.Msg m)
    | ToggleRtl
    | Accept
    | Cancel


type alias Ports m =
    { showDialog : String -> Cmd m
    , closeDialog : String -> Cmd m
    }


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (lift << Mdl) msg_ model

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



-- VIEW


heroDialog : (Msg m -> m) -> List Int -> Model -> Html m
heroDialog lift index model =
    Dialog.render (lift << Mdl) index model.mdl
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
          Button.render (lift << Mdl) (index ++ [0]) model.mdl
          [ Button.ripple
          , Dialog.cancel
          ]
          [ text "Cancel"
          ]
        ,
          Button.render (lift << Mdl) (index ++ [1]) model.mdl
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
    let
      id =
          "dialog"
    in
    Dialog.render (lift << Mdl) index model.mdl
    [ Options.attribute (Html.id id)
    ]
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
          Button.render (lift << Mdl) (index ++ [0]) model.mdl
          [ Button.ripple
          , Dialog.cancel
          , Options.on "click" (Json.succeed (lift Cancel))
          ]
          [ text "Decline"
          ]
        ,
          Button.render (lift << Mdl) (index ++ [1]) model.mdl
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
    let
        id =
            "scrollable-dialog"
    in
    Dialog.render (lift << Mdl) index model.mdl
    [ Options.attribute (Html.id id)
    ]
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
          Button.render (lift << Mdl) (index ++ [0]) model.mdl
          [ Button.ripple
          , Dialog.cancel
          , Options.on "click" (Json.succeed (lift Cancel))
          ]
          [ text "Decline"
          ]
        ,
          Button.render (lift << Mdl) (index ++ [1]) model.mdl
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
      Button.render (lift << Mdl) [3] model.mdl
      [ Button.raised
      , Button.ripple
      , Dialog.openOn (lift << Mdl) [1] "click"
      ]
      [ text "Show dialog"
      ]
    ,
      text " "
    ,
      Button.render (lift << Mdl) [4] model.mdl
      [ Button.raised
      , Button.ripple
      , Dialog.openOn (lift << Mdl) [2] "click"
      ]
      [ text "Show scrolling dialog"
      ]
    ,
      text " "
    ,
      styled Html.div
      [ cs "mdc-form-field"
      ]
      [ Checkbox.render (lift << Mdl) [5] model.mdl
        [ Checkbox.checked |> when model.rtl
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
