module Material.Internal.Select exposing (Msg(..))


import Material.Dropdown.Geometry exposing (Geometry)
import Material.Internal.Dropdown as Dropdown
import Material.Internal.Textfield as Textfield


type Msg m
    = Click
    | Focus Geometry
    | Blur

    | Open Geometry

    | Input String

    | DropdownMsg (Dropdown.Msg m)
    | TextfieldMsg Textfield.Msg
