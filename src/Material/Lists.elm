module Material.Lists exposing (ul)

-- TEMPLATE. Copy this to a file for your component, then update.

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#TEMPLATE-section):

> ...

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/TEMPLATE.html).

Refer to [this site](http://debois.github.io/elm-mdl#/template)
for a live demo.

@docs ul

-}


import Platform.Cmd exposing (Cmd, none)
import Html.Events as Html
import Html exposing (Html, Attribute)

import Parts exposing (Indexed)
import Material.Options as Options exposing (Property, Style, cs)

{-| Main ul constructor. Example use: 

    ul []
        [ li [  ] [  ]
        , li [  ] [  ]
        , li [  ] [  ]
        ]
-}

ul
  :  List (Property {} m)
  -> List (Html m)
  -> Html m
ul options nodes =
  let
    summary =
      Options.collect {} options
  in
    Options.apply summary Html.ul
    [ cs "mdl-list" ]
    [
    ]
    nodes