module Demo.Textfields exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as Html
import Html.Events as Html
import Material
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Textfield as Textfield
import Material.Textfield.HelperText as HelperText
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    , examples : Dict Material.Index Example
    }


type alias Example =
    { disabled : Bool
    , rtl : Bool
    , required : Bool
    , helperText : Bool
    , persistent : Bool
    , validationMsg : Bool
    , leadingIconClicked : Bool
    , trailingIconClicked : Bool
    }


defaultExample : Example
defaultExample =
    { disabled = False
    , rtl = False
    , required = False
    , helperText = False
    , persistent = False
    , validationMsg = False
    , leadingIconClicked = False
    , trailingIconClicked = False
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
    | ToggleRequired
    | ToggleHelperText
    | TogglePersistent
    | ToggleValidationMsg
    | LeadingIconClicked
    | TrailingIconClicked


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ExampleMsg index msg_ ->
            let
                examples =
                    Dict.get index model.examples
                        |> Maybe.withDefault defaultExample
                        |> (\exampleState ->
                                Dict.insert index
                                    (updateExample msg_ exampleState)
                                    model.examples
                           )
            in
            ( { model | examples = examples }, Cmd.none )


updateExample : ExampleMsg -> Example -> Example
updateExample msg model =
    case msg of
        ToggleDisabled ->
            { model | disabled = not model.disabled }

        ToggleRtl ->
            { model | rtl = not model.rtl }

        ToggleRequired ->
            { model | required = not model.required }

        ToggleHelperText ->
            { model | helperText = not model.helperText }

        TogglePersistent ->
            { model | persistent = not model.persistent }

        ToggleValidationMsg ->
            { model | validationMsg = not model.validationMsg }

        LeadingIconClicked ->
            { model | leadingIconClicked = True, trailingIconClicked = False }

        TrailingIconClicked ->
            { model | leadingIconClicked = False, trailingIconClicked = True }


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body "Text Field" "Text fields allow users to input, edit, and select text. Text fields typically reside in forms but can appear in other places, like dialog boxes and search."
        [ Html.h1
              [ Html.class "mdc-typography--headline5" ]
              [ Html.text "Text Field" ]
        , Html.p
            [ Html.class "mdc-typography--body1" ]
            [ Html.text "Text fields allow users to input, edit, and select text. Text fields typically reside in forms but can appear in other places, like dialog boxes and search." ]
        , Page.hero []
            [ heroTextFieldsContainer
                  [ heroTextFieldContainer ( heroTextfield lift "text-fields-hero" model [] )
                  , heroTextFieldContainer ( heroTextfield lift "text-fields-hero-outlined" model [ Textfield.outlined ] )
                  ]
            ]
        , defaultTextfield lift "text-fields-default" model
        , password lift "text-fields-password" model
        , filled lift model
        , outlined lift model
        , trailingAndLeadingIcon lift "trailing-and-leading-icon" model
        , textarea lift "text-fields-textarea" model
        , fullwidthTextfield lift "text-field-fullwidth-helper" model
        , fullwidthTextarea lift "text-field-fullwidth-textarea-helper" model
        ]


heroTextFieldsContainer =
    styled Html.div
        [ cs "hero-text-field-container"
        , css "display" "flex"
        , css "flex" "1 1 100%"
        , css "justify-content" "space-around"
        , css "flex-wrap" "wrap"
        ]


heroTextFieldContainer : Html m -> Html m
heroTextFieldContainer textfield =
    styled Html.div
        [ cs "text-field-container"
        , css "min-width" "200px"
        , css "padding" "20px"
        ]
        [ textfield ]


heroTextfield : (Msg m -> m) -> Material.Index -> Model m -> List (Textfield.Property m) -> Html m
heroTextfield lift index model options =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    Textfield.view (lift << Mdc)
        index
        model.mdc
        ( Textfield.label "Standard"
          :: options
        )
        []


defaultTextfield : (Msg m -> m) -> Material.Index -> Model m -> Html m
defaultTextfield lift index model =
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
                    , Textfield.required |> when state.required
                    ]
                    []
                , HelperText.helperText
                    [ HelperText.persistent |> when state.persistent
                    , HelperText.validationMsg |> when state.validationMsg
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
                    ]
                    []
                , HelperText.helperText
                    [ HelperText.persistent
                    , HelperText.validationMsg
                    ]
                    [ Html.text "Must be at least 8 characters long"
                    ]
                ]
            ]
        ]


textField : (Msg m -> m) -> Material.Index -> Model m -> List (Textfield.Property m) -> Html m
textField lift index model options =
    Textfield.view (lift << Mdc) ( "text-field-" ++ index ) model.mdc
        ( [ Textfield.label "Standard"
          ] ++ options )
        []


