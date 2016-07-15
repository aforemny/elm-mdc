module Material.Toggles.Common exposing where

import Html exposing (label)
import Html.Attributes exposing (class)
import Html.Events exposing (on, onFocus, onBlur)
import Json.Decode as Decode

import Material.Helpers exposing (blurOn)
import Material.Ripple as Ripple
import Material.Style exposing (styled, cs, attribute, multiple)


{-| Component action.
-}
type Msg
  = Change
  | Ripple Ripple.Msg
  | SetFocus Bool


{-| Component update.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of 
    Change -> 
      ( { model | value = not model.value }, none )

    Ripple rip -> 
      Ripple.update rip (state model)
        |> map1st (\r -> { model | state = S r })
        |> map2nd (Cmd.map Ripple)

    SetFocus focus -> 
      ( { model | isFocused = focus }, none )



top : String -> Address Msg -> Model -> List Style -> List Html -> Html
top name addr model styles elems = 
  styled label 
    [ cs ("mdl-" ++ name) 
    , cs ("mdl-js-" ++ name)
    , cs "mdl-js-ripple-effect" `when` model.ripple
    , cs "mdl-js-ripple-effect--ignore-events" `when` model.ripple
    , cs "is-upgraded"
    , cs "is-checked" `when` model.value
    , attribute <| on "change" Decode.value (always (message addr Change))
    , attribute <| blurOn "mouseup"
    , attribute <| onFocus addr (SetFocus True)
    , attribute <| onBlur addr (SetFocus False)
    , multiple styles
    ] 
    (if model.ripple then 
       (Ripple.view 
         ( forwardTo addr Ripple)
         [ class "mdl-switch__ripple-container mdl-js-ripple-effect mdl-ripple--center" ]
         (state model)
       ) :: elems
     else
       elems)


