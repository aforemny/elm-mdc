module Material.Options.Internal exposing (..)

import Html
import Html.Events
import Json.Decode as Json

import Material.Msg as Msg

{-| Internal type of properties. Do not use directly; use constructor functions
   in the Options module or `attribute` instead.
-}
type Property c m 
  = Class String
  | CSS (String, String)
  | Attribute (Html.Attribute m)
  | Internal (Html.Attribute m)
  | Many (List (Property c m))
  | Set (c -> c)
  | Listener String (Maybe (Html.Events.Options)) (Json.Decoder m)
  | Lift (List m -> m)
  | None


{-| We've seen examples of users inadverdently overriding event handlers / html
classes / css styling with this function, causing malfunctions in the library.
So we hide it away here.  
-}
attribute : Html.Attribute m -> Property c m 
attribute =
  Internal


-- INTERNAL UTILITIES


{-| TODO: Change field-name to `input`. 
-}
input : List (Property c m) -> Property { a | inner : List (Property c m) } m
input options =
  Set (\c -> { c | inner = Many options :: c.inner })


{-|-}
container : List (Property c m) -> Property c m 
container = 
  Many


{-|-}
dispatch : (Msg.Msg a m -> m) -> Property c m
dispatch lift =
  Lift (Msg.Dispatch >> lift)


{-| Inject dispatch
 -}
inject
    : (a -> b -> List (Property d e) -> f -> g)
    -> (Msg.Msg h e -> e)
    -> a
    -> b
    -> List (Property d e)
    -> f
    -> g
inject view lift a b c =
  view a b (dispatch lift :: c)


{-| Inject dispatch
 -}
inject'
    : (a -> b -> List (Property { f | inner : List (Property d e) } e) -> g -> h)
    -> (Msg.Msg i e -> e)
    -> a
    -> b
    -> List (Property { f | inner : List (Property d e) } e)
    -> g
    -> h
inject' view lift a b c =
  view a b (input [ dispatch lift ] :: dispatch lift :: c)


{-| Construct lifted handler with trivial decoder in a manner that
virtualdom will like. 

vdom diffing will recognise two different executions of the following to be
identical: 

    Json.map lift <| Json.succeed m    -- (a)

vdom diffing will _not_ recognise two different executions of this seemingly
simpler variant to be identical:

    Json.succeed (lift m)              -- (b)

In the common case, both `lift` and `m` will be a top-level constructors, say
`Mdl` and `Click`. In this case, the `lift m` in (b) is constructed anew on
each `view`, and vdom can't tell that the argument to Json.succeed is the same.
In (a), though, we're constructing no new values besides a Json decoder, which
will be taken apart as part of vdoms equality check; vdom _can_ in this case
tell that the previous and current decoder is the same. 

See #221 / this thread on elm-discuss:
https://groups.google.com/forum/#!topic/elm-discuss/Q6mTrF4T7EU
-}
on1 : String -> (a -> b) -> a -> Property c b
on1 event lift m = 
  Listener event Nothing (Json.map lift <| Json.succeed m)

