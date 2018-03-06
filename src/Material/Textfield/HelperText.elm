module Material.Textfield.HelperText exposing
    ( helperText
    , persistent
    , Property
    , validationMsg
    )

{-|
Helper text gives context about a field’s input, such as how the input will be
used. It should be visible either persistently or only on focus.


# Resources

- [Material Design guidelines: Text Fields Layout](https://material.io/guidelines/components/text-fields.html#text-fields-layout)
- [Demo](https://aforemny.github.io/elm-mc/#text-field)


# Example

```elm
import Material.Textfield as Textfield
import Material.Textfield.HelperText as Textfield


Html.div []
    [ Textfield.view Mdc [0] model.mdc
          [ Textfield.label "Email Adress"
          ]
          []
    , Textfield.helperText
      [ Textfield.persistent
      , Textfield.validationMsg
      ]
      [ text "Help Text (possibly validation message)"
      ]
    ]
```


# Usage

@docs Property
@docs helperText
@docs persistent
@docs validationMsg

-}


import Html exposing (Html)
import Material.Internal.Options as Internal
import Material.Options as Options exposing (cs, css, when)


type alias Config =
    { persistent : Bool
    , validationMsg : Bool
    }


defaultConfig : Config
defaultConfig =
    { persistent = False
    , validationMsg = False
    }


{-| HelperText property.
-}
type alias Property m =
    Options.Property Config m


{-| Make the helper text permanently visible.
-}
persistent : Property m
persistent =
    Internal.option (\config -> { config | persistent = True })


{-| Indicates the helper text is a validation message.
-}
validationMsg : Property m
validationMsg =
    Internal.option (\config -> { config | validationMsg = True })


{-| HelperText view.
-}
helperText : List (Property m) -> List (Html m) -> Html m
helperText options =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options
    in
    Options.styled Html.p
    (  cs "mdc-text-field-helper-text"
    :: (cs "mdc-text-field-helper-text--persistent" |> when config.persistent)
    :: (cs "mdc-text-field-helper-text--validation-msg" |> when config.validationMsg)
    :: options
    )
