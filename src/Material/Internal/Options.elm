module Material.Internal.Options exposing
    ( aria
    , attribute
    , cs
    , css
    , data
    , dispatch
    , many
    , nativeControl
    , nop
    , on
    , onBlur
    , onCheck
    , onClick
    , onDoubleClick
    , onFocus
    , onInput
    , onMouseDown
    , onMouseEnter
    , onMouseLeave
    , onMouseOut
    , onMouseOver
    , onMouseUp
    , onSubmit
    , onWithOptions
    , Property
    , styled
    , when
    )

import Html.Attributes
import Html.Events
import Html exposing (Html, Attribute)
import Json.Decode as Json
import Material.Internal.Options.Internal as Internal exposing (..)


type alias Property c m =
    Internal.Property c m


styled : (List (Attribute m) -> List (Html m) -> Html m)
    -> List (Property c m)
    -> List (Html m)
    -> Html m
styled ctor props =
    ctor (addAttributes (collect_ props) [])


cs : String -> Property c m
cs c =
    Class c


css : String -> String -> Property c m
css key value =
    CSS ( key, value )


many : List (Property c m) -> Property c m
many =
    Many


nop : Property c m
nop =
    None


when : Bool -> Property c m -> Property c m
when guard prop  =
    if guard then
        prop
    else
        nop


data : String -> String -> Property c m
data key val =
    Attribute (Html.Attributes.attribute ("data-" ++ key) val)


aria : String -> String -> Property c m
aria key val =
    Attribute (Html.Attributes.attribute ("aria-" ++ key) val)


attribute : Html.Attribute Never -> Property c m
attribute =
    Attribute << Html.Attributes.map never


nativeControl : List (Property c m)
    -> Property ({ c | nativeControl : List (Property c m) }) m
nativeControl =
    Internal.nativeControl


on : String -> Json.Decoder m -> Property c m
on event =
    Listener event Nothing


onClick : msg -> Property c msg
onClick msg =
    on "click" (Json.succeed msg)


onDoubleClick : msg -> Property c msg
onDoubleClick msg =
    on "dblclick" (Json.succeed msg)


onMouseDown : msg -> Property c msg
onMouseDown msg =
    on "mousedown" (Json.succeed msg)


onMouseUp : msg -> Property c msg
onMouseUp msg =
    on "mouseup" (Json.succeed msg)


onMouseEnter : msg -> Property c msg
onMouseEnter msg =
    on "mouseenter" (Json.succeed msg)


onMouseLeave : msg -> Property c msg
onMouseLeave msg =
    on "mouseleave" (Json.succeed msg)


onMouseOver : msg -> Property c msg
onMouseOver msg =
    on "mouseover" (Json.succeed msg)


onMouseOut : msg -> Property c msg
onMouseOut msg =
    on "mouseout" (Json.succeed msg)


onCheck : (Bool -> msg) -> Property c msg
onCheck =
    (flip Json.map Html.Events.targetChecked) >> on "change"


onBlur : msg -> Property c msg
onBlur msg =
    on "blur" (Json.succeed msg)


onFocus : msg -> Property c msg
onFocus msg =
    on "focus" (Json.succeed msg)


onInput : (String -> m) -> Property c m
onInput f =
    on "input" (Json.map f Html.Events.targetValue)


onSubmit : (String -> m) -> Property c m
onSubmit f =
    onWithOptions "submit"
        { preventDefault = True
        , stopPropagation = False
        }
        (Json.map f Html.Events.targetValue)


onWithOptions : String -> Html.Events.Options -> Json.Decoder m -> Property c m
onWithOptions evt options =
    Listener evt (Just options)


dispatch : (List m -> m) -> Property c m
dispatch =
    Lift << Json.map
