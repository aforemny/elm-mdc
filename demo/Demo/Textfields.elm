module Demo.Textfields exposing (Model, Msg(Mdc), defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as Html
import Html.Events as Html
import Material
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Textfield as Textfield
import Material.Textfield.HelperText as Textfield
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    , examples : Dict Material.Index Example
    }


type alias Example =
    { disabled : Bool
    , rtl : Bool
    , dense : Bool
    , required : Bool
    , helperText : Bool
    , persistent : Bool
    , validationMsg : Bool
    }


defaultExample : Example
defaultExample =
    { disabled = False
    , rtl = False
    , dense = False
    , required = False
    , helperText = False
    , persistent = False
    , validationMsg = False
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , examples = Dict.empty
    }


type Msg m
    = Mdc (Material.Msg m)
    | ExampleMsg Material.Index ExampleMsg


type ExampleMsg
    = ToggleDisabled
    | ToggleRtl
    | ToggleDense
    | ToggleRequired
    | ToggleHelperText
    | TogglePersistent
    | ToggleValidationMsg


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ExampleMsg index msg_ ->
            let
                example =
                    Dict.get index model.examples
                        |> Maybe.withDefault defaultExample
                        |> updateExample msg_

                examples =
                    Dict.insert index example model.examples
            in
            { model | examples = examples } ! []


updateExample : ExampleMsg -> Example -> Example
updateExample msg model =
    case msg of
        ToggleDisabled ->
            { model | disabled = not model.disabled }

        ToggleRtl ->
            { model | rtl = not model.rtl }

        ToggleDense ->
            { model | dense = not model.dense }

        ToggleRequired ->
            { model | required = not model.required }

        ToggleHelperText ->
            { model | helperText = not model.helperText }

        TogglePersistent ->
            { model | persistent = not model.persistent }

        ToggleValidationMsg ->
            { model | validationMsg = not model.validationMsg }


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body "Text fields"
        [ Page.hero []
            [ heroTextfield lift "text-fields-hero" model
            ]
        , textfield lift "text-fields-default" model
        , password lift "text-fields-password" model
        , outlinedTextfield lift "text-fields-outlined" model
        , boxTextfield lift "text-fields-box" model
        , iconsTextfield lift "text-fields-icons" model
        , textarea lift "text-fields-textarea" model
        , fullwidth lift "text-fields-full-width" model
        ]


heroTextfield : (Msg m -> m) -> Material.Index -> Model m -> Html m
heroTextfield lift index model =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    Textfield.view (lift << Mdc)
        index
        model.mdc
        [ Textfield.label "Text field"
        ]
        []


textfield : (Msg m -> m) -> Material.Index -> Model m -> Html m
textfield lift index model =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    example []
        [ Html.h2 []
            [ Html.text
                "Full Functionality Component (Floating Label, Validation)"
            ]
        , styled Html.section
            [ Options.attribute (Html.dir "rtl") |> when state.rtl
            ]
            [ Html.div []
                [ Textfield.view (lift << Mdc)
                    index
                    model.mdc
                    [ Textfield.label "Email Address"
                    , Textfield.disabled |> when state.disabled
                    , Textfield.dense |> when state.dense
                    , Textfield.required |> when state.required
                    ]
                    []
                , Textfield.helperText
                    [ Textfield.persistent |> when state.persistent
                    , Textfield.validationMsg |> when state.validationMsg
                    , css "display" "none" |> when (not state.helperText)
                    ]
                    [ Html.text "Help Text (possibly validation message)"
                    ]
                ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleDisabled))
                , Html.checked state.disabled
                ]
                []
            , Html.label [] [ Html.text " Disabled" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleRtl))
                , Html.checked state.rtl
                ]
                []
            , Html.label [] [ Html.text " RTL" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleDense))
                , Html.checked state.dense
                ]
                []
            , Html.label [] [ Html.text " Dense" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleRequired))
                , Html.checked state.required
                ]
                []
            , Html.label [] [ Html.text " Required" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleHelperText))
                , Html.checked state.helperText
                ]
                []
            , Html.label [] [ Html.text " Use Helper Text" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index TogglePersistent))
                , Html.checked state.persistent
                , Html.disabled (not state.helperText)
                ]
                []
            , styled Html.label
                [ css "opacity" ".4" |> when (not state.helperText)
                ]
                [ Html.text " Make helper text persistent"
                ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleValidationMsg))
                , Html.checked state.validationMsg
                , Html.disabled (not state.helperText)
                ]
                []
            , styled Html.label
                [ css "opacity" ".4" |> when (not state.helperText)
                ]
                [ Html.text " Use helper text as validation message"
                ]
            ]
        ]


