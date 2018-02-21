module GlobalEvents exposing
  (
    onLoad
  , onLoad1
  , onTick
  , onResize
  , onResize1
  , onPolledResize
  , onPolledResize1
  , onScroll
  , onScroll1
  )

import Html.Attributes as Html
import Html.Events as Html


{-| Triggers on window's `load` event – after resources have loaded –  and as
well on insertion of the HTML element.  Might trigger more than once for the
same HTML element
-}
onLoad =
  listener "globalload"


{-|  Same as `onLoad` but one animation frame later.
-}
onLoad1 =
  listener "globalload1"


{-| Triggers an event the first time the listener is installed. Treat this as a
more reliable node insertion event.
-}
onTick =
  listener "globaltick"


{-| Triggers on window's `resize` event.
-}
onResize =
  listener "globalresize"


{-| Same as `onResize` but one animation frame later.
-}
onResize1 =
  listener "globalresize1"


{-| TODO
-}
onPolledResize =
  listener "globalpolledresize"


{-| Same as `onPolledResize` but one animation frame later.
-}
onPolledResize1 =
  listener "globalpolledresize1"


{-| Triggers on document's `scroll` event.

The event contains `pageX` and `pageY` properties.
-}
onScroll =
  listener "globalscroll"


{-| Same as `onScroll` but one animation frame later.
-}
onScroll1 =
  listener "globalscroll1"


listener name decoder =
  [ Html.on name decoder
  , Html.attribute ("data-" ++ name) ""
  ]
