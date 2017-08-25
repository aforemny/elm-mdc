module Material.Msg
  exposing (Msg(..), Index)

{-| TODO
@docs Msg, Index
-}

import Material.Internal.Button as Button 
import Material.Internal.Drawer as Drawer 
import Material.Internal.RadioButton as RadioButton
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
import Material.Internal.Slider as Slider


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
    | CheckboxMsg Index Checkbox.Msg
    | Dispatch (List m)
    | DrawerMsg Index Drawer.Msg
    | FabMsg Index Fab.Msg
    | IconToggleMsg Index IconToggle.Msg
    | MenuMsg Index (Menu.Msg m)
    | RadioButtonMsg Index RadioButton.Msg
    | RippleMsg Index Ripple.Msg
    | SelectMsg Index (Select.Msg m)
    | SliderMsg Index (Slider.Msg m)
    | SnackbarMsg Index (Snackbar.Msg m)
    | SwitchMsg Index Switch.Msg
    | TabsMsg Index (Tabs.Msg m)
    | TextfieldMsg Index Textfield.Msg
