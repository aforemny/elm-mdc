module Demo.Buttons where

import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Effects

import Material.Button as Button exposing (..)
import Material.Grid as Grid
import Material.Icon as Icon
import Material.Style exposing (Style)

import Demo.Page as Page


-- MODEL


type alias Index = (Int, Int)


type alias View =
  Signal.Address Button.Action -> Button.Model -> List Style -> List Html -> Html


type alias View' =
  Signal.Address Button.Action -> Button.Model -> Html


view' : View -> List Style -> Html -> Signal.Address Button.Action -> Button.Model -> Html
view' view coloring elem addr model =
  view addr model coloring [elem]


describe : String -> Bool -> String -> String
describe kind ripple c =
    kind ++ ", " ++ c ++ if ripple then " w/ripple" else ""


row : (String, Html, View) -> Bool -> List (Int, (Bool, String, View'))
row (kind, elem, v) ripple =
  [ ("plain", [])
  , ("colored", [Button.colored])
  , ("primary", [Button.primary])
  , ("accent", [Button.accent]) 
  ]
  |> List.map (\(d,c) -> (ripple, describe kind ripple d, view' v c elem))
  |> List.indexedMap (,)


buttons : List (List (Index, (Bool, String, View')))
buttons =
  [ ("flat", text "Flat Button", Button.flat)
  , ("raised", text "Raised Button", Button.raised)
  , ("FAB", Icon.i "add", Button.fab)
  , ("mini-FAB", Icon.i "zoom_in", Button.minifab)
  , ("icon", Icon.i "flight_land", Button.icon)
  ]
  |> List.concatMap (\a -> [row a False, row a True])
  |> List.indexedMap (\i r -> List.map (\(j, x) -> ((i,j), x)) r)


model : Model
model =
  { clicked = ""
  , buttons =
      buttons
      |> List.concatMap (List.map <| \(idx, (ripple, _, _)) -> (idx, Button.model ripple))
      |> Dict.fromList
  }


-- ACTION, UPDATE


type Action 
  = Action Index Button.Action


type alias Model =
  { clicked : String
  , buttons : Dict.Dict Index Button.Model
  }


update : Action -> Model -> (Model, Effects.Effects Action)
update action model = 
  case action of 
    Action idx action -> 
      Dict.get idx model.buttons
      |> Maybe.map (\m0 ->
        let
          (m1, e) = Button.update action m0
        in
          ({ model | buttons = Dict.insert idx  m1 model.buttons }, Effects.map (Action idx) e)
      )
      |> Maybe.withDefault (model, Effects.none)


-- VIEW



view : Signal.Address Action -> Model -> Html
view addr model =
  buttons |> List.concatMap (\row ->
    row |> List.concatMap (\(idx, (ripple, description, view)) ->
      let model' =
        Dict.get idx model.buttons |> Maybe.withDefault (Button.model False)
      in
        [ Grid.cell
          [ Grid.size Grid.All 3]
          [ div
              [ style
                [ ("text-align", "center")
                , ("margin-top", ".6em")
                , ("margin-bottom", ".6em")
                ]
              ]
              [ view
                  (Signal.forwardTo addr (Action idx))
                  model'
              , div
                  [ style
                    [ ("font-size", "9pt")
                    , ("margin-top", ".6em")
                    ]
                  ]
                  [ text description
                  ]
              ]
          ]
        ]
    )
  )
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

