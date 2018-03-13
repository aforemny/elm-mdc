module Material.Internal.Fab.Implementation exposing
    ( exited
    , mini
    , Model
    , Property
    , react
    , ripple
    , view
    )

{-|
A floating action button represents the primary action in an application.


# Resources

- [Material Design guidelines: Buttons](https://material.io/guidelines/components/buttons-floating-action-button.html)
- [Demo](https://aforemny.github.io/elm-mdc/#fab)


# Example

```elm
import Material.Fab as Fab
import Material.Options as Options


Fab.view Mdc [0] model.mdc
    [ Fab.ripple
    , Options.onClick Click
    ]
    "favorite_border"
```


# Usage
@docs Property
@docs view
@docs Property
@docs mini
@docs ripple
@docs exited


# Internal
@docs Model
@docs react
-}

import Html exposing (Html, text)
import Material.Internal.Component as Component exposing (Indexed, Index)
import Material.Internal.Fab.Model exposing (Msg(..))
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (styled, cs, css, when)
import Material.Internal.Options.Internal as Internal
import Material.Internal.Ripple.Implementation as Ripple


{-| Fab model.

Internal use only.
-}
type alias Model =
    { ripple : Ripple.Model
    }


defaultModel : Model
defaultModel =
    { ripple = Ripple.defaultModel
    }


type alias Msg =
    Material.Internal.Fab.Model.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RippleMsg msg_ ->
            let
                ( ripple, effects ) =
                    Ripple.update msg_ model.ripple
            in
            ( { model | ripple = ripple }, Cmd.map RippleMsg effects )

        NoOp ->
            ( model, Cmd.none )


type alias Config =
    { ripple : Bool
    }


defaultConfig : Config
defaultConfig =
    { ripple = False
    }


{-| Fab property.
-}
type alias Property m =
    Options.Property Config m


{-| Make the Fab smaller than regular size.
-}
mini : Property m
mini =
    cs "mdc-fab--mini"


{-| Animates the Fab out of view when this property is set.

It returns to view when this property is removed.
-}
exited : Property m
exited =
    cs "mdc-fab--exited"


{-| Enable ripple effect on interaction.
-}
ripple : Property m
ripple =
    Internal.option (\config -> { config | ripple = True })


fab : (Msg -> m) -> Model -> List (Property m) -> String -> Html m
fab lift model options icon =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        ripple =
            Ripple.view False (lift << RippleMsg) model.ripple []
    in
        Internal.apply summary
            Html.button
            [ cs "mdc-fab"
            , cs "material-icons"
            , when config.ripple << Options.many <|
              [ ripple.interactionHandler
              , ripple.properties
              ]
            ]
            []
            ( List.concat
              [ [ styled Html.span
                  [ cs "mdc-fab__icon"
                  ]
                  [ text icon
                  ]
                ]
              ,
                if config.ripple then
                    [ ripple.style ]
                else
                    []
              ]
            )


type alias Store s =
    { s | fab : Indexed Model }


( get, set ) =
    Component.indexed .fab (\x y -> { y | fab = x }) defaultModel


{-| Fab view.
-}
view :
    (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> String
    -> Html m
view =
    Component.render get fab Material.Internal.Msg.FabMsg


{-| Fab react.

Internal use only.
-}
react :
    (Material.Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Internal.Msg.FabMsg (Component.generalise update)
