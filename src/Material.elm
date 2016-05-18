module Material exposing 
  ( Model, model
  , Msg, update
  )

{-|

Material Design component library for Elm based on Google's
[Material Design Lite](https://www.getmdl.io/).

Click 
[here](https://debois.github.io/elm-mdl/)
for a live demo. 

# Component model 

The component model of the library is simply the Elm Architecture (TEA), i.e.,
each component has types `Model` and `Msg`, and values `view` and `update`. A
minimal example using this library in plain TEA can be found
  [here](https://github.com/debois/elm-mdl/blob/master/examples/Component-TEA.elm).

Using more than a few component in plain TEA is  unwieldy because of the large
amount of boilerplate one has to write. This library provides the "component 
support" for getting rid of most of that boilerplate. A minimal example using
component support is
[here](http://github.com/debois/elm-mdl/blob/master/examples/Component.elm).

It is important to note that component support lives __within__ TEA; 
it is not an alternative architecture. 

# Getting started

The easiest way to get started is to start with one of the minimal examples above.
We recommend going with the one that uses 
[the one that uses](http://github.com/debois/elm-mdl/blob/master/examples/Component.elm)
the library's component support rather than working directly in plain Elm
Architecture.

# Interfacing with CSS

This library depends on the CSS part of Google's Material Design Lite. Your app
will have to load that. See the
[Scheme](http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Scheme)
module for exposing details. (The starting point implementations above
load CSS automatically.)

The view function of most components has this signature: 

    view : Signal.Address -> Model -> List Style -> Html 

The address is standard, and `Model` is just the model type of the component. 
The third argument, `List Style`, is a mechanism for you to specify additional
classes and CSS for the component. You need this, e.g., when you want to
specify the width of a button. See the
[Style](http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Style)
module for exposing details. 

Material Design defines a color palette. The 
[Color](http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Color)
module contains exposing various `Style` values and helper functions for working with
this color palette.



# Component Support

TODO

This module contains only convenience functions for working with nested 
components in the Elm architecture. A minimal example using this library
with component support can be found 
[here](http://github.com/debois/elm-mdl/blob/master/examples/Component.elm).
We encourage you to use the library in this fashion.

All examples in this subsection is from the 
[above minimal example](http://github.com/debois/elm-mdl/blob/master/examples/Component.elm)

Here is how you use component support in general.  First, boilerplate. 

 1. Include `Material`:

    <!-- MDL -->
    <link href='https://fonts.googleapis.com/css?family=Roboto:400,300,500|Roboto+Mono|Roboto+Condensed:400,700&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://code.getmdl.io/1.1.3/material.min.css" />

 2. Add a model container Material components to your model:

        type alias Model = 
          { ...
          , mdl : Material.Model    
          }

        model : Model = 
          { ...
          , mdl = Material.model
          }

 3. Add an action for Material components. 

        type Msg = 
          ...
          | Mdl (Material.Msg Msg)

 4. Handle that action in your update function as follows:

        update action model = 
          case action of 
            ...
            Mdl action' -> 
              Material.update Mdl action' model

Next, make the component instances you need. Do this in the View section of your 
source file. Let's say you need a textfield for name entry, and you'd like to
be notifed whenever the field changes value through your own NameChanged action: 

        import Material.Textfield as Textfield

        ...

        type Msg = 
          ...
          | NameChanged String

        ... 

        update action model = 
          case action of 
            ...
            NameChanged name -> 
              -- Do whatever you need to do. 

        ...

        nameInput : Textfield.Instance Material.Model Msg
        nameInput = 
          Textfield.instance 2 MDL Textfield.model 
            [ Textfield.fwdInput NameChanged 
            ] 
        
        view addr model = 
          ...
          nameInput.view addr model.mdl 


The win relative to using plain Elm Architecture is that adding a component
neither requires you to update your model, your Msgs, nor your update function. 
(As in the above example, you will frequently have to update the latter two anyway, 
but now it's not boilerplate, its "business logic".)


## Optimising for size

Using this module will force all elm-mdl components to be built and included in 
your application. If this is unacceptable, you can custom-build a version of this
module that exposing uses only the components you need. To do so, you need to provide your
own versions of the type `Model` and the value `model` of the present module. 
Use the corresponding definitions in this module as a starting point 
([source](https://github.com/debois/elm-mdl/blob/master/src/Material.elm)) 
and simply comment out the components you do not need. 

@docs Model, model, Msg, update
-}

import Dict 
import Platform.Cmd exposing (Cmd)

import Material.Button as Button
import Material.Textfield as Textfield
import Material.Menu as Menu
import Material.Snackbar as Snackbar
import Material.Layout as Layout
--import Material.Toggles as Toggles
import Material.Helpers exposing (map1st)
import Parts exposing (Indexed)

--import Material.Template as Template

{-| Model encompassing all Material components. Since some components store
user actions in their model (notably Snackbar), the model is generic in the 
type of such "observations". 
-}
type alias Model = 
  { button : Indexed Button.Model
  , textfield : Indexed Textfield.Model
  , menu : Indexed Menu.Model
  , snackbar : Maybe (Snackbar.Model Int) 
  , layout : Layout.Model
--  , toggles : Indexed Toggles.Model
--  , template : Indexed Template.Model
  }


{-| Initial model.
-}
model : Model
model = 
  { button = Dict.empty
  , textfield = Dict.empty
  , menu = Dict.empty
  , snackbar = Nothing
  , layout = Layout.defaultModel
--  , toggles = Dict.empty
--, template = Dict.empty
  }


{-| Msg encompassing actions of all Material components. 
-}
type alias Msg = 
  Parts.Msg Model 


{-| Update function for the above Msg. Provide as the first 
argument a lifting function that embeds the generic MDL action in 
your own Msg type. 
-}
update : 
  (Msg -> obs) 
  -> Msg 
  -> { model | mdl : Model }
  -> ({ model | mdl : Model }, Cmd obs)
update lift action model = 
  Parts.update lift action model.mdl 
    |> map1st (\mdl -> { model | mdl = mdl })

