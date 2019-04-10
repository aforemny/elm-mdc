module Demo.TextFields exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Html.Attributes as Html
import Html.Events as Html
import Material
import Material.Options as Options exposing (cs, css, styled, when)
import Material.TextField as TextField
import Material.TextField.HelperText as TextField
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    }


type Msg m
    = Mdc (Material.Msg m)


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model


heroTextFieldsContainer : List (Options.Property c m) -> List (Html m) -> Html m
heroTextFieldsContainer options =
    styled Html.div
        (cs "hero-text-field-container"
            :: css "display" "flex"
            :: css "flex" "1 1 100%"
            :: css "justify-content" "space-around"
            :: css "flex-wrap" "wrap"
            :: options
        )


heroTextFieldContainer : List (Options.Property c m) -> List (Html m) -> Html m
heroTextFieldContainer options =
    styled Html.div
        (cs "text-field-container"
            :: css "min-width" "200px"
            :: css "padding" "20px"
            :: options
        )


heroTextFields : (Msg m -> m) -> Model m -> Html m
heroTextFields lift model =
    heroTextFieldContainer []
        [ textFieldContainer []
            [ TextField.view (lift << Mdc)
                "text-fields-hero-text-field-1"
                model.mdc
                [ TextField.label "Standard" ]
                []
            , TextField.view (lift << Mdc)
                "text-fields-hero-text-field-2"
                model.mdc
                [ TextField.label "Standard", TextField.outlined ]
                []
            ]
        ]


textFieldRow : List (Options.Property c m) -> List (Html m) -> Html m
textFieldRow options =
    styled Html.div
        (cs "text-field-row"
            :: css "display" "flex"
            :: css "align-items" "flex-start"
            :: css "justify-content" "space-between"
            :: css "flex-wrap" "wrap"
            :: options
        )


textFieldContainer : List (Options.Property c m) -> List (Html m) -> Html m
textFieldContainer options =
    styled Html.div
        (cs "text-field-container"
            :: css "min-width" "200px"
            :: options
        )


helperText : Html m
helperText =
    TextField.helperText
        [ TextField.persistent ]
        [ text "Helper Text"
        ]


filledTextFields : (Msg m -> m) -> Model m -> Html m
filledTextFields lift model =
    let
        textField index options =
            [ TextField.view (lift << Mdc)
                index
                model.mdc
                (TextField.label "Standard" :: options)
                []
            , helperText
            ]
    in
    textFieldRow []
        [ textFieldContainer []
            (textField "text-fields-filled-1" [])
        , textFieldContainer []
            (textField "text-fields-filled-2" [ TextField.leadingIcon "event" ])
        , textFieldContainer []
            (textField "text-fields-filled-3" [ TextField.trailingIcon "trash" ])
        ]


outlinedTextFields : (Msg m -> m) -> Model m -> Html m
outlinedTextFields lift model =
    let
        textField index options =
            [ TextField.view (lift << Mdc)
                index
                model.mdc
                (TextField.label "Standard" :: TextField.outlined :: options)
                []
            , helperText
            ]
    in
    textFieldRow []
        [ textFieldContainer []
            (textField "text-fields-outlined-1" [])
        , textFieldContainer []
            (textField "text-fields-outlined-2" [ TextField.leadingIcon "event" ])
        , textFieldContainer []
            (textField "text-fields-outlined-3" [ TextField.trailingIcon "trash" ])
        ]


shapedFilledTextFields : (Msg m -> m) -> Model m -> Html m
shapedFilledTextFields lift model =
    let
        textField index options =
            [ TextField.view (lift << Mdc)
                index
                model.mdc
                (TextField.label "Standard"
                    :: css "border-radius" "16px 16px 0 0"
                    :: options
                )
                []
            , helperText
            ]
    in
    textFieldRow []
        [ textFieldContainer []
            (textField "text-fields-shaped-filled-1" [])
        , textFieldContainer []
            (textField "text-fields-shaped-filled-2" [ TextField.leadingIcon "event" ])
        , textFieldContainer []
            (textField "text-fields-shaped-filled-3" [ TextField.trailingIcon "trash" ])
        ]


