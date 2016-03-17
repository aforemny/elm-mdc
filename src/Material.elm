module Material
  ( topWithColors, top
  , Updater', Updater, lift, lift'
  ) where

{-| Material Design component library for Elm based on Google's
[Material Design Lite](https://www.getmdl.io/).

# Loading CSS
@docs topWithColors, top

# Component convienience
@docs Updater', Updater, lift', lift
-}


import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Effects exposing (..)

import Material.Color exposing (..)


css : Color -> Color -> String
css primary accent =
  let cssFile =
    case accent of
      Grey -> ""
      Brown -> ""
      BlueGrey -> ""
      Primary -> ""
      Accent -> ""
      _ -> "." ++ cssName primary ++ "-" ++ cssName accent
  in
    [ "https://code.getmdl.io/1.1.1/material" ++ cssFile ++ ".min.css"
    , "https://fonts.googleapis.com/icon?family=Material+Icons"
    , "https://fonts.googleapis.com/css?family=Roboto:400,300,500|Roboto+Mono|Roboto+Condensed:400,700&subset=latin,latin-ext"
    ]
    |> List.map (\url -> "@import url(" ++ url ++ ");")
    |> String.join "\n"



{-| Top-level container for Material components. This will force loading of
Material Design Lite CSS files. Any component you use must be contained
in this container, OR you must manually add something like the following to
your .html file:

    <!-- MDL -->
    <link href='https://fonts.googleapis.com/css?family=Roboto:400,300,500|Roboto+Mono|Roboto+Condensed:400,700&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://code.getmdl.io/1.1.1/material.min.css" />

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
topWithColors : Color -> Color -> Html -> Html
topWithColors primary accent content =
  div [] <|
  {- Trick from Peter Damoc to load CSS outside of <head>.
     https://github.com/pdamoc/elm-mdl/blob/master/src/Mdl.elm#L63
   -}
  [ node "style"
    [ type' "text/css"]
    [ text <| css primary accent]
  , content
  ]


{-| Top-level container with default color scheme.
-}
top : Html -> Html
top content =
  -- Force default color-scheme by picking an invalid combination.
  topWithColors Grey Grey content




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
