module Material exposing
    ( defaultModel
    , init
    , Model
    , Msg
    , subscriptions
    , top
    , update
    )

{-|
Material is a re-implementation of Google's Material Components for Web (MDC
Web) library in pure Elm, with resorting to JavaScript assets only when
absolutely necessary.

This module defines the basic boilerplate that you will have to set up to use
this library, with individual components living in their respective modules.

Have a look at the following example to get you started. Most parts should
correspond to your basic TEA program.

Some things of note are:

- `Material.Model` and `Material.Msg` have to know your top-level message type
  `Msg` for technical reasons.
- Your message constructor `Mdc : Material.Msg Msg -> Msg` *lifts* internal
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

```elm
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
          Button.view Mdc [0] model.mdc
              [ Button.ripple
              , Options.onClick Click
              ]
              [ text "Click me!" ]
        ]
```


# Usage

## The Elm Architecture

@docs Model
@docs defaultModel
@docs Msg
@docs init
@docs subscriptions
@docs update

## Prototyping

@docs top
-}

import Dict
import Html.Attributes as Html
import Html exposing (Html, text)
import Material.Internal.Button.Implementation as Button
import Material.Internal.Button.Model as Button
import Material.Internal.Checkbox.Implementation as Checkbox
import Material.Internal.Checkbox.Model as Checkbox
import Material.Internal.Component as Component exposing (Indexed)
import Material.Internal.Dialog.Implementation as Dialog
import Material.Internal.Dialog.Model as Dialog
import Material.Internal.Dispatch as Dispatch
import Material.Internal.Drawer.Implementation as Drawer
import Material.Internal.Drawer.Model as Drawer
import Material.Internal.Fab.Implementation as Fab
import Material.Internal.Fab.Model as Fab
import Material.Internal.GridList.Implementation as GridList
import Material.Internal.GridList.Model as GridList
import Material.Internal.IconToggle.Implementation as IconToggle
import Material.Internal.IconToggle.Model as IconToggle
import Material.Internal.ImageList.Implementation as ImageList
import Material.Internal.ImageList.Model as ImageList
import Material.Internal.Menu.Implementation as Menu
import Material.Internal.Menu.Model as Menu
import Material.Internal.Msg exposing (Msg(..))
import Material.Internal.RadioButton.Implementation as RadioButton
import Material.Internal.RadioButton.Model as RadioButton
import Material.Internal.Ripple.Implementation as Ripple
import Material.Internal.Ripple.Model as Ripple
import Material.Internal.Select.Implementation as Select
import Material.Internal.Select.Model as Select
import Material.Internal.Slider.Implementation as Slider
import Material.Internal.Slider.Model as Slider
import Material.Internal.Snackbar.Implementation as Snackbar
import Material.Internal.Snackbar.Model as Snackbar
import Material.Internal.Switch.Implementation as Switch
import Material.Internal.Switch.Model as Switch
import Material.Internal.Tabs.Implementation as Tabs
import Material.Internal.Tabs.Model as Tabs
import Material.Internal.Textfield.Implementation as Textfield
import Material.Internal.Textfield.Model as Textfield
import Material.Internal.Toolbar.Implementation as Toolbar
import Material.Internal.Toolbar.Model as Toolbar
import Material.Internal.TopAppBar.Implementation as TopAppBar
import Material.Internal.TopAppBar.Model as TopAppBar


{-| Material model.

This takes as argument a reference to your top-level message type `Msg`.

```elm
type alias Model =
    { mdc : Material.Model Msg
    , …
    }
```
-}
type alias Model m =
    { button : Indexed Button.Model
    , checkbox : Indexed Checkbox.Model
    , dialog : Indexed Dialog.Model
    , drawer : Indexed Drawer.Model
    , fab : Indexed Fab.Model
    , gridList : Indexed GridList.Model
    , iconToggle : Indexed IconToggle.Model
    , imageList : Indexed ImageList.Model
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

```elm
defaultModel =
    { mdc = Material.defaultModel
    , …
    }
```
-}
defaultModel : Model m
defaultModel = 
    { button = Dict.empty
    , checkbox = Dict.empty
    , dialog = Dict.empty
    , drawer = Dict.empty
    , fab = Dict.empty
    , gridList = Dict.empty
    , iconToggle = Dict.empty
    , imageList = Dict.empty
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

```elm
type Msg
    = Mdc (Material.Msg Msg)
    | …
```
-}
type alias Msg m =
    Material.Internal.Msg.Msg m


