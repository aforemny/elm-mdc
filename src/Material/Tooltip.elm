module Material.Tooltip
  exposing
    (..)

  -- ( Model, defaultModel, Msg, update, view
  -- , Property
  -- , render
  -- )

-- TEMPLATE. Copy this to a file for your component, then update.

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


import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)

import Parts exposing (Indexed)
import Material.Options as Options exposing (Style, cs)
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
  , left : Float
  , top : Float
  , marginLeft : Float
  , marginTop : Float
  }


{-| Default component model constructor.
-}
defaultModel : Model
defaultModel =
  { isActive = False
  , left = 0
  , top = 0
  , marginLeft = 0
  , marginTop = 0
  }


-- ACTION, UPDATE


{-| Component action.
-}
type Msg
  = Enter DOMState
  | Leave


{-| Component update.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Enter domState ->
      let
        -- _ = Debug.log "STATE" domState
        r = domState.rect
        left = r.left + (r.width / 2)
        top = r.top + (r.height / 2)
        marginLeft = -1 * (domState.offsetWidth / 2)
        marginTop = -1 * (domState.offsetHeight / 2)


        (al, am) = if (left + marginLeft) < 0 then (0, 0) else (left, marginLeft)

        at = r.top + r.height + 10

      in
        ({ model | isActive = True
         , top = at
         , left = al
         , marginLeft = am
         }, none)

    Leave ->
      ({model | isActive = False }, Cmd.none)

type alias DOMState =
  { rect : DOM.Rectangle
  , offsetWidth : Float
  , offsetHeight : Float
  }

sibling : Json.Decoder a -> Json.Decoder a
sibling d =
  at ["target", "nextSibling"] d



stateDecoder : Json.Decoder DOMState
stateDecoder =
  Json.object3 DOMState
    (DOM.target DOM.boundingClientRect)
    (sibling DOM.offsetWidth)
    (sibling DOM.offsetHeight)

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



onEnter : (Msg -> m) -> String -> Attribute m
onEnter lift s =
  Html.Events.on s (Json.map (Enter >> lift) stateDecoder)

onLeave : (Msg -> m) -> String -> Attribute m
onLeave lift s =
  Html.Events.on s (Json.succeed (lift Leave))
  --Html.Events.on s (Json.map (Leave >> lift) stateDecoder)

for : String -> Property m
for s = Internal.Attribute (Html.Attributes.attribute "for" s)


-- onSmt : String -> Property m
-- onSmt s = Internal.Attribute (Html.Events.on s (Json.map Enter stateDecoder))

--for = Html.Attributes.for >> Internal.attribute
{- See src/Material/Button.elm for an example of, e.g., an onClick handler.
-}


type alias Elem msg = (List (Attribute msg) -> List (Html msg) -> Html msg)

type Content a =
  Content { elem : Elem a
          , attrs : List (Attribute a)
          , elements : List (Html a)
          }

wrap : Elem a -> List (Attribute a) -> List (Html a) -> Content a
wrap func attrs elems =
  Content
    { elem = func
    , attrs = attrs
    , elements = elems
    }


-- VIEW

{-| Component view.
-}
--view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view : (Msg -> m) -> Model -> List (Property m) -> (Content m) -> Html m
view lift model options elem =
  let
    summary = Options.collect defaultConfig options
    config = summary.config
    -- _ = Debug.log "ELEMENT" elem

    px : Float -> String
    px f = (toString f) ++ "px"

    unwrap c =
      case c of
        Content { elem, attrs, elements } ->
          elem (attrs ++ [onEnter lift "mouseenter", onLeave lift "mouseleave"]) elements
    --{ tag, facts, decoder, children, namespace, descendantsCount} = elem
  in
    Options.div
      []
      ((unwrap elem) ::
       [Html.div [ Html.Attributes.classList [ ("mdl-tooltip", True)
                                             , ("is-active", model.isActive)]
                 , if (not model.isActive) then
                     Helpers.noAttr
                   else
                     Html.Attributes.style
                       [ ("left", px model.left)
                       , ("marginLeft", px model.marginLeft)
                       , ("top", px model.top)
                       ]
                 ]
            [text "TOOLTIP"]
         ]
      )
    -- Options.apply summary Html.div
       -- [ cs "mdl-tooltip"]
       -- [ Just (onEnter lift "mouseenter")
       -- , Just (onLeave lift "mouseleave")

       -- ]
       -- [ text "TOOLTIP"]
    --lift <| test []
    -- Html.div
    --   [ onEnter lift "mouseenter"
    --   , onLeave lift "mouseleave"
    --   ]
    --   [text "TOOLTIp"]
      -- Options.div (cs "mdl-tooltip" :: options)
      --   [ text "TOOLTIP" ]
    -- Options.styled' Html.div
    --    (cs "mdl-tooltip" :: () ::options)
    --    []
    --    [text "TOLTIP"]
    -- Options.div
    --   ( cs "mdl-tooltip"
    --   :: options
    --   )
    -- [ text "TOOLTIP" ]


-- COMPONENT

type alias Container c =
  { c | tooltip : Indexed Model }


{-| Component render.
-}
render
  : (Parts.Msg (Container c) -> m)
  -> Parts.Index
  -> (Container c)
  -> List (Property m)
  ---> List (Html m)
  -> Content m
  -> Html m
render =
  Parts.create view update .tooltip (\x y -> {y | tooltip = x}) defaultModel

{- See src/Material/Layout.mdl for how to add subscriptions. -}
