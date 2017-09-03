module Material.Msg
  exposing (Msg(..), Index)

import Material.Internal.Button as Button 
import Material.Internal.Checkbox as Checkbox
import Material.Internal.Drawer as Drawer 
import Material.Internal.Fab as Fab 
import Material.Internal.IconToggle as IconToggle 
import Material.Internal.Menu as Menu
import Material.Internal.RadioButton as RadioButton
import Material.Internal.Ripple as Ripple
import Material.Internal.Select as Select
import Material.Internal.Slider as Slider
import Material.Internal.Snackbar as Snackbar
import Material.Internal.Switch as Switch
import Material.Internal.Tabs as Tabs
import Material.Internal.Textfield as Textfield
import Material.Internal.Toolbar as Toolbar 


type alias Index =
    List Int

  
type Msg m
    = Dispatch (List m)
    | ButtonMsg Index Button.Msg
    | CheckboxMsg Index Checkbox.Msg
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
    | ToolbarMsg Index Toolbar.Msg
