module Material.Button exposing
    ( compact
    , dense
    , disabled
    , icon
    , link
    , Model
    , Property
    , raised
    , react
    , ripple
    , stroked
    , unelevated
    , view
    )

{-|
The MDC Button component is a spec-aligned button component adhering to the
Material Design button requirements.


# Resources

- [Material Design guidelines: Buttons](https://material.io/guidelines/components/buttons.html)
- [Demo](https://aforemny.github.io/elm-mdc/#buttons)


# Example

```elm
import Html exposing (text)
import Material.Button as Button
import Material.Options as Options


Button.view Mdc [0] model.mdc
    [ Button.ripple
    , Options.onClick Click
    ]
    [ text "Button"
    ]
```


# Usage

@docs Property
@docs view
@docs ripple
@docs raised
@docs unelevated
@docs stroked
@docs dense
@docs compact
@docs icon
@docs disabled
@docs link


# Internal

@docs Model
@docs react
-}

import Html.Attributes as Html
import Html exposing (Html, text)
import Material.Component as Component exposing (Indexed, Index)
import Material.Helpers as Helpers
import Material.Icon as Icon
import Material.Internal.Button exposing (Msg(..))
import Material.Internal.Options as Internal
import Material.Msg
import Material.Options as Options exposing (cs, css, when)
import Material.Ripple as Ripple


{-| Button model.

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
    Material.Internal.Button.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RippleMsg msg_ ->
            let
                ( ripple, effects ) =
                    Ripple.update msg_ model.ripple
            in
            ( { model | ripple = ripple }, Cmd.map RippleMsg effects )


type alias Config =
    { ripple : Bool
    , link : Maybe String
    , disabled : Bool
    , icon : Maybe String
    }


defaultConfig : Config
defaultConfig =
    { ripple = False
    , link = Nothing
    , disabled = False
    , icon = Nothing
    }


{-| Button property.
-}
type alias Property m =
    Options.Property Config m


{-| Give the button an icon.
-}
icon : String -> Property m
icon str =
    Internal.option (\ config -> { config | icon = Just str })


{-| Make the  button elevated upon the surface.
-}
raised : Property m
raised =
    cs "mdc-button--raised"


{-| Make the button flush with the surface.
-}
unelevated : Property m
unelevated =
    cs "mdc-button--unelevated"


{-| Make the button flush with the surface, but have a visible border.
-}
stroked : Property m
stroked =
    cs "mdc-button--stroked"


{-| Make button's text slightly smaller.
-}
dense : Property m
dense =
    cs "mdc-button--dense"


{-| Reduce the amount of horizontal padding in the button.
-}
compact : Property m
compact =
    cs "mdc-button--compact"


{-| Enable ripple ink effect for the button.
-}
ripple : Property m
ripple =
    Internal.option (\options -> { options | ripple = True })


{-| Make the button be an anchor tag instead of a div.
-}
link : String -> Property m
link href =
    Internal.option (\options -> { options | link = Just href })


{-| Disable the button.
-}
disabled : Property m
disabled =
    Internal.option (\options -> { options | disabled = True })


button : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
button lift model options nodes =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        ripple =
            Ripple.view False (lift << RippleMsg) model.ripple []
    in
        Internal.apply summary
            (if config.link /= Nothing then Html.a else Html.button)
            [ cs "mdc-button"
            , cs "mdc-js-button"
            , cs "mdc-js-ripple-effect" |> when summary.config.ripple
            , css "box-sizing" "border-box"
            , Internal.attribute (Html.href (Maybe.withDefault "" config.link) )
                |> when ((config.link /= Nothing) && not config.disabled)
            , Internal.attribute (Html.disabled True)
                |> when config.disabled
            , cs "mdc-button--disabled"
                |> when config.disabled
            , when config.ripple << Options.many <|
              [ ripple.interactionHandler
              , ripple.properties
              ]
            ]
            [ Helpers.blurOn "mouseup"
            , Helpers.blurOn "mouseleave"
            , Helpers.blurOn "touchend"
            ]
            ( List.concat
              [
                config.icon
                |> Maybe.map (\ icon ->
                     [ Icon.view [ cs "mdc-button__icon" ] icon
                     ]
                   )
                |> Maybe.withDefault []
              ,
                nodes
              ,
                [ ripple.style
                ]
              ]
            )


type alias Store s =
    { s | button : Indexed Model }


( get, set ) =
    Component.indexed .button (\x y -> { y | button = x }) defaultModel


{-| Button view.
-}
view :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render get button Material.Msg.ButtonMsg


{-| Button react.

Internal use only.
-}
react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.ButtonMsg (Component.generalise update)