textFieldLeadingIcon : (Msg m -> m) -> Material.Index -> Model m -> List (Textfield.Property m) -> Html m
textFieldLeadingIcon lift index model options =
    Textfield.view (lift << Mdc) ( "text-field-" ++ index ++ "-leading" ) model.mdc
        ( [ Textfield.label "Standard"
          , Textfield.leadingIcon "event"
          ] ++ options )
        []


textFieldTrailingIcon : (Msg m -> m) -> Material.Index -> Model m -> List (Textfield.Property m) -> Html m
textFieldTrailingIcon lift index model options =
    Textfield.view (lift << Mdc) ( "text-field-" ++ index ++ "-leading" ) model.mdc
        ( [ Textfield.label "Standard"
          , Textfield.trailingIcon "event"
          ] ++ options )
        []


textFieldContainer : Html m -> Html m
textFieldContainer textfield =
    styled Html.div
        [ cs "text-field-container"
        , css "min-width" "200px"
        ]
        [ textfield
        , HelperText.helperText
            [ HelperText.persistent ]
            [ Html.text "Helper Text"
            ]
        ]


header title =
    Html.h3 [ Html.class "mdc-typography--subtitle1" ] [ Html.text title ]


exampleRow lift index model title options =
    example []
        [ header title
        , styled Html.div
            [ cs "text-field-row"
            , css "display" "flex"
            , css "align-items" "flex-start"
            , css "justify-content" "space-between"
            , css "flex-wrap" "wrap"
            ]
            [ textFieldContainer ( textField lift index model options )
            , textFieldContainer ( textFieldLeadingIcon lift ( index ++ "-leading") model options )
            , textFieldContainer ( textFieldTrailingIcon lift ( index ++ "-trailing") model options )
            ]
        ]


filled : (Msg m -> m) -> Model m -> Html m
filled lift model =
    exampleRow lift "filled" model "Filled" []


outlined : (Msg m -> m) -> Model m -> Html m
outlined lift model =
    exampleRow lift "outlined" model "Outlined" [ Textfield.outlined ]


trailingAndLeadingIcon : (Msg m -> m) -> Material.Index -> Model m -> Html m
trailingAndLeadingIcon lift index model =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    example []
        [ header "Trailing and leading icon"
        , styled Html.section
            [ Options.attribute (Html.dir "rtl") |> when state.rtl
            ]
            [ Html.div []
                [ Textfield.view (lift << Mdc)
                    index
                    model.mdc
                    [ Textfield.label "Leading and trailing icons"
                    , Textfield.disabled |> when state.disabled
                    , Textfield.leadingIcon "phone"
                    , Textfield.trailingIcon "event"
                    , Textfield.onLeadingIconClick (lift (ExampleMsg index LeadingIconClicked))
                    , Textfield.onTrailingIconClick (lift (ExampleMsg index TrailingIconClicked))
                    ]
                    []
                ]
            ]
        , if state.leadingIconClicked then
              Html.p [] [ Html.text "You clicked the leading icon." ]
          else
              if state.trailingIconClicked then
                  Html.p [] [ Html.text "You clicked the trailing icon." ]
              else
                  Html.text ""
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
        ]


textarea : (Msg m -> m) -> Material.Index -> Model m -> Html m
textarea lift index model =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    example []
        [ header "Textarea"
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
                    , Textfield.outlined
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
        ]


fullwidthTextfield : (Msg m -> m) -> Material.Index -> Model m -> Html m
fullwidthTextfield lift index model =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    example []
        [ header "Full Width"
        , styled Html.section
            [ Options.attribute (Html.dir "rtl") |> when state.rtl
            ]
            [ Html.div []
                [ Textfield.view (lift << Mdc)
                    index
                    model.mdc
                    [ Textfield.placeholder "Standard"
                    , Textfield.fullwidth
                    , Textfield.disabled |> when state.disabled
                    ]
                    []
                , HelperText.helperText
                    [ HelperText.persistent ]
                    [ Html.text "Helper Text"
                    ]
                ]
            ]
        , styled Html.div
            [ css "margin-top" "24px" ]
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
        ]


fullwidthTextarea : (Msg m -> m) -> Material.Index -> Model m -> Html m
fullwidthTextarea lift index model =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    example []
        [ header "Full Width Textarea"
        , styled Html.section
            [ Options.attribute (Html.dir "rtl") |> when state.rtl
            ]
            [ Html.div []
                [ Textfield.view (lift << Mdc)
                    index
                    model.mdc
                    [ Textfield.label "Standard"
                    , Textfield.textarea
                    , Textfield.fullwidth
                    , Textfield.rows 8
                    , Textfield.cols 40
                    , Textfield.outlined
                    , Textfield.disabled |> when state.disabled
                    , css "margin-top" "16px"
                    ]
                    []
                , HelperText.helperText
                    [ HelperText.persistent ]
                    [ Html.text "Helper Text"
                    ]
                ]
            ]
        , styled Html.div
            [ css "margin-top" "24px" ]
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
        ]


example : List (Options.Property c m) -> List (Html m) -> Html m
example options =
    styled Html.div
        options


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
