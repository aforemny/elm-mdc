module Material
  ( topWithScheme, top
  , Updater', Updater, lift, lift'
  ) where

{-| Material Design component library for Elm based on Google's
[Material Design Lite](https://www.getmdl.io/).

This module contains only initial CSS setup and convenience function for alleviating
the pain of the missing component architecture in Elm. 

# Loading CSS
@docs topWithScheme, top

# Component convienience
@docs Updater', Updater, lift', lift
-}


import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Effects exposing (..)

import Material.Color exposing (Palette(..), Color)


scheme : Palette -> Palette -> String
scheme primary accent =
  [ "https://code.getmdl.io/1.1.2/" ++ Material.Color.scheme primary accent 
  , "https://fonts.googleapis.com/icon?family=Material+Icons"
  , "https://fonts.googleapis.com/css?family=Roboto:400,300,500|Roboto+Mono|Roboto+Condensed:400,700&subset=latin,latin-ext"
  ]
  |> List.map (\url -> "@import url(" ++ url ++ ");")
  |> String.join "\n"



{-| Top-level container for Material components. This will force loading of
Material Design Lite CSS files Any component you use must be contained
in this container, OR you must manually add something like the following to
your .html file:

    <!-- MDL -->
    <link href='https://fonts.googleapis.com/css?family=Roboto:400,300,500|Roboto+Mono|Roboto+Condensed:400,700&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://code.getmdl.io/1.1.3/material.min.css" />

Supply primary and accent colors as parameters. Refer to the
Material Design Lite [Custom CSS theme builder](https://www.getmdl.io/customize/index.html)
to preview combinations.

Please be aware that Grey, Blue Grey, and Brown cannot be secondary colors. If
you choose them as such anyway, you will get the default theme.

Using this top-level container is not recommended, as most browsers will load
css concurrently with rendering the initial page, which will produce a flicker
on page load. The container is included only to provide an option to get started
quickly and for use with elm-reactor.

-}
topWithScheme: Palette -> Palette -> Html -> Html
topWithScheme primary accent content =
  div [] <|
  {- Trick from Peter Damoc to load CSS outside of <head>.
     https://github.com/pdamoc/elm-mdl/blob/master/src/Mdl.elm#L63
   -}
  [ node "style"
    [ type' "text/css"]
    [ Html.text <| scheme primary accent]
  , content
  ]


{-| Top-level container with default color scheme.
-}
top : Html -> Html
top content =
  -- Force default color-scheme by picking an invalid combination.
  topWithScheme Grey Grey content



{-| TODO.
-}
type alias Updater' action model =
  action -> model -> model


{-| TODO.
-}
type alias Updater action model =
  action -> model -> (model, Effects action)

type alias ComponentModel model components =
  { model | components : components }


{-| TODO.
-}
lift' :
  (model -> submodel) ->                                      -- get
  (model -> submodel -> model) ->                             -- set
  Updater' subaction submodel ->                               -- update
  subaction ->                                                -- action
  model ->                                                    -- model
  (model, Effects action)
lift' get set update action model =
  (set model (update action (get model)), Effects.none)


{-| TODO.
-}
lift :
  (model -> submodel) ->                                      -- get
  (model -> submodel -> model) ->                             -- set
  (subaction -> action) ->                                    -- fwd
  Updater subaction submodel ->                               -- update
  subaction ->                                                -- action
  model ->                                                    -- model
  (model, Effects action)
lift get set fwd update action model =
  let
    (submodel', e) = update action (get model)
  in
    (set model submodel', Effects.map fwd e)
