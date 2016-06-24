module Material.Tooltip
  exposing
    ( Model
    , defaultModel
    , Msg(..)
    , update
    , view
    , render
    , DOMState
    , left
    , right
    , top
    , bottom
    , large
    , Property
    , onMouseEnter
    , onMouseLeave
    , attach
    , onEnter
    , onLeave
    , mdl
    )

{-| From the [Material Design Lite documentation](https://getmdl.io/components/index.html#tooltips-section):

> standard HTML tooltip as produced by the `title` attribute. A tooltip consists
> of text and/or an image that clearly communicates additional information about
> an element when the user hovers over or, in a touch-based UI, touches the
> element. The MDL tooltip component is pre-styled (colors, fonts, and other
> settings are contained in material.min.css) to provide a vivid, attractive
> visual element that displays related but typically non-essential content,
> e.g., a definition, clarification, or brief instruction.
>
> Tooltips are a ubiquitous feature of most user interfaces, regardless of a
> site's content or function. Their design and use is an important factor in the
> overall user experience. See the tooltip component's Material Design
> specifications page for details.

See also the
[Material Design Specification](https://material.google.com/components/tooltips.html).

Refer to [this site](http://debois.github.io/elm-mdl#/tooltips)
for a live demo.


# Types
@docs Model, defaultModel
@docs DOMState
@docs Property

# Update and render
@docs Msg, update, view, render

# Content
@docs left, right, top, bottom
@docs large

# Events
@docs onMouseEnter, onMouseLeave
@docs onEnter, onLeave
@docs attach

#Utility
@docs mdl

-}

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Parts exposing (Indexed)
import Material.Options as Options exposing (Style, cs, css, when)
import Material.Options.Internal as Internal
import DOM
import Html.Events
import Json.Decode as Json exposing ((:=), at)
import String


-- MODEL


{-| Component model.
-}
type alias Model =
  { isActive : Bool
  , domState : DOMState
  }


{-| Default component model constructor.
-}
defaultModel : Model
defaultModel =
  { isActive = False
  , domState = defaultDOMState
  }



-- ACTION, UPDATE


{-| Component action.
-}
type Msg
  = Enter DOMState
  | Leave


{-| Tooltip position
-}
type alias Pos =
  { left : Float
  , top : Float
  , marginLeft : Float
  , marginTop : Float
  }


{-| Default position constructor
-}
defaultPos : Pos
defaultPos =
  { left = 0
  , top = 0
  , marginLeft = 0
  , marginTop = 0
  }


{-| Position and offsets from dom events for the tooltip
-}
type alias DOMState =
  { rect : DOM.Rectangle
  , offsetWidth : Float
  , offsetHeight : Float
  }


{-| Default DOMState constructor
-}
defaultDOMState : DOMState
defaultDOMState =
  { rect = { left = 0, top = 0, width = 0, height = 0 }
  , offsetWidth = 0
  , offsetHeight = 0
  }


{-| Calculates the position of the tooltip based on the event
and the requested position
-}
calculatePos : Position -> DOMState -> Pos
calculatePos pos domState =
  let
    -- _ = Debug.log "Calculating position for " domState
    props =
      domState.rect

    offsetWidth =
      domState.offsetWidth

    offsetHeight =
      domState.offsetHeight

    left =
      props.left + (props.width / 2)

    top =
      props.top + (props.height / 2)

    marginLeft =
      -1 * (offsetWidth / 2)

    marginTop =
      -1 * (offsetHeight / 2)

    -- Returns the values if their sum is above 0
    getValuesFor l r =
      if ((l + r) < 0) then
        ( 0, 0 )
      else
        ( l, r )

    ( newTop, newMarginTop ) =
      getValuesFor top marginTop

    ( newLeft, newMarginLeft ) =
      getValuesFor left marginLeft

    out =
      case pos of
        Left ->
          { left = props.left - offsetWidth - 10
          , top = newTop
          , marginTop = newMarginTop
          , marginLeft = 0
          }

        Right ->
          { left = props.left + props.width + 10
          , top = newTop
          , marginTop = newMarginTop
          , marginLeft = 0
          }

        Top ->
          { left = newLeft
          , top = props.top - offsetHeight - 10
          , marginTop = 0
          , marginLeft = newMarginLeft
          }

        Bottom ->
          { left = newLeft
          , top = props.top + props.height + 10
          , marginTop = 0
          , marginLeft = newMarginLeft
          }
  in
    out


{-| Component update.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of
    Enter dom ->
      ( { model | isActive = True, domState = dom }, none )

    Leave ->
      ( { model | isActive = False }, none )


{-| Tries and get the next sibling that is available and use the given decoder on it
-}
sibling : Json.Decoder a -> Json.Decoder a
sibling d =
  let
    createPath depth =
      let
        parents =
          List.repeat depth "parentElement"
      in
        ([ "target" ] ++ parents ++ [ "nextSibling" ])

    paths =
      List.map createPath [0..4]

    -- Tries to check if the element is actually a tooltip
    valid path =
      isTooltipClass path
        `Json.andThen`
          (\res ->
            if res then
              at path d
            else
              Json.fail ""
          )
  in
    Json.oneOf (List.map valid paths)


{-| Checks if the target at path is an actual tooltip
-}
isTooltipClass : List (String) -> Json.Decoder Bool
isTooltipClass path =
  (at path DOM.className)
    `Json.andThen`
      (\class ->
        if String.contains "mdl-tooltip" class then
          Json.succeed True
        else
          Json.succeed False
      )


{-| Decodes a DOMState from a DOM event
-}
stateDecoder : Json.Decoder DOMState
stateDecoder =
  Json.object3 DOMState
    (DOM.target DOM.boundingClientRect)
    (sibling DOM.offsetWidth)
    (sibling DOM.offsetHeight)



-- PROPERTIES


{-| Tooltip size
-}
type Size
  = Default
  | Large


{-| Tooltip position relative to the element
-}
type Position
  = Left
  | Right
  | Top
  | Bottom


{-| Tooltip config
-}
type alias Config =
  { size : Size
  , position : Position
  }


{-| Default configuration for tooltip
-}
defaultConfig : Config
defaultConfig =
  { size = Default
  , position = Bottom
  }


{-| Properties for Tooltip options.
-}
type alias Property m =
  Options.Property Config m


{-| Position the tooltip on the left of the target element
-}
left : Property m
left =
  Options.set (\options -> { options | position = Left })


{-| Position the tooltip on the right of the target element
-}
right : Property m
right =
  Options.set (\options -> { options | position = Right })


{-| Position the tooltip above the target element
-}
top : Property m
top =
  Options.set (\options -> { options | position = Top })


{-| Position the tooltip below the target element
-}
bottom : Property m
bottom =
  Options.set (\options -> { options | position = Bottom })


{-| Large tooltip
-}
large : Property m
large =
  Options.set (\options -> { options | size = Large })


{-| Maps a Html.Attribute to Material Property
-}
mdl : Attribute a -> Internal.Property b a
mdl =
  Internal.Attribute



-- VIEW


{-| Component view.
-}
view : (Msg -> m) -> Model -> List (Property m) -> List (Html a) -> Html a
view lift model options content =
  let
    summary =
      Options.collect defaultConfig options

    config =
      summary.config

    px : Float -> String
    px f =
      (toString f) ++ "px"

    pos =
      if model.isActive then
        calculatePos config.position model.domState
      else
        defaultPos
  in
    Options.styled div
      (cs "mdl-tooltip"
        :: cs "is-active"
        `when` model.isActive
        :: cs "mdl-tooltip--large"
        `when` (config.size == Large)
        :: css "left" (px pos.left)
        `when` model.isActive
        :: css "margin-left" (px pos.marginLeft)
        `when` model.isActive
        :: css "top" (px pos.top)
        `when` model.isActive
        :: css "margin-top" (px pos.marginTop)
        `when` model.isActive
        :: []
      )
      content



-- COMPONENT


type alias Container c =
  { c | tooltip : Indexed Model }


{-| Render a tooltip
-}
render :
  (Parts.Msg (Container c) -> m)
  -> Parts.Index
  -> Container c
  -> List (Property m)
  -> List (Html m)
  -> Html m
render =
  Parts.create view update .tooltip (\x y -> { y | tooltip = x }) defaultModel


set : Parts.Set (Indexed Model) (Container c)
set x y =
  { y | tooltip = x }


find : Parts.Index -> Parts.Accessors Model (Container c)
find =
  Parts.accessors .tooltip set defaultModel


pack : Parts.Index -> Msg -> Parts.Msg (Container c)
pack idx =
  let
    ( get, set1 ) =
      Parts.indexed .tooltip set defaultModel idx

    embeddedUpdate =
      Parts.embedUpdate get set1 update
  in
    Parts.pack embeddedUpdate


{-| Mouse enter event handler for Parts version
-}
onMouseEnter : (Parts.Msg (Container b) -> d) -> Parts.Index -> Attribute d
onMouseEnter lift idx =
  Html.Events.on "mouseenter" (Json.map (Enter >> ((pack idx) >> lift)) stateDecoder)


{-| Mouse leave event handler for Parts version
-}
onMouseLeave : (Parts.Msg (Container a) -> b) -> Parts.Index -> Attribute b
onMouseLeave lift idx =
  Html.Events.on "mouseleave" (Json.succeed (Leave |> ((pack idx) >> lift)))


{-| Attach event handlers for Parts version
-}
attach : (Parts.Msg (Container a) -> b) -> Parts.Index -> Options.Property c b
attach lift index =
  Options.many
    [ Internal.attribute <| onMouseEnter lift index
    , Internal.attribute <| onMouseLeave lift index
    ]


{-| Mouse enter event handler for Non-Parts version
-}
onEnter : (Msg -> m) -> Attribute m
onEnter lift =
  Html.Events.on "mouseenter" (Json.map (Enter >> lift) stateDecoder)


{-| Mouse leave event handler for Non-Parts version
-}
onLeave : (Msg -> m) -> Attribute m
onLeave lift =
  Html.Events.on "mouseleave" (Json.succeed (lift Leave))
