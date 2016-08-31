module Material.Options.Internal exposing (..)

import Html
import Html.Events
import Json.Decode

import Dispatch
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
  | Listener String (Maybe (Html.Events.Options)) (Json.Decode.Decoder m)
  | Lift (Dispatch.Msg m -> m)
  | None


{-| We've seen examples of users inadverdently overriding event handlers / html
classes / css styling with this function, causing malfunctions in the library.
So we hide it away here.  
-}
attribute : Html.Attribute m -> Property c m 
attribute =
  Internal


-- INTERNAL UTILITIES


{-|-}
inner : List (Property c m) -> Property { a | inner : List (Property c m) } m
inner options =
  Set (\c -> { c | inner = options ++ c.inner })


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
inject viewFun lift =
  \a b c d -> viewFun a b (dispatch lift :: c) d


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
inject' viewFun lift =
  \a b c d -> viewFun a b (inner [ dispatch lift ] :: dispatch lift :: c) d
