module Material.Msg
  exposing (Msg(..), Index)

{-| TODO
@docs Msg, Index
-}

import Material.Internal.Button as Button 
import Material.Internal.Radio as Radio 
import Material.Internal.IconToggle as IconToggle 
import Material.Internal.Fab as Fab 
import Material.Internal.Menu as Menu
import Material.Internal.Ripple as Ripple
import Material.Internal.Select as Select
import Material.Internal.Snackbar as Snackbar
import Material.Internal.Tabs as Tabs
import Material.Internal.Textfield as Textfield
import Material.Internal.Checkbox as Checkbox
import Material.Internal.Switch as Switch
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
    | IconToggleMsg Index IconToggle.Msg
    | SnackbarMsg Index (Snackbar.Msg m)
    | FabMsg Index Fab.Msg
    | Dispatch (List m)
    | MenuMsg Index (Menu.Msg m)
    | SelectMsg Index (Select.Msg m)
    | TabsMsg Index (Tabs.Msg m)
    | TextfieldMsg Index Textfield.Msg
    | CheckboxMsg Index Checkbox.Msg
    | SwitchMsg Index Switch.Msg
    | TooltipMsg Index Tooltip.Msg
    | RippleMsg Index Ripple.Msg
    | RadioMsg Index Radio.Msg
