module Material
    exposing
        ( Index
        , Model
        , Msg
        , defaultModel
        , init
        , subscriptions
        , top
        , update
        )

{-| Material is a re-implementation of Google's Internal.Components for Web (MDC
Web) library in pure Elm, with resorting to JavaScript assets only when
absolutely necessary.

This module defines the basic boilerplate that you will have to set up to use
this library, with individual components living in their respective modules.

Have a look at the following example to get you started. Most parts should
correspond to your basic TEA program.

Some things of note are:

  - `Material.Model` and `Material.Msg` have to know your top-level message type
    `Msg` for technical reasons.
  - Your message constructor `Mdc : Material.Msg Msg -> Msg` _lifts_ internal
    component messages to your top-level message type and appears throughout the
    library.
  - To distinguish components, ie. one button from another, this library uses a
    list of integers as indices. Those indices must be unique within a
    `Material.Model`, but you can have as many `Material.Model`s as you like.

Have a look at the demo's source code for an example of how to structure large
applications using this library.

You are expected to have a `index.html` set up and include the following
resources:

```html
<link href="https://fonts.googleapis.com/css?family=Roboto+Mono" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500" rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/normalize/7.0.0/normalize.min.css" rel="stylesheet">
<script src="elm-mdc.js"></script>
```

Set the `mdc-typography` class in the body:

```html
<body class="mdc-typography">
  ...
</body>
```


# Resources

  - [Demo](https://aforemny.github.io/elm-mdc)


# Example

    import Html exposing (Html, text)
    import Material
    import Material.Button as Button
    import Material.Options as Options


    type alias Model
        { mdc : Material.Model Msg
        }


    defaultModel : Model
    defaultModel =
        { mdc = Material.defaultModel
        }


    type Msg
        = Mdc (Material.Msg Msg)
        | Click


    main : Program Never Model Msg
    main =
        Html.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


    init : ( Model, Cmd Msg )
    init =
        ( defaultModel, Material.init Mdc )


    subscriptions : Model -> Sub Msg
    subscriptions model =
        Material.subscriptions Mdc model


    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            Mdc msg_ ->
                Material.update Mdc msg_ model

            Click ->
                let
                    _ =
                        Debug.log "Msg" "Click"
                in
                ( model, Cmd.none )


    view : Model -> Html Msg
    view model =
        Material.top <|
        Html.div []
            [
              Button.view Mdc "my-button" model.mdc
                  [ Button.ripple
                  , Options.onClick Click
                  ]
                  [ text "Click me!" ]
            ]


# Usage


## The Elm Architecture

@docs Model
@docs defaultModel
@docs Msg
@docs init
@docs subscriptions
@docs update
@docs Index


## Prototyping

@docs top

-}

import Dict
import Html exposing (Html, text)
import Html.Attributes as Html
import Internal.Button.Implementation as Button
import Internal.Button.Model as Button
import Internal.Checkbox.Implementation as Checkbox
import Internal.Checkbox.Model as Checkbox
import Internal.Chip.Implementation as Chip
import Internal.Chip.Model as Chip
import Internal.Component exposing (Indexed)
import Internal.Dialog.Implementation as Dialog
import Internal.Dialog.Model as Dialog
import Internal.Dispatch as Dispatch
import Internal.Drawer.Implementation as Drawer
import Internal.Drawer.Model as Drawer
import Internal.Fab.Implementation as Fab
import Internal.Fab.Model as Fab
import Internal.GridList.Implementation as GridList
import Internal.GridList.Model as GridList
import Internal.IconToggle.Implementation as IconToggle
import Internal.IconToggle.Model as IconToggle
import Internal.Menu.Implementation as Menu
import Internal.Menu.Model as Menu
import Internal.Msg exposing (Msg(..))
import Internal.RadioButton.Implementation as RadioButton
import Internal.RadioButton.Model as RadioButton
import Internal.Ripple.Implementation as Ripple
import Internal.Ripple.Model as Ripple
import Internal.Select.Implementation as Select
import Internal.Select.Model as Select
import Internal.Slider.Implementation as Slider
import Internal.Slider.Model as Slider
import Internal.Snackbar.Implementation as Snackbar
import Internal.Snackbar.Model as Snackbar
import Internal.Switch.Implementation as Switch
import Internal.Switch.Model as Switch
import Internal.Tabs.Implementation as Tabs
import Internal.Tabs.Model as Tabs
import Internal.Textfield.Implementation as Textfield
import Internal.Textfield.Model as Textfield
import Internal.Toolbar.Implementation as Toolbar
import Internal.Toolbar.Model as Toolbar
import Internal.TopAppBar.Implementation as TopAppBar
import Internal.TopAppBar.Model as TopAppBar


{-| Different instances of components are differentiated by an `Index`.

This is a string and is expected to be globally unique within your program. It
coincides with `Html.id`, and we may set it as `Html.id` on a component's
native control (`<input>`) element, ie. Checkbox, Radio, Select, Switch, and
Textfield.

-}
type alias Index =
    Internal.Component.Index


{-| Material model.

This takes as argument a reference to your top-level message type `Msg`.

    type alias Model =
        { mdc : Material.Model Msg
        , …
        }

-}
type alias Model m =
    { button : Indexed Button.Model
    , checkbox : Indexed Checkbox.Model
    , chip : Indexed Chip.Model
    , dialog : Indexed Dialog.Model
    , drawer : Indexed Drawer.Model
    , fab : Indexed Fab.Model
    , gridList : Indexed GridList.Model
    , iconToggle : Indexed IconToggle.Model
    , menu : Indexed Menu.Model
    , radio : Indexed RadioButton.Model
    , ripple : Indexed Ripple.Model
    , select : Indexed Select.Model
    , slider : Indexed Slider.Model
    , snackbar : Indexed (Snackbar.Model m)
    , switch : Indexed Switch.Model
    , tabs : Indexed Tabs.Model
    , textfield : Indexed Textfield.Model
    , toolbar : Indexed Toolbar.Model
    , topAppBar : Indexed TopAppBar.Model
    }