{-| Material update.

```elm
    update msg model =
        case msg of
            Mdc msg_ ->
                Material.update Mdc msg_ model

            …
```
-}
update : (Msg m -> m)
    -> Msg m
    -> { c | mdc : Model m }
    -> ( { c | mdc : Model m }, Cmd m )
update lift msg container =
  update_ lift msg (.mdc container)
      |> Tuple.mapFirst (Maybe.map (\ mdc -> { container | mdc = mdc }))
      |> Tuple.mapFirst (Maybe.withDefault container)


update_ : (Msg m -> m) -> Msg m -> Model m -> ( Maybe (Model m), Cmd m )
update_ lift msg store =
    case msg of
        Dispatch msgs ->
            (Nothing, Dispatch.forward msgs)

        ButtonMsg idx msg ->
            Button.react lift msg idx store

        CheckboxMsg idx msg ->
            Checkbox.react lift msg idx store

        DialogMsg idx msg ->
            Dialog.react lift msg idx store

        DrawerMsg idx msg ->
            Drawer.react lift msg idx store

        FabMsg idx msg ->
            Fab.react lift msg idx store

        GridListMsg idx msg ->
            GridList.react lift msg idx store

        IconToggleMsg idx msg ->
            IconToggle.react lift msg idx store

        ImageListMsg idx msg ->
            ImageList.react lift msg idx store

        MenuMsg idx msg ->
            Menu.react lift msg idx store

        RadioButtonMsg idx msg ->
            RadioButton.react lift msg idx store

        RippleMsg idx msg ->
            Ripple.react lift msg idx store

        SelectMsg idx msg ->
            Select.react lift msg idx store

        SliderMsg idx msg ->
            Slider.react lift msg idx store

        SnackbarMsg idx msg ->
            Snackbar.react lift msg idx store

        SwitchMsg idx msg ->
            Switch.react lift msg idx store

        TabsMsg idx msg ->
            Tabs.react lift msg idx store

        TextfieldMsg idx msg ->
            Textfield.react lift msg idx store

        ToolbarMsg idx msg ->
            Toolbar.react lift msg idx store

        TopAppBarMsg idx msg ->
            TopAppBar.react lift msg idx store


{-| Material subscriptions.

```elm
subscriptions model =
    Sub.batch
    [ Material.subscriptions Mdc model
    , …
    ]
```
-}
subscriptions : (Msg m -> m) -> { model | mdc : Model m } -> Sub m
subscriptions lift model =
    Sub.batch
        [ Drawer.subs lift model.mdc
        , Menu.subs lift model.mdc
        , Select.subs lift model.mdc
        ]


{-| Material init.

```elm
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
```
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
    [
      content

    , Html.node "style"
      [ Html.type_ "text/css"
      ]
      [ [ "https://fonts.googleapis.com/css?family=Roboto+Mono"
        , "https://fonts.googleapis.com/css?family=Roboto:300,400,500"
        , "https://fonts.googleapis.com/icon?family=Material+Icons"
        , "https://cdnjs.cloudflare.com/ajax/libs/normalize/7.0.0/normalize.min.css"
        , "https://aforemny.github.io/elm-mdc/material-components-web.css"
        ]
        |> List.map (\url ->
               "@import url(" ++ url ++ ");"
           )
        |> String.join "\n"
        |> text
      ]

    , Html.node "script"
      [ Html.type_ "text/javascript"
      , Html.src "https://aforemny.github.io/elm-mdc/elm-global-events.js"
      ]
      []

    , Html.node "script"
      [ Html.type_ "text/javascript"
      , Html.src "https://aforemny.github.io/elm-mdc/elm-focus-trap.js"
      ]
      []

    , Html.node "script"
      [ Html.type_ "text/javascript"
      , Html.src "https://aforemny.github.io/elm-mdc/elm-mdc.js"
      ]
      []
    ]
