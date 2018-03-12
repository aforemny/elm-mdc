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
<script src="elm-autofocus.js"></script>
<script src="elm-focus-trap.js"></script>
<script src="elm-global-events.js"></script>
<script src="elm-mdc.js"></script>
```

You will also want to include the following resources in your `head`:

```html
<link href="https://fonts.googleapis.com/css?family=Roboto+Mono" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500" rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/normalize/7.0.0/normalize.min.css" rel="stylesheet">
<link href="material-components-web.css" rel="stylesheet">
```

## Example application

```elm
module Main exposing (..)

import Html
import Material
import Material.Button as Button
import Material.Options as Options


type alias Model
    { mdc : Material.Model
    }


defaultModel =
    { mdc = Material.defaultModel
    }


type Msg
    = Mdc (Material.Msg Msg)
    | Click


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
    Material.subscriptions Mdc


update msg model =
    case msg of
        Mdc msg_ ->
            Material.update Mdc msg_ model

        Click ->
            ( model, Cmd.none )


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
