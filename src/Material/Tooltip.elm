module Material.Tooltip exposing (..)

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#TEMPLATE-section):

> ...

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/TEMPLATE.html).

Refer to [this site](http://debois.github.io/elm-mdl#/template)
for a live demo.

@docs Model, model, Msg, update
@docs view

# Component support

@docs Container, Observer, Instance, instance, fwdTemplate
-}

-- ( Model, defaultModel, Msg, update, view
-- , Property
-- , render
-- )
-- TEMPLATE. Copy this to a file for your component, then update.

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Parts exposing (Indexed)
import Material.Options as Options exposing (Style, cs, css, when)
import Material.Options.Internal as Internal
import Material.Helpers as Helpers
import DOM
import Html.Events
import Html.Attributes
import Html.App
import Json.Decode as Json exposing ((:=), at)


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
  , domState = { rect = { left = 0, top = 0, width = 0, height = 0 }, offsetWidth = 0, offsetHeight = 0 }
  }

-- ACTION, UPDATE


{-| Component action.
-}
type Msg
  = Enter DOMState
  | Leave


type alias Pos =
  { left : Float
  , top : Float
  , marginLeft : Float
  , marginTop : Float
  }


emptyPos : Pos
emptyPos =
  { left = 0
  , top = 0
  , marginLeft = 0
  , marginTop = 0
  }


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


    out =
      case pos of
        Left ->
          { left = props.left - offsetWidth - 10
          , top =
              if (top + marginTop < 0) then
                0
              else
                top
          , marginTop =
              if (top + marginTop < 0) then
                0
              else
                marginTop
          , marginLeft = 0
          }

        Right ->
          { left = props.left + props.width + 10
          , top =
              if (top + marginTop < 0) then
                0
              else
                top
          , marginTop =
              if (top + marginTop < 0) then
                0
              else
                marginTop
          , marginLeft = 0
          }

        Top ->
          { left =
              if (left + marginLeft < 0) then
                0
              else
                left
          , top = props.top - offsetHeight - 10
          , marginTop = 0
          , marginLeft =
              if (left + marginLeft < 0) then
                0
              else
                marginLeft
          }

        Bottom ->
          { left =
              if (left + marginLeft < 0) then
                0
              else
                left
          , top = props.top + props.height + 10
          , marginTop = 0
          , marginLeft =
              if (left + marginLeft < 0) then
                0
              else
                marginLeft
          }
  in
    out


{-| Component update.
-}

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Enter dom ->
      ({ model | isActive = True, domState = dom }, none)
    Leave ->
      ({ model | isActive = False }, none)

type alias DOMState =
  { rect : DOM.Rectangle
  , offsetWidth : Float
  , offsetHeight : Float
  }


sibling : Json.Decoder a -> Json.Decoder a
sibling d =
  Json.oneOf
    [
      at [ "target", "nextSibling" ] d
    , at [ "target", "parentElement", "nextSibling" ] d
    , at [ "target", "parentElement", "parentElement", "nextSibling" ] d
    ]

siblingAtDepth : Int -> Json.Decoder a -> Json.Decoder a
siblingAtDepth depth decoder =
  let
    parents = List.repeat depth "parentElement"
  in
    at (["target"] ++ parents ++ ["nextSibling"]) decoder

stateDecoder : Json.Decoder DOMState
stateDecoder =
  Json.object3 DOMState
    (DOM.target DOM.boundingClientRect)
    (sibling DOM.offsetWidth)
    (sibling DOM.offsetHeight)

stateAtDepth : Int -> Json.Decoder DOMState
stateAtDepth depth =
  Json.object3 DOMState
    (DOM.target DOM.boundingClientRect)
    ((siblingAtDepth depth) DOM.offsetWidth)
    ((siblingAtDepth depth) DOM.offsetHeight)


-- PROPERTIES


type Size
  = Default
  | Large


type Position
  = Left
  | Right
  | Top
  | Bottom


type alias Config =
  { size : Size
  , position : Position
  }


defaultConfig : Config
defaultConfig =
  { size = Default
  , position = Bottom
  }


type alias Property m =
  Options.Property Config m


left : Property m
left =
  Options.set (\options -> { options | position = Left })


right : Property m
right =
  Options.set (\options -> { options | position = Right })


top : Property m
top =
  Options.set (\options -> { options | position = Top })


bottom : Property m
bottom =
  Options.set (\options -> { options | position = Bottom })


large : Property m
large =
  Options.set (\options -> { options | size = Large })

-- VIEW


{-| Component view.
-}


view : (Msg -> m) -> Model -> List (Property m) -> List (Html a) -> Html a
view lift model options content =
  let
    summary =
      Options.collect defaultConfig options

    config = summary.config

    px : Float -> String
    px f =
      (toString f) ++ "px"

    pos =
      if model.isActive then
        calculatePos config.position model.domState
      else
        emptyPos
  in
    Options.styled div
      (cs "mdl-tooltip"
       :: cs "is-active" `when` model.isActive
       :: cs "mdl-tooltip--large" `when` (config.size == Large)
       :: css "left" (px pos.left) `when` model.isActive
       :: css "margin-left" (px pos.marginLeft) `when` model.isActive
       :: css "top" (px pos.top) `when` model.isActive
       :: css "margin-top" (px pos.marginTop) `when` model.isActive
       :: [])
      content

-- COMPONENT


type alias Container c =
  { c | tooltip : Indexed Model }


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
    (get, set1) =
      Parts.indexed .tooltip set defaultModel idx

    embeddedUpdate =
      Parts.embedUpdate get set1 update
  in
    Parts.pack embeddedUpdate


--onMouseEnter : (Msg -> m) -> Parts.Index -> Attribute m
onMouseEnter lift idx =
  Html.Events.on "mouseenter" (Json.map (Enter >> ((pack idx) >> lift)) stateDecoder)

--onMouseLeave : (Msg -> m) -> Parts.Index -> Attribute m
onMouseLeave lift idx =
  Html.Events.on "mouseleave" (Json.succeed (Leave |> ((pack idx) >> lift)))
