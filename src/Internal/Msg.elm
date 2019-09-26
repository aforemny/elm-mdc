module Internal.Msg exposing (Msg(..))

import Internal.Button.Model as Button
import Internal.Checkbox.Model as Checkbox
import Internal.Chip.Model as Chip
import Internal.Dialog.Model as Dialog
import Internal.Drawer.Model as Drawer
import Internal.Fab.Model as Fab
import Internal.IconButton.Model as IconButton
import Internal.Index exposing (Index)
import Internal.List.Model as List
import Internal.Menu.Model as Menu
import Internal.RadioButton.Model as RadioButton
import Internal.Ripple.Model as Ripple
import Internal.Select.Model as Select
import Internal.Slider.Model as Slider
import Internal.Snackbar.Model as Snackbar
import Internal.Switch.Model as Switch
import Internal.TabBar.Model as TabBar
import Internal.TextField.Model as TextField
import Internal.TopAppBar.Model as TopAppBar


type Msg m
    = Dispatch (List m)
    | ButtonMsg Index (Button.Msg m)
    | CheckboxMsg Index Checkbox.Msg
    | ChipMsg Index (Chip.Msg m)
    | DialogMsg Index Dialog.Msg
    | DrawerMsg Index Drawer.Msg
    | FabMsg Index Fab.Msg
    | IconButtonMsg Index IconButton.Msg
    | ListMsg Index (List.Msg m)
    | MenuMsg Index (Menu.Msg m)
    | RadioButtonMsg Index RadioButton.Msg
    | RippleMsg Index Ripple.Msg
    | SelectMsg Index (Select.Msg m)
    | SliderMsg Index (Slider.Msg m)
    | SnackbarMsg Index (Snackbar.Msg m)
    | SwitchMsg Index Switch.Msg
    | TabBarMsg Index (TabBar.Msg m)
    | TextFieldMsg Index TextField.Msg
    | TopAppBarMsg Index TopAppBar.Msg
