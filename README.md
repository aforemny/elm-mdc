# Material Components for the Web for Elm

Port of Google's
[Material Components for the Web](https://material.io/components/web/)
CSS/JS implementation of the
[Material Design Specification](https://www.google.com/design/spec/material-design/introduction.html).

[Live demo](https://aforemny.github.io/elm-mdc/) & [package documentation](http://package.elm-lang.org/packages/aforemny/elm-mdc/latest).

The implementation is based on [debois/elm-mdl](https://github.com/debois/elm-mdl).

## Build instructions

```sh
$ npm i
$ make
$ open build/index.html
```

## Using this library

- TODO: page.html

When using this library you have two options: each component is written as a
TEA component and exposes `view` and `update` functions as well as `init` or
`subscriptions` if necessary.

In addition to that we offer an API which is based around `render` and
`Material.Model` which aims reduce boilerplate if you have a lot of components
or complex nesting.

If you are just starting out using Elm you should use the API which follows TEA
closely. Once you feel more comfortable, we encourage you to switch to using
`render` functions and `Material.Model` as they reduce boiler-plate greatly.

### Simple TEA

Your standard TEA program looks like this:

```
module Main exposing (..)

import Html


type alias Model
    {
    }


defaultModel =
    {
    }


type Msg
    = NoOp


main =
    Html.program
    { init = init
    , subscriptions = subscriptions
    , update = update
    , view = view
    }


init =
    ( defaultModel, Cmd.none )


subscriptions model =
    Sub.none


update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view model =
    Html.div []
        [
        ]
```

Suppose you want to add a `Material.Button`, your example extends to this:

```
module Main exposing (..)

import Html
import Material.Button as Button


type alias Model
    { myButton : Button.Model
    }


defaultModel =
    { myButton = Button.defaultModel
    }


type Msg
    = NoOp
    | MyButtonMsg Button.Msg


main =
    Html.program
    { init = init
    , subscriptions = subscriptions
    , update = update
    , view = view
    }


init =
    ( defaultModel, Cmd.none )


subscriptions model =
    Sub.none


update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        MyButtonMsg msg_ ->
            let
                ( myButton, effects ) =
                    Button.update msg_ model.myButton
            in
                ( { model | myButton = myButton }, Cmd.map MyButtonMsg effects )


view model =
    Html.div []
        [
          Button.view MyButtonMsg
              []
              [ text "Click me!" ]
        ]
```

### Featured render

Note that in our Simple TEA example the changes to `Model`, `update` and `view`
will have to be performed for each other button you add.

The render API is designed to mitigate this problem by maintaining a store of
components `Material.Model` and by using numeric indices to reference
components.

The standard TEA program would become the following:

```
module Main exposing (..)

import Html
import Material.Button as Button


type alias Model
    { model : Material.Model
    }


defaultModel =
    { model = Material.defaultModel
    }


type Msg
    = NoOp
    | MaterialMsg (Material.Msg Msg)


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

        MaterialMsg msg_ ->
            Material.update Mdl msg_ model


view model =
    Html.div []
        [
          Button.render Mdl [0] model.mdl
              []
              [ text "Click me!" ]
        ]
```

Note that in this example, when adding another Button you do not have to touch
`Model`, `Msg` or `update` again. Your view simply becomes:


```
view model =
    Html.div []
        [
          Button.render Mdl [0] model.mdl
              []
              [ text "Click me!" ]

        , Button.render Mdl [1] model.mdl
              []
              [ text "Click me!" ]
        ]
```


## Contribute

Contributions are warmly encouraged - please [get in touch](TODO)! Use GitHub to
[report bugs](TODO), too.
