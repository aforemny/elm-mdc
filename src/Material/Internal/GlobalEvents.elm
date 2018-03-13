module Material.Internal.GlobalEvents exposing
    ( onMouseMove
    , onMouseUp
    , onPointerMove
    , onPointerUp
    , onResize
    , onScroll
    , onTick
    , onTouchEnd
    , onTouchMove
    )

import Json.Decode exposing (Decoder)
import Material.Options as Options exposing (Property)


onTick : Decoder m -> Property c m
onTick =
  listener "globaltick"


onResize : Decoder m -> Property c m
onResize =
  listener "globalresize"


onScroll : Decoder m -> Property c m
onScroll =
  listener "globalscroll"


onMouseMove : Decoder m -> Property c m
onMouseMove =
    listener "globalmousemove"


onTouchMove : Decoder m -> Property c m
onTouchMove =
    listener "globaltouchmove"


onPointerMove : Decoder m -> Property c m
onPointerMove =
    listener "globalpointermove"


onMouseUp : Decoder m -> Property c m
onMouseUp =
    listener "globalmouseup"


onTouchEnd : Decoder m -> Property c m
onTouchEnd =
    listener "globaltouchend"


onPointerUp : Decoder m -> Property c m
onPointerUp =
    listener "globalpointerup"


listener : String -> Decoder m -> Property c m
listener name decoder =
  Options.many
  [ Options.on name decoder
  , Options.data name ""
  ]