shapedOutlinedTextFields : (Msg m -> m) -> Model m -> Html m
shapedOutlinedTextFields lift model =
    let
        textField index options =
            [ TextField.view (lift << Mdc)
                index
                model.mdc
                (TextField.label "Standard" :: TextField.outlined :: options)
                []
            , helperText
            ]
    in
    textFieldRow []
        [ textFieldContainer []
            (textField "text-fields-shaped-outlined-1" [ cs "demo-text-field-outlined-shaped" ])
        , textFieldContainer []
            (textField "text-fields-shaped-outlined-2" [ cs "demo-text-field-outlined-shaped", TextField.leadingIcon "event" ])
        , textFieldContainer []
            (textField "text-fields-shaped-outlined-3" [ cs "demo-text-field-outlined-shaped", TextField.trailingIcon "trash" ])
        ]


unlabeledTextFields : (Msg m -> m) -> Model m -> Html m
unlabeledTextFields lift model =
    let
        textField index options =
            [ TextField.view (lift << Mdc)
                index
                model.mdc
                options
                []
            , helperText
            ]
    in
    textFieldRow []
        [ textFieldContainer []
            (textField "text-fields-unlabeled-1" [])
        , textFieldContainer []
            (textField "text-fields-unlabeled-2" [ TextField.outlined ])
        , textFieldContainer []
            (textField "text-fields-unlabeled-3" [ TextField.outlined, cs "demo-text-field-outlined-shaped" ])
        ]


fullwidthTextField : (Msg m -> m) -> Model m -> Html m
fullwidthTextField lift model =
    textFieldContainer []
        [ TextField.view (lift << Mdc)
            "text-field-fullwidth-text-field"
            model.mdc
            [ TextField.placeholder "Standard"
            , TextField.fullwidth
            ]
            []
        , helperText
        ]


textareaTextField : (Msg m -> m) -> Model m -> Html m
textareaTextField lift model =
    textFieldContainer []
        [ TextField.view (lift << Mdc)
            "text-fields-textarea-text-field"
            model.mdc
            [ TextField.label "Standard"
            , TextField.textarea
            , TextField.outlined
            ]
            []
        , helperText
        ]


textFieldRowFullwidth : List (Options.Property c m) -> List (Html m) -> Html m
textFieldRowFullwidth options =
    styled Html.div
        (cs "text-field-row text-field-row--fullwidth"
            :: css "display" "block"
            :: options
        )


fullwidthTextareaTextField : (Msg m -> m) -> Model m -> Html m
fullwidthTextareaTextField lift model =
    textFieldRowFullwidth []
        [ textFieldContainer []
            [ TextField.view (lift << Mdc)
                "text-fields-fullwidth-textarea-text-field"
                model.mdc
                [ TextField.label "Standard"
                , TextField.textarea
                , TextField.fullwidth
                , TextField.outlined
                ]
                []
            , helperText
            ]
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body "Text Field"
        "Text fields allow users to input, edit, and select text. Text fields typically reside in forms but can appear in other places, like dialog boxes and search."
        [ Hero.view [] [ heroTextFields lift model ]
        , styled Html.h2
            [ Typography.headline6
            , css "border-bottom" "1px solid rgba(0,0,0,.87)"
            ]
            [ text "Resources"
            ]
        , ResourceLink.view
            { link = "https://material.io/go/design-text-fields"
            , title = "Material Design Guidelines"
            , icon = "images/material.svg"
            , altText = "Material Design Guidelines icon"
            }
        , ResourceLink.view
            { link = "https://material.io/components/web/catalog/input-controls/text-field/"
            , title = "Documentation"
            , icon = "images/ic_drive_document_24px.svg"
            , altText = "Documentation icon"
            }
        , ResourceLink.view
            { link = "https://github.com/material-components/material-components-web/tree/master/packages/mdc-textfield"
            , title = "Source Code (Material Components Web)"
            , icon = "images/ic_code_24px.svg"
            , altText = "Source Code"
            }
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Filled" ]
            , filledTextFields lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Shaped Filled" ]
            , shapedFilledTextFields lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Outlined" ]
            , outlinedTextFields lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Shaped Outlined" ]
            , shapedOutlinedTextFields lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Text Field without label" ]
            , unlabeledTextFields lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Textarea" ]
            , textareaTextField lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Full Width" ]
            , fullwidthTextField lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Full Width Textarea" ]
            , fullwidthTextareaTextField lift model
            ]
        ]