{-| Material default model.

    defaultModel =
        { mdc = Material.defaultModel
        , …
        }

-}
defaultModel : Model m
defaultModel =
    { button = Dict.empty
    , checkbox = Dict.empty
    , chip = Dict.empty
    , dialog = Dict.empty
    , drawer = Dict.empty
    , fab = Dict.empty
    , gridList = Dict.empty
    , iconToggle = Dict.empty
    , menu = Dict.empty
    , radio = Dict.empty
    , ripple = Dict.empty
    , select = Dict.empty
    , slider = Dict.empty
    , snackbar = Dict.empty
    , switch = Dict.empty
    , tabs = Dict.empty
    , textfield = Dict.empty
    , toolbar = Dict.empty
    , topAppBar = Dict.empty
    }


{-| Material message type.

This takes as argument a reference to your top-level message type `Msg`.

    type Msg
        = Mdc (Material.Msg Msg)
        | …

-}
type alias Msg m =
    Internal.Msg.Msg m


{-| Material update.

        update msg model =
            case msg of
                Mdc msg_ ->
                    Material.update Mdc msg_ model

                …

-}
update :
    (Msg m -> m)
    -> Msg m
    -> { c | mdc : Model m }
    -> ( { c | mdc : Model m }, Cmd m )
update lift msg container =
    update_ lift msg (.mdc container)
        |> Tuple.mapFirst (Maybe.map (\mdc -> { container | mdc = mdc }))
        |> Tuple.mapFirst (Maybe.withDefault container)


update_ : (Msg m -> m) -> Msg m -> Model m -> ( Maybe (Model m), Cmd m )
update_ lift msg store =
    case msg of
        Dispatch msgs ->
            ( Nothing, Dispatch.forward msgs )

        ButtonMsg idx msg_ ->
            Button.react lift msg_ idx store

        CheckboxMsg idx msg_ ->
            Checkbox.react lift msg_ idx store

        ChipMsg idx msg_ ->
            Chip.react lift msg_ idx store

        DialogMsg idx msg_ ->
            Dialog.react lift msg_ idx store

        DrawerMsg idx msg_ ->
            Drawer.react lift msg_ idx store

        FabMsg idx msg_ ->
            Fab.react lift msg_ idx store

        GridListMsg idx msg_ ->
            GridList.react lift msg_ idx store

        IconToggleMsg idx msg_ ->
            IconToggle.react lift msg_ idx store

        MenuMsg idx msg_ ->
            Menu.react lift msg_ idx store

        RadioButtonMsg idx msg_ ->
            RadioButton.react lift msg_ idx store

        RippleMsg idx msg_ ->
            Ripple.react lift msg_ idx store

        SelectMsg idx msg_ ->
            Select.react lift msg_ idx store

        SliderMsg idx msg_ ->
            Slider.react lift msg_ idx store

        SnackbarMsg idx msg_ ->
            Snackbar.react lift msg_ idx store

        SwitchMsg idx msg_ ->
            Switch.react lift msg_ idx store

        TabsMsg idx msg_ ->
            Tabs.react lift msg_ idx store

        TextfieldMsg idx msg_ ->
            Textfield.react lift msg_ idx store

        ToolbarMsg idx msg_ ->
            Toolbar.react lift msg_ idx store

        TopAppBarMsg idx msg_ ->
            TopAppBar.react lift msg_ idx store


{-| Material subscriptions.

    subscriptions model =
        Sub.batch
        [ Material.subscriptions Mdc model
        , …
        ]

-}
subscriptions : (Msg m -> m) -> { model | mdc : Model m } -> Sub m
subscriptions lift model =
    Sub.batch
        [ Drawer.subs lift model.mdc
        , Menu.subs lift model.mdc
        ]


{-| Material init.

    init =
        let
            defaultModel =
                …

            effects =
                Cmd.map
                [ Material.init Mdc
                , …
                ]
        in
        ( defaultModel, effects )

-}
init : (Msg m -> m) -> Cmd m
init lift =
    Cmd.none


{-| A top-level wrapper for quick prototyping. This wraps your HTML content and
adds the necessary CSS and JavaScript imports.

For production use, you will want to do this yourself in `index.html` to
prevent an unstyled flash of content and to properly manage assets.

-}
top : Html a -> Html a
top content =
    Html.div []
        [ content
        , Html.node "style"
            [ Html.type_ "text/css"
            ]
            [ [ "https://fonts.googleapis.com/css?family=Roboto+Mono"
              , "https://fonts.googleapis.com/css?family=Roboto:300,400,500"
              , "https://fonts.googleapis.com/icon?family=Material+Icons"
              , "https://cdnjs.cloudflare.com/ajax/libs/normalize/7.0.0/normalize.min.css"
              , "https://aforemny.github.io/elm-mdc/material-components-web.css"
              ]
                |> List.map
                    (\url ->
                        "@import url(" ++ url ++ ");"
                    )
                |> String.join "\n"
                |> text
            ]
        , Html.node "script"
            [ Html.type_ "text/javascript"
            , Html.src "https://aforemny.github.io/elm-mdc/elm-mdc.js"
            ]
            []
        ]
