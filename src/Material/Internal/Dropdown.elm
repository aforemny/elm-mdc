module Material.Internal.Dropdown exposing
    ( Msg(..)
    , Alignment(..)
    , ItemIndex
    , ItemInfo
    , KeyCode
    )


import Material.Dropdown.Geometry exposing (Geometry)
import Material.Internal.Item as Item
-- import Material.Internal.Options as Options
import Mouse


type Msg m
    = Open Geometry
    | ItemMsg ItemIndex (Item.Msg m)
    | Close
    | Click Alignment Mouse.Position
    | Key (Maybe ItemIndex) (List (ItemInfo m)) KeyCode Geometry


type Alignment
    = BottomLeft
    | BottomRight
    | TopLeft
    | TopRight
    | Over
    | Below


type alias ItemIndex
    = Int


type alias ItemInfo m =
    { enabled : Bool
    , onSelect : Maybe m
    }


type alias KeyCode
    = Int
