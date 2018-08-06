module Internal.GlobalEvents
    exposing
        ( TickConfig
        , onMouseMove
        , onMouseUp
        , onPointerMove
        , onPointerUp
        , onResize
        , onScroll
        , onTick
        , onTickWith
        , onTouchEnd
        , onTouchMove
        )

import Json.Decode exposing (Decoder, Value)
import Json.Encode as Encode
import Material.Options as Options exposing (Property)


type alias TickConfig =
    { targetRect : Bool
    , parentRect : Bool
    }


encodeTickConfig : TickConfig -> Value
encodeTickConfig tickConfig =
    Encode.object
        [ ( "targetRect", Encode.bool tickConfig.targetRect )
        , ( "parentRect", Encode.bool tickConfig.parentRect )
        ]


onTick : Decoder m -> Property c m
onTick =
    listener "globaltick"


onTickWith : TickConfig -> Decoder m -> Property c m
onTickWith config =
    listenerWithValue "globaltick" (encodeTickConfig config)


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
        , Options.data name "{}"
        ]


listenerWithValue : String -> Value -> Decoder m -> Property c m
listenerWithValue name value decoder =
    Options.many
        [ Options.on name decoder
        , Options.data name (Encode.encode 0 value)
        ]
