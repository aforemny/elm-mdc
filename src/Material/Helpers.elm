module Material.Helpers 
  ( filter, blurOn
  , map1st, map2nd
  , delay, pure, effect
  , lift, lift'
  , Update, Update'
  ) where

{-| Convenience functions. These are mostly trivial functions that are used
internally in the library; you might
find some of them useful. 

# HTML & Events
@docs filter, blurOn

# Effects
@docs pure, effect, delay

# Tuples
@docs map1st, map2nd

# Elm architecture
@docs Update, Update', lift, lift'
-}

import Html
import Html.Attributes
import Effects exposing (Effects)
import Time exposing (Time)
import Task


{-| Convert the `List Html` parameter of a standard elm-html element to 
`List (Maybe Html)`; this is convenient when sub-elements should not always be
rendered. Example use: 

    myDiv : Maybe Html -> Html
    myDiv optionalSubElement = 
      filter div 
        [ class "div-with-filtered-elements" 
        ]
        [ Just <| text "Always present" 
        , optionalSubElement   
        ]
-}
filter : (a -> List b -> c) -> a -> List (Maybe b) -> c
filter elem attr html =
  elem attr (List.filterMap (\x -> x) html)


{-| Add an effect to a value. Example use (supposing you have an 
action `MyAction`): 

    model |> effect MyAction
-}
effect : Effects b -> a -> (a, Effects b)
effect e x = (x, e)


{-| Add the trivial effect to a value. Example use:
    
    model |> pure
-}
pure : a -> (a, Effects b)
pure = effect Effects.none



{-| Attribute which causes element to blur on given event. Example use

    myButton : Html
    myButton = 
      button 
        [ blurOn "mouseleave" ]
        [ text "Click me!" ]
-}
blurOn : String -> Html.Attribute
blurOn evt =
  Html.Attributes.attribute ("on" ++ evt) <| "this.blur()"


-- TUPLES


{-| Map the first element of a tuple. 

    map1st ((+) 1) (1, "foo") == (2, "foo")
-}
map1st : (a -> c) -> (a,b) -> (c,b)
map1st f (x,y) = (f x, y)


{-| Map the second element of a tuple

    map2nd ((+) 1) ("bar", 3) == ("bar", 4)
-}
map2nd : (b -> c) -> (a,b) -> (a,c)
map2nd f (x,y) = (x, f y)


{-| Variant of EA update function type, where effects may be 
lifted to a different type. 
-}
type alias Update' model action action' = 
  action -> model -> (model, Effects action')


{-| Standard EA update function type. 
-}
type alias Update model action = 
  Update' model action action


{-| Variant of `lift` for effect-free components. 
-}
lift' :
  (model -> submodel) ->                                      -- get
  (model -> submodel -> model) ->                             -- set
  (subaction -> submodel -> submodel) -> 
  subaction ->                                                -- action
  model ->                                                    -- model
  (model, Effects action)
lift' get set update action model =
  (set model (update action (get model)), Effects.none)

{-| Convenience function for writing update-function boilerplate. Example use:

  case action of 
    ...
    ButtonsAction a -> 
      lift .buttons (\m x->{m|buttons=x}) ButtonsAction Demo.Buttons.update a model

This is equivalent to the more verbose

  case action of 
    ...
    ButtonsAction a -> 
      let 
        (buttons', fx) = 
          Demo.Buttons.update a model.buttons
      in 
        ( { model | buttons = buttons'}
        , Effects.map ButtonsAction fx
        )
-}
lift :
  (model -> submodel) ->                                      -- get
  (model -> submodel -> model) ->                             -- set
  (subaction -> action) ->                                    -- fwd
  Update submodel subaction ->                               -- update
  subaction ->                                                -- action
  model ->                                                    -- model
  (model, Effects action)
lift get set fwd update action model =
  let
    (submodel', e) = update action (get model)
  in
    (set model submodel', Effects.map fwd e)


fx : a -> Effects a
fx =
  Task.succeed >> Effects.task


{-| Produce a delayed effect. Suppose you want `MyAction` to happen 200ms after
a button is clicked:

    button 
      [ onClick (delay 0.2 MyAction) ] 
      [ text "Click me!" ]
-}
delay : Time -> a -> Effects a
delay t x =
  Task.sleep t
    |> (flip Task.andThen) (always (Task.succeed x))
    |> Effects.task


