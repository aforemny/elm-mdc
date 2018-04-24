module Material.Internal.Msg exposing
    ( Msg(..)
    )

import Material.Internal.Button.Model as Button
import Material.Internal.Checkbox.Model as Checkbox
import Material.Internal.Dialog.Model as Dialog
import Material.Internal.Drawer.Model as Drawer
import Material.Internal.Fab.Model as Fab
import Material.Internal.GridList.Model as GridList
import Material.Internal.IconToggle.Model as IconToggle
import Material.Internal.Menu.Model as Menu
import Material.Internal.RadioButton.Model as RadioButton
import Material.Internal.Ripple.Model as Ripple
import Material.Internal.Select.Model as Select
import Material.Internal.Slider.Model as Slider
import Material.Internal.Snackbar.Model as Snackbar
import Material.Internal.Switch.Model as Switch
import Material.Internal.Tabs.Model as Tabs
import Material.Internal.Textfield.Model as Textfield
import Material.Internal.Toolbar.Model as Toolbar


type alias Index =
    List Int


type Msg m
    = Dispatch (List m)
    | ButtonMsg Index (Button.Msg m)
    | CheckboxMsg Index Checkbox.Msg
    | DialogMsg Index Dialog.Msg
    | DrawerMsg Index Drawer.Msg
    | FabMsg Index Fab.Msg
    | GridListMsg Index (GridList.Msg m)
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
