module Internal.Options
    exposing
        ( Property
        , addAttributes
        , apply
        , applyNativeControl
        , aria
        , attribute
        , autocomplete
        , autofocus
        , collect
        , cs
        , css
        , data
        , dispatch
        , for
        , id
        , id_
        , many
        , nativeControl
        , nop
        , on
        , onBlur
        , onChange
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
        , option
        , recollect
        , role
        , styled
        , tabindex
        , when
        )

import Html exposing (Attribute, Html)
import Html.Attributes
import Html.Events
import Internal.Dispatch as Dispatch
import Internal.Index exposing (Index)
import Internal.Msg exposing (Msg(Dispatch))
import Json.Decode as Json exposing (Decoder)
import String


type Property c m
    = Class String
    | CSS ( String, String )
    | Attribute (Html.Attribute m)
    | Internal (Html.Attribute m)
    | Many (List (Property c m))
    | Set (c -> c)
    | Listener String (Maybe Html.Events.Options) (Decoder m)
    | Lift (Decoder (List m) -> Decoder m)
    | None


type alias Summary c m =
    { classes : List String
    , css : List ( String, String )
    , attrs : List (Attribute m)
    , internal : List (Attribute m)
    , dispatch : Dispatch.Config m
    , config : c
    }


collect1 : Property c m -> Summary c m -> Summary c m
collect1 option acc =
    case option of
        Class x ->
            { acc | classes = x :: acc.classes }

        CSS x ->
            { acc | css = x :: acc.css }

        Attribute x ->
            { acc | attrs = x :: acc.attrs }

        Internal x ->
            { acc | internal = x :: acc.internal }

        Many options ->
            List.foldl collect1 acc options

        Set g ->
            { acc | config = g acc.config }

        Listener event options decoder ->
            { acc | dispatch = Dispatch.add event options decoder acc.dispatch }

        Lift m ->
            { acc | dispatch = Dispatch.setDecoder m acc.dispatch }

        None ->
            acc


recollect : Summary c m -> List (Property c m) -> Summary c m
recollect =
    List.foldl collect1


collect : c -> List (Property c m) -> Summary c m
collect =
    Summary [] [] [] [] Dispatch.defaultConfig >> recollect


collect1_ : Property c m -> Summary () m -> Summary () m
collect1_ options acc =
    case options of
        Class x ->
            { acc | classes = x :: acc.classes }

        CSS x ->
            { acc | css = x :: acc.css }

        Attribute x ->
            { acc | attrs = x :: acc.attrs }

        Internal x ->
            { acc | internal = x :: acc.internal }

        Listener event options decoder ->
            { acc | dispatch = Dispatch.add event options decoder acc.dispatch }

        Many options ->
            List.foldl collect1_ acc options

        Lift m ->
            { acc | dispatch = Dispatch.setDecoder m acc.dispatch }

        Set _ ->
            acc

        None ->
            acc


collect_ : List (Property c m) -> Summary () m
collect_ =
    List.foldl collect1_ (Summary [] [] [] [] Dispatch.defaultConfig ())


addAttributes : Summary c m -> List (Attribute m) -> List (Attribute m)
addAttributes summary attrs =
    {- Ordering here is important: First apply summary attributes. That way,
       internal classes and attributes override those provided by the user.
    -}
    summary.attrs
        ++ [ Html.Attributes.style summary.css
           , Html.Attributes.class (String.join " " summary.classes)
           ]
        ++ attrs
        ++ summary.internal
        ++ Dispatch.toAttributes summary.dispatch


option : (c -> c) -> Property c m
option =
    Set


type alias NativeControl c m =
    { c | nativeControl : List (Property () m) }


nativeControl :
    List (Property () m)
    -> Property (NativeControl c m) m
nativeControl options =
    option (\config -> { config | nativeControl = config.nativeControl ++ options })


id_ : Index -> Property { c | id_ : Index } m
id_ id_ =
    option (\config -> { config | id_ = id_ })


for : String -> Property c m
for =
    Attribute << Html.Attributes.for


{-| Construct lifted handler with trivial decoder in a manner that
virtualdom will like.

vdom diffing will recognise two different executions of the following to be
identical:

    Json.map lift <| Json.succeed m    -- (a)

vdom diffing will _not_ recognise two different executions of this seemingly
simpler variant to be identical:

    Json.succeed (lift m)              -- (b)

In the common case, both `lift` and `m` will be a top-level constructors, say
`Mdl` and `Click`. In this case, the `lift m` in (b) is constructed anew on
each `view`, and vdom can't tell that the argument to Json.succeed is the same.
In (a), though, we're constructing no new values besides a Json decoder, which
will be taken apart as part of vdoms equality check; vdom _can_ in this case
tell that the previous and current decoder is the same.

See #221 / this thread on elm-discuss:
<https://groups.google.com/forum/#!topic/elm-discuss/Q6mTrF4T7EU>

-}
on1 : String -> (a -> b) -> a -> Property c b
on1 event lift m =
    Listener event Nothing (Json.map lift <| Json.succeed m)


apply :
    Summary c m
    -> (List (Attribute m) -> a)
    -> List (Property c m)
    -> List (Attribute m)
    -> a
apply summary ctor options attrs =
    ctor (addAttributes (recollect summary options) attrs)


applyNativeControl :
    Summary (NativeControl c m) m
    -> (List (Attribute m) -> List (Html m) -> Html m)
    -> List (Property () m)
    -> List (Html m)
    -> Html m
applyNativeControl summary ctor options =
    ctor
        (addAttributes
            (recollect
                { summary
                    | classes = []
                    , css = []
                    , attrs = []
                    , internal = []
                    , config = ()
                    , dispatch = Dispatch.clear summary.dispatch
                }
                (summary.config.nativeControl ++ options)
            )
            []
        )


styled :
    (List (Attribute m) -> a)
    -> List (Property c m)
    -> a
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
when guard prop =
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


autocomplete : String -> Property c m
autocomplete autocomplete =
    Attribute (Html.Attributes.attribute "autocomplete" autocomplete)


tabindex : Int -> Property c m
tabindex tabindex =
    Attribute (Html.Attributes.tabindex tabindex)


autofocus : Bool -> Property c m
autofocus autofocus =
    Attribute (Html.Attributes.autofocus autofocus)


role : String -> Property c m
role role =
    Attribute (Html.Attributes.attribute "role" role)


attribute : Html.Attribute Never -> Property c m
attribute =
    Attribute << Html.Attributes.map never


on : String -> Json.Decoder m -> Property c m
on event =
    Listener event Nothing


id : String -> Property c m
id =
    Attribute << Html.Attributes.id


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
    flip Json.map Html.Events.targetChecked >> on "change"


onBlur : msg -> Property c msg
onBlur msg =
    on "blur" (Json.succeed msg)


onFocus : msg -> Property c msg
onFocus msg =
    on "focus" (Json.succeed msg)


onInput : (String -> m) -> Property c m
onInput f =
    on "input" (Json.map f Html.Events.targetValue)


onChange : (String -> m) -> Property c m
onChange f =
    on "change" (Json.map f Html.Events.targetValue)


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


dispatch : (Msg m -> m) -> Property c m
dispatch lift =
    Lift (Json.map Dispatch >> Json.map lift)
