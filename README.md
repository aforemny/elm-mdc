# Material Components for the Web for Elm

[![Build Status](https://api.travis-ci.org/aforemny/elm-mdc.svg?branch=master)](https://travis-ci.org/aforemny/elm-mdc/)

Port of Google's
[Material Components for the Web](https://material.io/components/web/)
CSS/JS implementation of the
[Material Design Specification](https://www.google.com/design/spec/material-design/introduction.html).

[Live demo](https://aforemny.github.io/elm-mdc/) &
~package documentation~ (not released on package.elm-lang.org yet, see Building
the documentation below).

The implementation is based on
[debois/elm-mdl](https://github.com/debois/elm-mdl),
which uses the now
[abandoned Material Design 2Light framework](https://github.com/google/material-design-lite).

## Getting started

Create an `index.html` that looks like this:

```html
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Getting Started</title>

  <link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500" rel="stylesheet">
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/normalize/7.0.0/normalize.min.css" rel="stylesheet">
  <link href="elm-mdc/material-components-web.css" rel="stylesheet">

</head>
<body class="mdc-typography">
  <script src="elm-mdc/elm-mdc.js"></script>
  <script src="app.js"></script>
  <div id="elm" />
    <script type="text/javascript">
      Elm.Main.init({ node: document.getElementById('elm') });
    </script>
  </div>
</body>
```

The first three lines are CSS files provided by Google. The third is
the CSS file provided by this library and contains the MDC CSS.

Put the JavaScript in the body. The first JavasSript file,
`elm-mdc.js`, is provided by this library. The second JavaScript file,
called `elm-app.js` here, is your compiled Elm application.


## Install

Assuming an empty directory, you create an elm-mdc application as follows:

1. `elm init`.
2. Install this library from github: 
```
git clone git@github.com:aforemny/elm-mdc.git
```
3. Build the required sources: 
```
cd elm-mdc
make
cd ..
```
4. Add the required libraries (see `elm-mdc/elm.json`):
```
elm install elm/regex
elm install elm/svg
elm install elm/json
elm install debois/elm-dom
```
5. Change the `source-directories` property in `elm.json` to include `elm-mdc`:

```json
    "source-directories": [
        "src",
        "elm-mdc/src"
    ],
```
6. Create an `index.html` as above.
7. Create your first application, for now let's just copy the hello world example: `cp -p elm-mdc/examples/hello-world/Main.elm src/Main.elm`
8. Compile it: `elm make src/Main.elm --output app.js`

And that's it.


## Example application

See `examples/hello-world/` for a full example. You have to run `make` in the
root repository before to create the files `elm-mdc.js` and
`material-components-web.css`.

```elm
module Main exposing (..)

import Browser
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


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
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
          Button.view Mdc "my-button" model.mdc
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

#### Building the demo on Windows

```sh
$ build.cmd build-demo
$ build/index.html
```

### Building the documentation

```sh
$ make docs
```

#### Building the documentation on Windows

```sh
$ build.cmd docs
```

## Contribute

Contributions are warmly encouraged - please
[get in touch](https://github.com/aforemny/elm-mdc/issues)! Use GitHub to
[report bugs](https://github.com/aforemny/elm-mdc/issues), too.