password : (Msg m -> m) -> Material.Index -> Model m -> Html m
password lift index model =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    example []
        [ Html.h2 []
            [ Html.text "Password field with validation"
            ]
        , styled Html.section
            [ Options.attribute (Html.dir "rtl") |> when state.rtl
            ]
            [ Html.div []
                [ Textfield.view (lift << Mdc)
                    index
                    model.mdc
                    [ Textfield.label "Choose password"
                    , Textfield.password
                    , Textfield.pattern ".{8,}"
                    , Textfield.required
                    , Textfield.disabled |> when state.disabled
                    , Textfield.dense |> when state.dense
                    ]
                    []
                , Textfield.helperText
                    [ Textfield.persistent
                    , Textfield.validationMsg
                    ]
                    [ Html.text "Must be at least 8 characters long"
                    ]
                ]
            ]
        ]


outlinedTextfield : (Msg m -> m) -> Material.Index -> Model m -> Html m
outlinedTextfield lift index model =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    example []
        [ Html.h2 []
            [ Html.text "Outlined Text Field"
            ]
        , styled Html.section
            [ Options.attribute (Html.dir "rtl") |> when state.rtl
            ]
            [ Html.div []
                [ Textfield.view (lift << Mdc)
                    index
                    model.mdc
                    [ Textfield.label "Your Name"
                    , Textfield.outlined
                    , Textfield.dense |> when state.dense
                    , Textfield.disabled |> when state.disabled
                    ]
                    []
                , Textfield.helperText
                    [ Textfield.persistent |> when state.persistent
                    , Textfield.validationMsg |> when state.validationMsg
                    ]
                    [ Html.text "Must be at least 8 characters"
                    ]
                ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleDisabled))
                , Html.checked state.disabled
                ]
                []
            , Html.label [] [ Html.text " Disabled" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleRtl))
                , Html.checked state.rtl
                ]
                []
            , Html.label [] [ Html.text " RTL" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleDense))
                , Html.checked state.dense
                ]
                []
            , Html.label [] [ Html.text " Dense" ]
            ]
        ]


boxTextfield : (Msg m -> m) -> Material.Index -> Model m -> Html m
boxTextfield lift index model =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    example []
        [ Html.h2 []
            [ Html.text "Textfield box"
            ]
        , styled Html.section
            [ Options.attribute (Html.dir "rtl") |> when state.rtl
            ]
            [ Html.div []
                [ Textfield.view (lift << Mdc)
                    index
                    model.mdc
                    [ Textfield.label "Your Name"
                    , Textfield.box
                    , Textfield.disabled |> when state.disabled
                    , Textfield.dense |> when state.dense
                    ]
                    []
                , Textfield.helperText
                    [ Textfield.persistent |> when state.persistent
                    , Textfield.validationMsg |> when state.validationMsg
                    ]
                    [ Html.text "Must provide a name"
                    ]
                ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleDisabled))
                , Html.checked state.disabled
                ]
                []
            , Html.label [] [ Html.text " Disabled" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleRtl))
                , Html.checked state.rtl
                ]
                []
            , Html.label [] [ Html.text " RTL" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleDense))
                , Html.checked state.dense
                ]
                []
            , Html.label [] [ Html.text " Dense" ]
            ]
        ]


