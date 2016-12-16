module Material.Elevation
    exposing
        ( shadow
        , transition
        )

{-| From the [Material Design Lite documentation](https://github.com/google/material-design-lite/blob/master/src/shadow/README.md)

> The Material Design Lite (MDL) shadow is not a component in the same sense as
> an MDL card, menu, or textbox; it is a visual effect that can be assigned to a
> user interface element. The effect simulates a three-dimensional positioning of
> the element, as though it is slightly raised above the surface it rests upon —
> a positive z-axis value, in user interface terms. The shadow starts at the
> edges of the element and gradually fades outward, providing a realistic 3-D
> effect.
>
> Shadows are a convenient and intuitive means of distinguishing an element from
> its surroundings. A shadow can draw the user's eye to an object and emphasize
> the object's importance, uniqueness, or immediacy.
>
> Shadows are a well-established feature in user interfaces, and provide users
> with a visual clue to an object's intended use or value. Their design and use
> is an important factor in the overall user experience.)

See also the
[Material Design specification](https://www.google.com/design/spec/what-is-material/elevation-shadows.html)
.

# Component
@docs shadow, transition

# View
@docs view

-}

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)


-- MODEL


{-| Component model.
-}
type alias Model =
    {}


{-| Default component model constructor.
-}
model : Model
model =
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



-- VIEW


{-| Component view.
-}
view : Signal.Address Msg -> Model -> Html
view addr model =
    div [] [ h1 [] [ text "TEMPLATE" ] ]
