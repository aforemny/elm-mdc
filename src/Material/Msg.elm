module Material.Msg
  exposing (Msg(..), Index)

{-| TODO
@docs Msg, Index
-}

import Material.Internal.Button as Button 
import Material.Internal.Layout as Layout
import Material.Internal.Menu as Menu
import Material.Internal.Select as Select
import Material.Internal.Tabs as Tabs
import Material.Internal.Textfield as Textfield
import Material.Internal.Toggles as Toggles
import Material.Internal.Tooltip as Tooltip


{-| Type of indices. An index has to be `comparable`

For example:
An index can be a list of `Int` rather than just an `Int` to
support nested dynamically constructed elements: Use indices `[0]`, `[1]`, ...
for statically known top-level components, then use `[0,0]`, `[0,1]`, ...
for a dynamically generated list of components.
-}
type alias Index =
    List Int

  
{-| Type of elm-mdl global messages. 
-}
type Msg m
    = ButtonMsg Index Button.Msg
    | Dispatch (List m)
    | LayoutMsg Layout.Msg
    | MenuMsg Index (Menu.Msg m)
    | SelectMsg Index (Select.Msg m)
    | TabsMsg Index Tabs.Msg
    | TextfieldMsg Index Textfield.Msg
    | TogglesMsg Index Toggles.Msg
    | TooltipMsg Index Tooltip.Msg
