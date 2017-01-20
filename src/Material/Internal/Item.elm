module Material.Internal.Item exposing (Msg(..), Config)


-- import Material.Internal.Options exposing (Property)
import Material.Internal.Ripple as Ripple


type Msg m =
      Select (Maybe m)
    | Ripple Ripple.Msg

-- TODO: options

type alias Config m =
    { onSelect : Maybe m
    , enabled : Bool
    , divider : Bool
    , ripple : Bool
    -- , options : List (Property () m)
    , selected : Bool
    }
