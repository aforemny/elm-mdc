module Material.Scheme
    exposing
        ( topWithScheme
        , top
        )

{-|
The elm-mdl library depends on Google's MDL CSS implementation, and your
application must load this CSS in order for elm-mdl to function correctly.
There are two ways to accomplish this:

1. Load CSS from HTML by adding suitable `<link ...>` directives to the
HTML-file containing your app, or
2. Load CSS from Elm (by inserting `style` elements into the DOM).


# Load CSS from HTML

To load CSS manually, add the following to your main html file.

    <!-- MDL -->
    <link href='https://fonts.googleapis.com/css?family=Roboto:400,300,500|Roboto+Mono|Roboto+Condensed:400,700&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://code.getmdl.io/1.3.0/material.min.css" />

You may find the [elm-mdl demo's
html](https://github.com/debois/elm-mdl/blob/master/demo/page.html) helpful.

# Loading CSS from Elm

@docs topWithScheme, top
-}

import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Color exposing (Hue(..), Color)


scheme : Hue -> Hue -> String
scheme primary accent =
    [ "https://code.getmdl.io/1.3.0/" ++ Material.Color.scheme primary accent
    , "https://fonts.googleapis.com/icon?family=Material+Icons"
    , "https://fonts.googleapis.com/css?family=Roboto:400,300,500|Roboto+Mono|Roboto+Condensed:400,700&subset=latin,latin-ext"
    ]
        |> List.map (\url -> "@import url(" ++ url ++ ");")
        |> String.join "\n"


{-| Top-level container for Material components. This will force loading of
Material Design Lite CSS files by inserting an appropriate `style` element.

Supply primary and accent colors as parameters. Refer to the Material Design
Lite [Custom CSS theme builder](https://www.getmdl.io/customize/index.html)
to preview combinations.  Please be aware that Grey, Blue Grey, and Brown
cannot be secondary colors. If you choose them as such anyway, you will get the
default theme.

**NB!** Using this top-level container is not recommended, as most browsers
will load CSS requested from `style` elements concurrently with rendering the
initial page, which will produce a flicker on page load. The container is
included only to provide an option to get started quickly and for use with
elm-reactor.

Example use:

    view : Model -> Html Msg
    view =
      div
        []
        [ Scheme.topWithScheme Color.Teal Color.Red contents
        , ...
        ]
-}
topWithScheme : Hue -> Hue -> Html a -> Html a
topWithScheme primary accent content =
    div [] <|
        {- Trick from Peter Damoc to load CSS outside of <head>.
           https://github.com/pdamoc/elm-mdl/blob/master/src/Mdl.elm#L63
        -}
        [ node "style"
            [ type_ "text/css" ]
            [ Html.text <| scheme primary accent ]
        , content
        ]


{-| Top-level container with default color scheme. See `topWithScheme` above.
-}
top : Html a -> Html a
top content =
    -- Force default color-scheme by picking an invalid combination.
    topWithScheme Grey Grey content
