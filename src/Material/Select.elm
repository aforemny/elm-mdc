module Material.Select exposing (..)

import DOM
import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json exposing (Decoder)
import Material.Component as Component exposing (Indexed)
import Material.Helpers as Helpers exposing (pure, map1st)
import Material.Internal.Menu exposing (Geometry, KeyCode, Key, Meta)
import Material.Internal.Options as Internal
import Material.Internal.Select exposing (Msg(..))
import Material.List as Lists
import Material.Menu as Menu
import Material.Msg exposing (Index) 
import Material.Options as Options exposing (Style, cs, css, styled, styled_, when)


-- SETUP


{-| Component subscriptions.
-}
subscriptions : Model -> Sub (Msg m)
subscriptions model =
    Sub.map MenuMsg (Menu.subscriptions model.menu)



-- MODEL


{-| Component model
-}
type alias Model =
    { menu : Menu.Model
    }


{-| Default component model
-}
defaultModel : Model
defaultModel =
    { menu = Menu.defaultModel
    }


-- ACTION, UPDATE


{-| Component action.
-}
type alias Msg m
    = Material.Internal.Select.Msg m


{-| Component update.
-}
update : (Msg msg -> msg) -> Msg msg -> Model -> ( Model, Cmd msg )
update fwd msg model =
    case msg of

        MenuMsg msg_ ->
            let
                (menu, menuCmd) =
                    Menu.update (MenuMsg >> fwd) msg_ model.menu
            in
                { model | menu = menu } ! [ menuCmd ]



-- PROPERTIES


type alias Config =
    { index : Maybe Int
    , selectedText : String
    , disabled : Bool
    }


defaultConfig : Config
defaultConfig =
    { index = Nothing
    , selectedText = ""
    , disabled = False
    }


{-| Type of Select options
-}
type alias Property m =
    Options.Property Config m


{-| TODO
-}
selectedText : String -> Property m
selectedText =
    Internal.option << (\value config -> { config | selectedText = value })


{-| TODO
-}
index : Int -> Property m
index =
    Internal.option << (\index config -> { config | index = Just index })


{-| TODO
-}
disabled : Property m
disabled =
    Internal.option (\config -> { config | disabled = True })



-- VIEW


{-| Component view.
-}
view
    : (Msg m -> m)
    -> Model
    -> List (Property m)
    -> List (Menu.Item c m)
    -> Html m
view lift model options items =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        geometry =
            model.menu.geometry
            |> Maybe.withDefault Material.Internal.Menu.defaultGeometry

        itemOffsetTop =
            List.drop (Maybe.withDefault 0 config.index) geometry.itemGeometries
            |> List.head
            |> Maybe.map .top
            |> Maybe.withDefault 0

        left =
            geometry.anchor.left

        top =
            geometry.anchor.top

        adjustedTop =
            let
                adjustedTop_ =
                    top - itemOffsetTop

                overflowsTop =
                    adjustedTop_ < 0

                overflowsBottom =
                    adjustedTop_ + geometry.itemsContainer.height > geometry.window.height
            in
                if overflowsTop then
                    0
                else
                    if overflowsBottom then
                        max 0 (geometry.window.height - geometry.itemsContainer.height)
                    else
                        adjustedTop_

        transformOrigin =
            "center " ++ toString itemOffsetTop ++ "px"
    in
    Internal.apply summary Html.div
    [ cs "mdc-select"
    , cs "mdc-select--open" |> when model.menu.open
    , css "width" "439px"
    , -- TODO: Menu.connect
      when (not config.disabled) <|
      Options.onClick (lift (MenuMsg (Material.Internal.Menu.Toggle)))
    ]
    [ Html.attribute "role" "listbox"
    , Html.tabindex 0
    ]
    [ styled Html.div
      [ cs "mdc-select__selected-text"
      , css "pointer-events" "none"
      ]
      [ text config.selectedText
      ]
    , Menu.view (MenuMsg >> lift) model.menu
      [ cs "mdc-select__menu"
      , css "bottom" "auto"
      , css "right" "auto"
      , css "left" (toString left ++ "px")
      , css "top" (toString adjustedTop ++ "px")
      , css "transform-origin" ("center " ++ toString transformOrigin ++ "px")
      , css "display" "block"
      , Menu.index (Maybe.withDefault 0 config.index)
      ]
      ( Menu.ul Lists.ul
        []
        items
      )
    ]


-- COMPONENT


type alias Store s =
    { s | select : Indexed Model }


( get, set ) =
    Component.indexed .select (\x y -> { y | select = x }) defaultModel


{-| Component react function. Internal use only.
-}
react :
    (Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react lift msg idx store =
    update lift msg (get idx store)
        |> map1st (set idx store >> Just)


{-| Component render. Below is an example, assuming boilerplate setup as
indicated in `Material`, and a user message `Select String`.

    Select.render Mdl [idx] model.mdl
      [ Select.topLeft, Select.ripple ]
      [ Select.item
        [ onSelect Select "Some item" ]
        [ text "Some item" ]
      , Select.item
        [ onSelect "Another item", Select.divider ]
        [ text "Another item" ]
      , Select.item
        [ onSelect "Disabled item", Select.disabled ]
        [ text "Disabled item" ]
      , Select.item
        [ onSelect "Yet another item" ]
        [ text "Yet another item" ]
      ]
-}
render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Menu.Item c m)
    -> Html m
render lift index store options =
    Component.render get view Material.Msg.SelectMsg lift index store
        (Internal.dispatch lift :: options)


-- TODO: use inject ^^^^^


{-| TODO
-}
subs : (Material.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Material.Msg.SelectMsg .select subscriptions


-- HELPER


decodeGeometry : Decoder Geometry
decodeGeometry =
    DOM.target      <| -- .mdc-select
    DOM.childNode 1 <| -- .mdc-simple-menu.mdc-select__menu
    Menu.decodeGeometry
