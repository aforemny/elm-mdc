module Material 
  ( Model, model
  , Action, update
  )
  where

{-|

Material Design component library for Elm based on Google's
[Material Design Lite](https://www.getmdl.io/).

Click 
[here](https://debois.github.io/elm-mdl/)
for a live demo. 

# Component model 

The component model of the library is simply the Elm Architecture (TEA), i.e.,
each component has types `Model` and `Action`, and values `view` and `update`. A
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
We recommend going with the library's 
[component support](http://github.com/debois/elm-mdl/blob/master/examples/Component.elm)
rather than working directly in plain Elm Architecture.

# Component Support

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

        type Action = 
          ...
          | MDL (Material.Action Action)

 4. Handle that action in your update function as follows:

        update action model = 
          case action of 
            ...
            MDL action' -> 
              let (mdl', fx) = 
                Material.update MDL action' model.mdl 
              in 
                ( { model | mdl = mdl' } , fx )

Next, make the component instances you need. Do this in the View section of your 
source file. Let's say you need a textfield for name entry, and you'd like to
be notifed whenever the field changes value through your own NameChanged action: 

        import Material.Textfield as Textfield

        ...

        type Action = 
          ...
          | NameChanged String

        ... 

        update action model = 
          case action of 
            ...
            NameChanged name -> 
              -- Do whatever you need to do. 

        ...

        nameInput : Textfield.Instance Material.Model Action
        nameInput = 
          Textfield.instance 2 MDL Textfield.model 
            [ Textfield.fwdInput NameChanged 
            ] 
        
        view addr model = 
          ...
          nameInput.view addr model.mdl 


The win relative to using plain Elm Architecture is that adding a component
neither requires you to update your model, your Actions, nor your update function. 
(As in the above example, you will frequently have to update the latter two anyway, 
but now it's not boilerplate, its "business logic".)


## Optimising for size

Using this module will force all elm-mdl components to be built and included in 
your application. If this is unacceptable, you can custom-build a version of this
module that uses only the components you need. To do so, you need to re-implement
the present module, modifying the values `model` and `Model` by commenting out the 
components you are not using. The module source can be found
[here](https://github.com/debois/elm-mdl/blob/master/src/Material.elm).

You do not need to re-build the entire elm-mdl library; simply copy the 
source of this module, give it a new name, modify as it as indicated above,
then use your modified module rather than this one. 

@docs Model, model, Action, update
-}

import Dict 
import Effects exposing (Effects)

import Material.Button as Button
import Material.Textfield as Textfield
import Material.Snackbar as Snackbar
import Material.Component as Component exposing (Indexed)


{-| Model encompassing all Material components. Since some components store
user actions in their model (notably Snackbar), the model is generic in the 
type of such "observations". 
-}
type alias Model obs = 
  { button : Indexed Button.Model
  , textfield : Indexed Textfield.Model
  , snackbar : Maybe (Snackbar.Model obs)
  }


{-| Initial model.
-}
model : Model obs
model = 
  { button = Dict.empty
  , textfield = Dict.empty
  , snackbar = Nothing
  }


{-| Action encompassing actions of all Material components. 
-}
type alias Action obs = 
  Component.Action (Model obs) obs


{-| Update function for the above Action. 
-}
update : 
  (Action obs -> obs) 
  -> Action obs
  -> Model obs
  -> (Model obs, Effects obs)
update = 
  Component.update
