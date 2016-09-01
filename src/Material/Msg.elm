module Material.Msg exposing (..)

import Dispatch
import Parts

type Msg model obs
  = Internal (Parts.Msg model obs)
  | Dispatch (Dispatch.Msg obs)
