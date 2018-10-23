module Demo.Dialog exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.Button as Button
import Material.Checkbox as Checkbox
import Material.Dialog as Dialog
import Material.FormField as FormField
import Material.List as Lists
import Material.Options as Options exposing (cs, css, styled, when)


type alias Model m =
    { mdc : Material.Model m
    , rtl : Bool
    , showDialog : Bool
    , showScrollingDialog : Bool
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , rtl = False
    , showDialog = False
    , showScrollingDialog = False
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleRtl
    | Accept
    | Cancel
    | ShowDialog
    | ShowScrollingDialog


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )

        Accept ->
            ( { model | showDialog = False, showScrollingDialog = False }, Cmd.none )

        Cancel ->
            ( { model | showDialog = False, showScrollingDialog = False }, Cmd.none )

        ShowDialog ->
            ( { model | showDialog = True }, Cmd.none )

        ShowScrollingDialog ->
            ( { model | showScrollingDialog = True }, Cmd.none )


heroDialog : (Msg m -> m) -> Material.Index -> Model m -> Html m
heroDialog lift index model =
    Dialog.view (lift << Mdc)
        index
        model.mdc
        [ cs "mdc-dialog--open"
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
            [ Dialog.header []
                [ styled Html.h2
                    [ Dialog.title
                    ]
                    [ text "Are you happy?"
                    ]
                ]
            , Dialog.body []
                [ text "Please check the left and right side of this element for fun."
                ]
            , Dialog.footer []
                [ Button.view (lift << Mdc)
                    (index ++ "-button-cancel")
                    model.mdc
                    [ Button.ripple
                    , Dialog.cancel
                    ]
                    [ text "Cancel"
                    ]
                , Button.view (lift << Mdc)
                    (index ++ "button-accept")
                    model.mdc
                    [ Button.ripple
                    , Dialog.accept
                    ]
                    [ text "Continue"
                    ]
                ]
            ]
        ]


dialog : (Msg m -> m) -> Material.Index -> Model m -> Html m
dialog lift index model =
    Dialog.view (lift << Mdc)
        index
        model.mdc
        [ Dialog.open |> when model.showDialog
        , Dialog.onClose (lift Cancel)
        ]
        [ Dialog.surface []
            [ Dialog.header []
                [ styled Html.h2
                    [ Dialog.title
                    ]
                    [ text "Use Google's location service?"
                    ]
                ]
            , Dialog.body []
                [ text
                    """
Let Google help apps determine location. This means sending anonymous location
data to Google, even when no apps are running.
            """
                ]
            , Dialog.footer []
                [ Button.view (lift << Mdc)
                    (index ++ "-button-cancel")
                    model.mdc
                    [ Button.ripple
                    , Dialog.cancel
                    , Options.onClick (lift Cancel)
                    ]
                    [ text "Decline"
                    ]
                , Button.view (lift << Mdc)
                    (index ++ "-button-accept")
                    model.mdc
                    [ Button.ripple
                    , Dialog.accept
                    , Options.onClick (lift Accept)
                    ]
                    [ text "Continue"
                    ]
                ]
            ]
        , Dialog.backdrop [] []
        ]


scrollableDialog : (Msg m -> m) -> Material.Index -> Model m -> Html m
scrollableDialog lift index model =
    Dialog.view (lift << Mdc)
        index
        model.mdc
        [ Dialog.open |> when model.showScrollingDialog
        , Dialog.onClose (lift Cancel)
        ]
        [ Dialog.surface []
            [ Dialog.header []
                [ styled Html.h2
                    [ Dialog.title
                    ]
                    [ text "Choose a Ringtone"
                    ]
                ]
            , Dialog.body
                [ Dialog.scrollable
                ]
                [ Lists.ul []
                    ([ "None"
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
                        |> List.map
                            (\label ->
                                Lists.li []
                                    [ text label
                                    ]
                            )
                    )
                ]
            , Dialog.footer []
                [ Button.view (lift << Mdc)
                    (index ++ "-button-cancel")
                    model.mdc
                    [ Button.ripple
                    , Dialog.cancel
                    , Options.onClick (lift Cancel)
                    ]
                    [ text "Decline"
                    ]
                , Button.view (lift << Mdc)
                    (index ++ "-button-accept")
                    model.mdc
                    [ Button.ripple
                    , Dialog.accept
                    , Options.onClick (lift Accept)
                    ]
                    [ text "Continue"
                    ]
                ]
            ]
        , Dialog.backdrop [] []
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body "Dialog"
        [ Page.hero
            [ css "justify-content" "center"
            , Options.attribute (Html.attribute "dir" "rtl") |> when model.rtl
            ]
            [ heroDialog lift "dialog-hero-dialog" model
            ]
        , styled Html.div
            [ css "padding" "24px"
            , css "marign" "0"
            , css "box-sizing" "border-box"
            , Options.attribute (Html.attribute "dir" "rtl") |> when model.rtl
            ]
            [ dialog lift "dialog-dialog" model
            , scrollableDialog lift "dialog-scrollable-dialog" model
            ]
        , styled Html.div
            [ css "padding" "24px"
            , css "margin" "24px"
            ]
            [ Button.view (lift << Mdc)
                "dialog-show-dialog"
                model.mdc
                [ Button.raised
                , Button.ripple
                , Options.onClick (lift ShowDialog)
                ]
                [ text "Show dialog"
                ]
            , text " "
            , Button.view (lift << Mdc)
                "dialog-show-scrollable-dialog"
                model.mdc
                [ Button.raised
                , Button.ripple
                , Options.onClick (lift ShowScrollingDialog)
                ]
                [ text "Show scrolling dialog"
                ]
            , text " "
            , FormField.view []
                [ Checkbox.view (lift << Mdc)
                    "dialog-toggle-rtl"
                    model.mdc
                    [ Checkbox.checked model.rtl
                    , Options.onClick (lift ToggleRtl)
                    ]
                    []
                , Html.label []
                    [ text "Toggle RTL"
                    ]
                ]
            ]
        ]