iconsTextfield : (Msg m -> m) -> Material.Index -> Model m -> Html m
iconsTextfield lift index model =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    example []
        [ Html.h2 []
            [ Html.text
                "Text Field - Leading/Trailing icons"
            ]
        , styled Html.section
            [ Options.attribute (Html.dir "rtl") |> when state.rtl
            ]
            [ Html.div []
                [ Textfield.view (lift << Mdc)
                    (index ++ "-your-name")
                    model.mdc
                    [ Textfield.label "Your name"
                    , Textfield.disabled |> when state.disabled
                    , Textfield.dense |> when state.dense
                    , Textfield.required |> when state.required
                    , Textfield.box
                    , Textfield.leadingIcon "event"
                    ]
                    []
                ]
            , Html.div []
                [ Textfield.view (lift << Mdc)
                    (index ++ "-your-other-name")
                    model.mdc
                    [ Textfield.label "Your other name"
                    , Textfield.disabled |> when state.disabled
                    , Textfield.dense |> when state.dense
                    , Textfield.required |> when state.required
                    , Textfield.box
                    , Textfield.trailingIcon "delete"
                    ]
                    []
                ]
            , Html.div []
                [ Textfield.view (lift << Mdc)
                    (index ++ "-your-other-name-2")
                    model.mdc
                    [ Textfield.label "Your other name"
                    , Textfield.disabled |> when state.disabled
                    , Textfield.dense |> when state.dense
                    , Textfield.required |> when state.required
                    , Textfield.outlined
                    , Textfield.leadingIcon "event"
                    ]
                    []
                ]
            , Html.div []
                [ Textfield.view (lift << Mdc)
                    (index ++ "-your-other-name-3")
                    model.mdc
                    [ Textfield.label "Your other name"
                    , Textfield.disabled |> when state.disabled
                    , Textfield.dense |> when state.dense
                    , Textfield.required |> when state.required
                    , Textfield.outlined
                    , Textfield.trailingIcon "delete"
                    ]
                    []
                ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleDisabled))
                , Html.checked state.disabled
                ]
                []
            , Html.label [] [ Html.text " Disabled" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleRtl))
                , Html.checked state.rtl
                ]
                []
            , Html.label [] [ Html.text " RTL" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleDense))
                , Html.checked state.dense
                ]
                []
            , Html.label [] [ Html.text " Dense" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleRequired))
                , Html.checked state.required
                ]
                []
            , Html.label [] [ Html.text " Required" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleHelperText))
                , Html.checked state.helperText
                ]
                []
            , Html.label [] [ Html.text " Use Helper Text" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index TogglePersistent))
                , Html.checked state.persistent
                , Html.disabled (not state.helperText)
                ]
                []
            , styled Html.label
                [ css "opacity" ".4" |> when (not state.helperText)
                ]
                [ Html.text " Make helper text persistent"
                ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleValidationMsg))
                , Html.checked state.validationMsg
                , Html.disabled (not state.helperText)
                ]
                []
            , styled Html.label
                [ css "opacity" ".4" |> when (not state.helperText)
                ]
                [ Html.text " Use helper text as validation message"
                ]
            ]
        ]


textarea : (Msg m -> m) -> Material.Index -> Model m -> Html m
textarea lift index model =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    example []
        [ Html.h2 []
            [ Html.text "Textarea"
            ]
        , styled Html.section
            [ Options.attribute (Html.dir "rtl") |> when state.rtl
            ]
            [ Html.div []
                [ Textfield.view (lift << Mdc)
                    index
                    model.mdc
                    [ Textfield.label "Multi-line Label"
                    , Textfield.textarea
                    , Textfield.rows 8
                    , Textfield.cols 40
                    , Textfield.disabled |> when state.disabled
                    , Textfield.dense |> when state.dense
                    ]
                    []
                ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleDisabled))
                , Html.checked state.disabled
                ]
                []
            , Html.label [] [ Html.text " Disabled" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleRtl))
                , Html.checked state.rtl
                ]
                []
            , Html.label [] [ Html.text " RTL" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleDense))
                , Html.checked state.dense
                ]
                []
            , Html.label [] [ Html.text " Dense" ]
            ]
        ]


fullwidth : (Msg m -> m) -> Material.Index -> Model m -> Html m
fullwidth lift index model =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    example []
        [ Html.h2 []
            [ Html.text "Full-Width Text Field and Textarea"
            ]
        , styled Html.section
            [ Options.attribute (Html.dir "rtl") |> when state.rtl
            ]
            [ Html.div []
                [ Textfield.view (lift << Mdc)
                    (index ++ "-subject")
                    model.mdc
                    [ Textfield.placeholder "Subject"
                    , Textfield.fullwidth
                    ]
                    []
                , Textfield.view (lift << Mdc)
                    (index ++ "-textarea")
                    model.mdc
                    [ Textfield.placeholder "Textarea Label"
                    , Textfield.textarea
                    , Textfield.fullwidth
                    , Textfield.rows 8
                    , Textfield.cols 40
                    , css "margin-top" "16px"
                    ]
                    []
                ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleDisabled))
                , Html.checked state.disabled
                ]
                []
            , Html.label [] [ Html.text " Disabled" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleRtl))
                , Html.checked state.rtl
                ]
                []
            , Html.label [] [ Html.text " RTL" ]
            ]
        , styled Html.div
            []
            [ checkbox
                [ Html.onClick (lift (ExampleMsg index ToggleDense))
                , Html.checked state.dense
                ]
                []
            , Html.label [] [ Html.text " Dense" ]
            ]
        ]


example : List (Options.Property c m) -> List (Html m) -> Html m
example options =
    styled Html.div
        (css "padding" "24px"
            :: css "margin" "24px"
            :: options
        )


h2 : List (Options.Property () m) -> List (Html m) -> Html m
h2 options =
    styled Html.h2
        (css "margin-top" "20px"
            :: css "margin-bottom" "20px"
            :: Typography.title
            :: options
        )


checkbox : List (Html.Attribute m) -> List (Html m) -> Html m
checkbox options =
    Html.input
        (Html.type_ "checkbox"
            :: options
        )
