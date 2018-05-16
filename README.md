# Material Components for the Web for Elm

Port of Google's
[Material Components for the Web](https://material.io/components/web/)
CSS/JS implementation of the
[Material Design Specification](https://www.google.com/design/spec/material-design/introduction.html).

[Live demo](https://aforemny.github.io/elm-mdc/) &
[package documentation](http://package.elm-lang.org/packages/aforemny/elm-mdc/latest).

The implementation is based on
[debois/elm-mdl](https://github.com/debois/elm-mdl),
which uses the now
[abandoned Material Design Light framework](https://github.com/google/material-design-lite).

## Usage

This library depends on an external JavaScript asset `elm-mdc.js` which you
have to require in your `index.html`.

You have to create it by running `make`.

The file `src/elm-mdc.js` is in ES6 JavaScript, to transpile it for use in a
Browser, run `make elm-mdc.js`.

```html
<script src="elm-mdc.js"></script>
```

You will also want to include the following resources in your `head`:

Run `make` to generate `material-components-web.css`.

```html
<link href="https://fonts.googleapis.com/css?family=Roboto+Mono" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500" rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/normalize/7.0.0/normalize.min.css" rel="stylesheet">
<link href="material-components-web.css" rel="stylesheet">
```

Your body element should have the mdc-typography class.

````
<body class="mdc-typography">
 ...
</body>
````


## Example application

See `examples/hello-world/` for a full example. You have to run `make` in the
root repository before to create the files `elm-mdc.js` and
`material-components-web.css`.

```elm
module Main exposing (..)

import Html exposing (Html, text)
import Material
import Material.Button as Button
import Material.Options as Options


type alias Model =
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
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.div []
        [
          Button.view Mdc [0] model.mdc
              [ Button.ripple
              , Options.onClick Click
              ]
              [ text "Click me!" ]
        ]
```

## Build instructions

### Building the demo
```sh
$ make build-demo
$ open build/index.html
```

## Contribute

Contributions are warmly encouraged - please
[get in touch](https://github.com/aforemny/elm-mdc/issues)! Use GitHub to
[report bugs](https://github.com/aforemny/elm-mdc/issues), too.
