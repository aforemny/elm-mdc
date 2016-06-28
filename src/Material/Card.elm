module Material.Card exposing
  ( Model, defaultModel, Msg, update, view
  , Property
  , render
  )

{-| From the [Material Design Lite documentation](https://getmdl.io/components/#cards-section):

> The Material Design Lite (MDL) card component is a user interface element
> representing a virtual piece of paper that contains related data — such as a
> photo, some text, and a link — that are all about a single subject.
>
> Cards are a convenient means of coherently displaying related content that is
> composed of different types of objects. They are also well-suited for presenting
> similar objects whose size or supported actions can vary considerably, like
> photos with captions of variable length. Cards have a constant width and a
> variable height, depending on their content.
>
> Cards are a fairly new feature in user interfaces, and allow users an access
> point to more complex and detailed information. Their design and use is an
> important factor in the overall user experience. See the card component's
> Material Design specifications page for details.

Refer to [this site](http://debois.github.io/elm-mdl/#/card)
for a live demo.

@docs Model, model, Msg, update
@docs view

# Component support

@docs Container, Observer, Instance, instance, fwdTemplate
-}


import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)

import Parts exposing (Indexed)
import Material.Options as Options exposing (Style, cs)


-- MODEL


{-| Component model.
-}
type alias Model =
  {
  }


{-| Default component model constructor.
-}
defaultModel : Model
defaultModel =
  {
  }


-- ACTION, UPDATE


{-| Component action.
-}
type Msg
  = MyMsg


{-| Component update.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  (model, none)


-- PROPERTIES


type alias Config =
  {
  }


defaultConfig : Config
defaultConfig =
  {
  }


type alias Property m =
  Options.Property Config m


{- See src/Material/Button.elm for an example of, e.g., an onClick handler.
-}


-- VIEW


{-| Component view.
-}
view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options elems =
  Options.div
    ( cs "TEMPLATE"
    :: options
    )
    [ h6 [] [ text "TEMPLATE COMPONENT" ]
    ]


-- COMPONENT

type alias Container c =
  { c | template : Indexed Model }


{-| Component render.
-}
render
  : (Parts.Msg (Container c) -> m)
  -> Parts.Index
  -> (Container c)
  -> List (Property m)
  -> List (Html m)
  -> Html m
render =
  Parts.create view update .template (\x y -> {y | template=x}) defaultModel

{- See src/Material/Layout.mdl for how to add subscriptions. -}
