module Demo.Buttons where

import Html exposing (..)
import Html.Attributes exposing (..)
import String

import Material.Button as Button exposing (..)
import Material.Grid as Grid
import Material.Icon as Icon
import Material.Options as Options exposing (Style)
import Material

import Demo.Page as Page


-- MODEL


type alias Model = 
  Material.Model


model = 
  Material.model


-- ACTION/UPDATE


type Action = 
  Mdl (Material.Action Action)


update (Mdl action) = 
  Material.update Mdl action


-- VIEW


ripple = 
  [ ("", [])
  , ("w/ripple", [Button.ripple])
  , ("disabled", [Button.disabled])
  ]


colors = 
  [ ("plain", [])
  , ("colored", [Button.colored])
--  , ("primary", [Button.primary])
--  , ("accent", [Button.accent]) 
  ]


kinds = 
  [ ("flat", text "Flat Button", Button.flat)
  , ("raised", text "Raised Button", Button.raised)
  , ("FAB", Icon.i "add", Button.fab)
  , ("mini-FAB", Icon.i "zoom_in", Button.minifab)
  , ("icon", Icon.i "flight_land", Button.icon)
  ]



-- VIEW


indexedConcat : (Int -> a -> List b) -> List a -> List b
indexedConcat f xs = 
  List.indexedMap f xs
    |> List.concat


view : Signal.Address Action -> Model -> Html
view addr model =
  kinds |> indexedConcat (\idx0 (txt0, contents, opt0) -> 
  colors |> indexedConcat (\idx1 (txt1, opt1) -> 
  ripple |> indexedConcat (\idx2 (txt2, opt2) -> 
    [ Grid.cell
      [ Grid.size Grid.All 4]
      [ div
          [ style
            [ ("text-align", "center")
            , ("margin-top", ".6em")
            , ("margin-bottom", ".6em")
            ]
          ]
          [ Button.render Mdl [idx0, idx1, idx2] addr model
              [ opt0
              , Options.many opt1
              , Options.many opt2
              ]
              [ contents ]
          , div
              [ style
                [ ("font-size", "9pt")
                , ("margin-top", ".6em")
                ]
              ]
              [ text <| String.join " " [ txt0, txt1, txt2 ] 
              ]
          ]
      ]
    ]
  )))
  |> Grid.grid [] 
  |> flip (::) 
      [ p [] 
         [ text """Various combinations of colors and button styles can be seen
                   below. Most buttons have animations; try clicking."""
         ]
      ] 
  |> List.reverse
  |> Page.body2 "Buttons" srcUrl intro references

intro : Html
intro =
  Page.fromMDL "https://www.getmdl.io/components/#buttons-section" """
> The Material Design Lite (MDL) button component is an enhanced version of the
> standard HTML `<button>` element. A button consists of text and/or an image that
> clearly communicates what action will occur when the user clicks or touches it.
> The MDL button component provides various types of buttons, and allows you to
> add both display and click effects.
>
> Buttons are a ubiquitous feature of most user interfaces, regardless of a
> site's content or function. Their design and use is therefore an important
> factor in the overall user experience. See the button component's Material
> Design specifications page for details.
>
> The available button display types are flat (default), raised, fab, mini-fab,
> and icon; any of these types may be plain (light gray) or colored, and may be
> initially or programmatically disabled. The fab, mini-fab, and icon button
> types typically use a small image as their caption rather than text.

"""

srcUrl : String
srcUrl = 
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Buttons.elm"

references : List (String, String)
references = 
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Button"
  , Page.mds "https://www.google.com/design/spec/components/buttons.html"
  , Page.mdl "https://www.getmdl.io/components/#buttons-section"
  ]

