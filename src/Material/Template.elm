module Material.Template
    exposing
        ( Model
        , defaultModel
        , Msg
        , update
        , view
        , Property
        , render
        )

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#TEMPLATE-section):

> ...

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/TEMPLATE.html).

Refer to [this site](http://debois.github.io/elm-mdl/#template)
for a live demo.

@docs Model, model, Msg, update
@docs view

# Component support

@docs Container, Observer, Instance, instance, fwdTemplate
-}

-- TEMPLATE. Copy this to a file for your component, then update.

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Parts exposing (Indexed)
import Material.Options as Options exposing (Style, cs)


-- MODEL


{-| Component model.
-}
type alias Model =
    {}


{-| Default component model constructor.
-}
defaultModel : Model
defaultModel =
    {}



-- ACTION, UPDATE


{-| Component action.
-}
type Msg
    = MyMsg


{-| Component update.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    ( model, none )



-- PROPERTIES


type alias Config =
    {}


defaultConfig : Config
defaultConfig =
    {}


type alias Property m =
    Options.Property Config m



{- See src/Material/Button.elm for an example of, e.g., an onClick handler.  -}
-- VIEW


{-| Component view.
-}
view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options elems =
    Options.div
        (cs "TEMPLATE"
            :: options
        )
        [ h6 [] [ text "TEMPLATE COMPONENT" ]
        ]



-- COMPONENT


type alias Container c =
    { c | template : Indexed Model }


{-| Component render.
-}
render :
    (Parts.Msg (Container c) m -> m)
    -> Parts.Index
    -> Container c
    -> List (Property m)
    -> List (Html m)
    -> Html m
render =
    Parts.create view (Parts.generalize update) .template (\x y -> { y | template = x }) defaultModel



{- See src/Material/Layout.mdl for how to add subscriptions. -}
