module Demo.TextFields exposing
    (Model
    , Msg(..)
    , defaultModel
    , update
    , view
    , subscriptions
    )

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, text, a, span)
import Html.Attributes as Html exposing (href)
import Html.Events as Html
import Material
import Material.Chip as Chip
import Material.List as Lists
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Select as Select
import Material.TextField as TextField
import Material.TextField.CharacterCounter as TextField
import Material.TextField.HelperLine as TextField
import Material.TextField.HelperText as TextField
import Material.Typography as Typography


type HeroDisplay
    = DemoHero
    | ElmHero


type alias Model m =
    { mdc : Material.Model m
    , heroOutlinedVariant : String
    , heroOutlined : Bool
    , heroLabel : String
    , heroLeadingIcon : Bool
    , heroTrailingIcon : Bool
    , heroDisplay : HeroDisplay
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , heroOutlinedVariant = "Filled"
    , heroOutlined = False
    , heroLabel = "Name"
    , heroLeadingIcon = False
    , heroTrailingIcon = False
    , heroDisplay = DemoHero
    }


type Msg m
    = Mdc (Material.Msg m)
    | UpdateLabel String
    | ToggleLeadingIcon
    | ToggleTrailingIcon
    | SelectVariant String
    | DemoTab
    | ElmTab


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        UpdateLabel label ->
            ( { model | heroLabel = label }, Cmd.none )

        ToggleLeadingIcon ->
            ( { model | heroLeadingIcon = not model.heroLeadingIcon }, Cmd.none )

        ToggleTrailingIcon ->
            ( { model | heroTrailingIcon = not model.heroTrailingIcon }, Cmd.none )

        SelectVariant key ->
            ( { model | heroOutlinedVariant = key, heroOutlined = key == "Outlined" }, Cmd.none )

        DemoTab ->
            ( { model | heroDisplay = DemoHero }, Cmd.none )

        ElmTab ->
            ( { model | heroDisplay = ElmHero }, Cmd.none )



heroComponent : (Msg m -> m) -> Model m -> Html m
heroComponent lift model =
    case model.heroDisplay of
        DemoHero ->
            TextField.view (lift << Mdc)
                "text-fields-hero-text-field-1"
                model.mdc
                [ TextField.label model.heroLabel
                , TextField.outlined |> when model.heroOutlined
                , TextField.leadingIcon "favorite" |> when model.heroLeadingIcon
                , TextField.trailingIcon "visibility" |> when model.heroTrailingIcon
                ]
                []
        ElmHero ->
            Html.pre []
                [ text """
    import Material.Options as Options
    import Material.TextField as TextField

    TextField.view Mdc "my-text-field" model.mdc
        [ TextField.label "Text field"
        , Options.onChange UpdateTextField
        ]
        []""" ]



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
    TextField.helperLine []
        [ TextField.helperText
            [ TextField.persistent ]
            [ text "Helper Text"
            ]
        ]


helperTextWithCharacterCounter : Html m
helperTextWithCharacterCounter =
    TextField.helperLine []
        [ TextField.helperText
            [ TextField.persistent ]
            [ text "Helper Text"
            ]
        , TextField.characterCounter [] [ text "0 / 18" ]
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


characterCounterTextFields : (Msg m -> m) -> Model m -> Html m
characterCounterTextFields lift model =
    let
        textField index options =
            [ TextField.view (lift << Mdc)
                index
                model.mdc
                options
                []
            , helperTextWithCharacterCounter
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
            ]
            []
        , helperText
        ]


textareaTextFieldWithCharacterCounter : (Msg m -> m) -> Model m -> Html m
textareaTextFieldWithCharacterCounter lift model =
    textFieldContainer []
        [ TextField.view (lift << Mdc)
            "text-fields-textarea-character-counter-text-field"
            model.mdc
            [ TextField.label "Standard"
            , TextField.textarea
            ]
            [ TextField.characterCounter [] [ text "0 / 18" ] ]
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
    page.body
        [ Hero.view
              [ Hero.header "Text Field"
              , Hero.intro "Text fields allow users to input, edit, and select text."
              , Hero.component [ cs "hero-component" ]
                  [ Hero.tabBar (lift << Mdc) model (lift DemoTab) (lift ElmTab)
                  , Hero.tabContainer []
                      [ Hero.tabContent []
                            [ heroComponent lift model ]
                      ]
                  ]
              , Hero.options
                  [ Lists.ul (lift << Mdc)
                        "hero-options"
                        model.mdc
                        [ Lists.nonInteractive ]
                        [ Lists.li []
                              [ styled span
                                    [ cs "mdc-typography--overline" ]
                                    [ text "Options" ]
                              ]
                        , Lists.li [ cs "catalog-tf-list-item" ]
                            [ Select.view (lift << Mdc)
                                  "hero-option-variant"
                                  model.mdc
                                  [ Select.label "Variant"
                                  , Select.selectedText model.heroOutlinedVariant
                                  , Select.required
                                  , Select.outlined
                                  , Select.onSelect (lift << SelectVariant)
                                  ]
                                  [ Select.option
                                        [ Select.value "Filled" ]
                                        [ text "Filled" ]
                                  , Select.option
                                      [ Select.value "Outlined" ]
                                      [ text "Outlined" ]
                                  ]
                            ]
                        , Lists.li [ cs "catalog-tf-list-item" ]
                            [ TextField.view (lift << Mdc)
                                  "hero-option-label"
                                  model.mdc
                                  [ TextField.label "Label"
                                  , TextField.outlined
                                  , Options.onInput (lift << UpdateLabel)
                                  , TextField.value model.heroLabel
                                  ]
                                  []
                            ]
                        , Lists.li []
                            [ styled span
                                  [ Typography.overline ]
                                  [ text "Icons" ]
                            ]
                        , Lists.li []
                            [ styled span
                                  [ Typography.caption ]
                                  [ text "We recommend using Material Icons. Follow the "
                                  , a [ href "http://google.github.io/material-design-icons/" ] [ text "instructions"]
                                  , text " to embed the icon font in your site."
                                  ]
                            ]
                            , Lists.li []
                                [ Chip.chipset
                                      [ Chip.filter
                                      , cs "hero-component__filter-chip-set-option"
                                      ]
                                      [ Chip.view (lift << Mdc)
                                            "hero-option-leading-icon"
                                            model.mdc
                                            [ Chip.checkmark
                                            , Chip.selected |> when model.heroLeadingIcon
                                            , Chip.onClick (lift ToggleLeadingIcon)
                                            ]
                                            [ text "Leading Icon" ]
                                      , Chip.view (lift << Mdc)
                                            "hero-option-trailing-icon"
                                            model.mdc
                                            [ Chip.checkmark
                                            , Chip.selected |> when model.heroTrailingIcon
                                            , Chip.onClick (lift ToggleTrailingIcon)
                                            ]
                                            [ text "Trailing Icon" ]
                                      ]
                                ]
                        ]
                  ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "text-fields" "input-controls/text-field" "mdc-textfield"
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
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Text Field with Character Counter" ]
            , characterCounterTextFields lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Textarea" ]
            , textareaTextField lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Textarea with Character Counter" ]
            , textareaTextFieldWithCharacterCounter lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Full Width" ]
            , fullwidthTextField lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Full Width Textarea" ]
            , fullwidthTextareaTextField lift model
            ]
        ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
