# Material Components for the Web for Elm

Port of Google's
[Material Components for the Web](https://material.io/components/web/)
CSS/JS implementation of the
[Material Design Specification](https://www.google.com/design/spec/material-design/introduction.html).

[Live demo](https://aforemny.github.io/elm-mdc/) & [package documentation](http://package.elm-lang.org/packages/aforemny/elm-mdc/latest).

The implementation is based on [debois/elm-mdl](https://github.com/debois/elm-mdl).

## Usage

Currently you will have to add the following scripts to your `index.html`
before including `elm.js`.

```html
<script src="elm-focus-trap.js"></script>
<script src="elm-global-events.js"></script>
<script src="elm-mdc.js"></script>
```

You will also want to include the following resources in your `head`:

```html
<link href="https://fonts.googleapis.com/css?family=Roboto+Mono" rel="stylesheet">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/7.0.0/normalize.min.css">
<link rel="stylesheet" href="material-components-web.css">
```

## Example application

```elm
module Main exposing (..)

import Html
import Material.Button as Button


type alias Model
    { mdl : Material.Model
    }


defaultModel =
    { mdl = Material.defaultModel
    }


type Msg
    = Mdl (Material.Msg Msg)


main =
    Html.program
    { init = init
    , subscriptions = subscriptions
    , update = update
    , view = view
    }


init =
    ( defaultModel, Material.init )


subscriptions model =
    Material.subscriptions Mdl


update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


view model =
    Html.div []
        [
          Button.render Mdl [0] model.mdl
              []
              [ text "Click me!" ]
        ]
```

## Build instructions

### Building the demo
```sh
$ make setup
$ make build-demo
$ open build/index.html
```

## Contribute

Contributions are warmly encouraged - please [get in touch](TODO)! Use GitHub to
[report bugs](TODO), too.
