module Material.Msg exposing (..)

import Parts


type Msg model obs
    = Internal (Parts.Msg model obs)
    | Dispatch (List obs)
