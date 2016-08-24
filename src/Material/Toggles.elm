module Material.Toggles exposing 
  ( Model, defaultModel
  , Msg, update
  , viewSwitch, viewCheckbox, viewRadio
  , switch, checkbox, radio
  , onClick, ripple, disabled, value, group
  )

{-| From the [Material Design Lite documentation](http://www.getmdl.io/index.html#toggles-section/checkbox):

> The Material Design Lite (MDL) checkbox component is an enhanced version of the
> standard HTML `<input type="checkbox">` element. A checkbox consists of a small
> square and, typically, text that clearly communicates a binary condition that
> will be set or unset when the user clicks or touches it. Checkboxes typically,
> but not necessarily, appear in groups, and can be selected and deselected
> individually. The MDL checkbox component allows you to add display and click
>     effects.
> 
> Checkboxes are a common feature of most user interfaces, regardless of a site's
> content or function. Their design and use is therefore an important factor in
> the overall user experience. [...]
> 
> The enhanced checkbox component has a more vivid visual look than a standard
> checkbox, and may be initially or programmatically disabled.

See also the
[Material Design Specification](https://www.google.com/design/spec/components/selection-controls.html#).

Refer to [this site](http://debois.github.io/elm-mdl/#toggles)
for a live demo.

# Render
@docs checkbox, switch, radio

# Options
@docs onClick, ripple, disabled, value, group

# Elm architecture
@docs Model, defaultModel, Msg, update
@docs viewSwitch, viewCheckbox, viewRadio

-}


import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.App
import Html.Attributes exposing (type', class, disabled, checked)
import Html.Events exposing (on, onFocus, onBlur)
import Json.Decode as Json

import Parts exposing (Indexed)

import Material.Options as Options exposing (Style, cs, styled, many, when, maybe)
import Material.Helpers exposing (map1st, map2nd, blurOn, filter, noAttr)
import Material.Ripple as Ripple



-- MODEL


{-| Component model.
-}
type alias Model = 
  { ripple : Ripple.Model
  , isFocused : Bool 
  }


{-| Default component model.
-}
defaultModel : Model
defaultModel = 
  { ripple = Ripple.model
  , isFocused = False
  }


-- ACTION, UPDATE


{-| Component action.
-}
type Msg
  = Ripple Ripple.Msg
  | SetFocus Bool


{-| Component update.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of 
    Ripple rip -> 
      Ripple.update rip model.ripple
        |> map1st (\r -> { model | ripple = r })
        |> map2nd (Cmd.map Ripple)

    SetFocus focus -> 
      ( { model | isFocused = focus }, none )
      


-- VIEW


type alias Config m =
  { isDisabled : Bool
  , value : Bool
  , ripple : Bool
  , group : Maybe (Attribute m)
  , onClick : Maybe (Attribute m)
  , inner : List (Options.Style m)
  }


defaultConfig : Config m
defaultConfig =
  { isDisabled = False
  , value = False
  , ripple = False
  , group = Nothing
  , onClick = Nothing
  , inner = []
  }


{-| Properties for Button options.
-}
type alias Property m = 
  Options.Property (Config m) m


{-| Add an `on "click"` handler to a toggle. Argument is the 
new value of the toggle (that is, the negation of the current value).
-}
onClick : m -> Property m
onClick x =
  Options.set
    (\options -> { options | onClick = Just (Html.Events.on "change" (Json.succeed x)) })


{-| Set toggle to ripple when clicked.
-}
ripple : Property m 
ripple = 
  Options.set
    (\options -> { options | ripple = True })


{-| Set toggle to "disabled".
-}
disabled : Property m
disabled = 
  Options.set
    (\options -> { options | isDisabled = True })


{-| Set toggle value
-}
value : Bool -> Property m
value b = 
  Options.set
    (\options -> { options | value = b })


{-| Set radio-button group id. Only one button in the same group can be checked
at a time. 
-}
group : String -> Property m
group s = 
  Options.set
    (\options -> { options | group = Just (Html.Attributes.name s) })



top : (Msg -> m) -> String -> Model -> Options.Summary (Config m) m -> List (Html m) -> Html m
top lift group model summary elems =
  let 
    cfg = summary.config
  in
    Options.apply summary label
      [ cs ("mdl-" ++ group) 
      , cs ("mdl-js-" ++ group)
      , cs "mdl-js-ripple-effect" `when` cfg.ripple
      , cs "mdl-js-ripple-effect--ignore-events" `when` cfg.ripple
      , cs "is-upgraded"
      , cs "is-checked" `when` cfg.value
      , cs "is-focused" `when` model.isFocused
      ]
      [ blurOn "mouseup"
      , onFocus (lift (SetFocus True))
      , onBlur (lift (SetFocus False))
      , cfg.onClick |> Maybe.withDefault noAttr
      ] 
      (List.concat 
        [ elems
        , if cfg.ripple then 
            [ Html.App.map (Ripple >> lift) <| Ripple.view 
               [ class "mdl-switch__ripple-container mdl-js-ripple-effect mdl-ripple--center" ]
               model.ripple
            ]
          else 
            []
        ]) 



{-| Component view (checkbox).
-}
viewCheckbox : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
viewCheckbox lift model config elems = 
  let 
    summary = Options.collect defaultConfig config
    cfg = summary.config
  in 
    [ Options.styled' Html.input
      [ cs "mdl-checkbox__input"
      , Options.many cfg.inner
      ]
      [ type' "checkbox"
      , Html.Attributes.disabled cfg.isDisabled
      , checked cfg.value 
        {- The checked attribute is not rendered. Switch still seems to
        work, though, but accessibility is probably compromised. 
        https://github.com/evancz/elm-html/issues/91
        -}
      ]
      []
    , span [ class ("mdl-checkbox__label") ] elems 
    , span [ class "mdl-checkbox__focus-helper" ] [] 
    , span 
        [ class "mdl-checkbox__box-outline" ]
        [ span 
            [ class "mdl-checkbox__tick-outline" ]
            []
        ]
    ]
    |> top lift "checkbox" model summary


{-| Component view (switch)
-}
viewSwitch : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
viewSwitch lift model config elems =
  let 
    summary = Options.collect defaultConfig config
    cfg = summary.config
  in 
    [ Options.styled' Html.input
      [ cs "mdl-switch__input"
      , Options.many cfg.inner
      ]
      [ type' "checkbox"
      , Html.Attributes.disabled cfg.isDisabled
      , checked cfg.value 
        {- the checked attribute is not rendered. Switch still seems to
        work, though, but accessibility is probably compromised. 
        https://github.com/evancz/elm-html/issues/91
        -}
      ]
      []
    ,  span [ class "mdl-switch__label" ] elems
    ,  div [ class "mdl-switch__track" ] []
    ,  div 
         [ class "mdl-switch__thumb" ] 
         [ span [ class "mdl-switch__focus-helper" ] [] ]
    ]
    |> top lift "switch" model summary 


{-| Component view (radio button)
-}
viewRadio : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
viewRadio lift model config elems = 
  let 
    summary = Options.collect defaultConfig config
    cfg = summary.config
  in 
    [ Options.styled' Html.input
      [ cs "mdl-radio__button"
      , Options.many cfg.inner
      ]
      (List.filterMap identity 
        [ Just (type' "radio")
        , Just (Html.Attributes.disabled cfg.isDisabled)
        , Just (checked cfg.value)
        , cfg.group
        ] 
      )
      []
    , span [ class "mdl-radio__label" ] elems
    , span [ class "mdl-radio__outer-circle" ] [] 
    , span [ class "mdl-radio__inner-circle" ] [] 
    ]
    |> top lift "radio" model summary



-- COMPONENT

{-| 
-}
type alias Container c =
  { c | toggles : Indexed Model }


render
   : ((Msg -> b) -> Parts.View Model c)
  -> (Parts.Msg { d | toggles : Indexed Model } b -> b)
  -> Parts.Index
  -> Parts.View { d | toggles : Indexed Model } c
render view = 
  Parts.create view (Parts.generalize update) .toggles (\x y -> {y | toggles=x}) defaultModel


{-| Component render (checkbox)
-}
checkbox 
  : (Parts.Msg (Container c) m -> m)
  -> Parts.Index
  -> (Container c)
  -> List (Property m)
  -> List (Html m) 
  -> Html m
checkbox = 
  render viewCheckbox


{-| Component render (switch) 
-}
switch
  : (Parts.Msg (Container c) m -> m)
  -> Parts.Index
  -> (Container c)
  -> List (Property m)
  -> List (Html m)
  -> Html m
switch = 
  render viewSwitch


{-| Component render (radio button) 
-}
radio
  : (Parts.Msg (Container c) m -> m)
  -> Parts.Index
  -> (Container c)
  -> List (Property m)
  -> List (Html m) 
  -> Html m
radio = 
  render viewRadio



