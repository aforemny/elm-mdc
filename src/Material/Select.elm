module Material.Select exposing (..)

import DOM
import GlobalEvents
import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json exposing (Decoder)
import Material.Component as Component exposing (Indexed)
import Material.Internal.Options as Internal
import Material.Internal.Select exposing (Msg(..), Geometry, defaultGeometry)
import Material.List as Lists
import Material.Menu as Menu
import Material.Msg exposing (Index) 
import Material.Options as Options exposing (cs, css, styled, when)


-- SETUP


{-| Component subscriptions.
-}
subscriptions : Model -> Sub (Msg m)
subscriptions model =
    Sub.map MenuMsg (Menu.subscriptions model.menu)



-- MODEL


box : Property m
box =
    cs "mdc-select--box"


{-| Component model
-}
type alias Model =
    { menu : Menu.Model
    , geometry : Maybe Geometry
    }


{-| Default component model
-}
defaultModel : Model
defaultModel =
    { menu = Menu.defaultModel
    , geometry = Nothing
    }


-- ACTION, UPDATE


{-| Component action.
-}
type alias Msg m
    = Material.Internal.Select.Msg m


{-| Component update.
-}
update : (Msg msg -> msg) -> Msg msg -> Model -> ( Maybe Model, Cmd msg )
update lift msg model =
    case msg of

        MenuMsg msg_ ->
            let
                (menu, menuCmd) =
                    Menu.update (lift << MenuMsg) msg_ model.menu
            in
            case menu of
                Just menu ->
                    ( Just { model | menu = menu }, menuCmd )
                Nothing ->
                    ( Nothing, menuCmd )

        Init geometry ->
            ( Just { model | geometry = Just geometry }, Cmd.none )



-- PROPERTIES


type alias Config =
    { label : String
    , index : Maybe Int
    , selectedText : Maybe String
    , disabled : Bool
    }


defaultConfig : Config
defaultConfig =
    { label = ""
    , index = Nothing
    , selectedText = Nothing
    , disabled = False
    }


{-| Type of Select options
-}
type alias Property m =
    Options.Property Config m


{-| TODO
-}
label : String -> Property m
label =
    Internal.option << (\value config -> { config | label = value })


{-| TODO
-}
index : Int -> Property m
index index =
    Internal.option (\config -> { config | index = Just index })


{-| TODO
-}
selectedText : String -> Property m
selectedText selectedText =
    Internal.option (\ config -> { config | selectedText = Just selectedText })


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
            Maybe.withDefault defaultGeometry model.geometry

        itemOffsetTop =
            List.drop (Maybe.withDefault 0 config.index) geometry.itemOffsetTops
            |> List.head
            |> Maybe.withDefault 0

        left =
            geometry.boundingClientRect.left

        top =
            geometry.boundingClientRect.top

        adjustedTop =
            let
                adjustedTop_ =
                    top - itemOffsetTop

                overflowsTop =
                    adjustedTop_ < 0

                overflowsBottom =
                    adjustedTop_ + geometry.menuHeight > geometry.windowInnerHeight
            in
                if overflowsTop then
                    0
                else
                    if overflowsBottom then
                        max 0 (geometry.windowInnerHeight - geometry.menuHeight)
                    else
                        adjustedTop_

        transformOrigin =
            "center " ++ toString itemOffsetTop ++ "px"

        isOpen =
          if model.menu.animating then
              model.menu.open && (model.menu.geometry /= Nothing)
          else
              model.menu.open
    in
    Internal.apply summary Html.div
    [ cs "mdc-select"
    , cs "mdc-select--open" |> when isOpen
    , when (model.menu.animating && model.menu.geometry == Nothing)
      << Options.many << List.map Options.attribute <|
      GlobalEvents.onTick (Json.map (lift << Init) decodeGeometry)
    , Menu.connect (lift << MenuMsg) |> when (not config.disabled)
    , cs "mdc-select--disabled" |> when config.disabled
    ]
    [ Html.attribute "role" "listbox"
    , Html.tabindex 0
    ]
    [ styled Html.div
      [ cs "mdc-select__surface"
      ]
      [
        styled Html.div
        [ cs "mdc-select__label"
        , cs "mdc-select__label--float-above" |> when (model.menu.open || (config.selectedText /= Nothing))
        ]
        [ text config.label
        ]
      ,
        styled Html.div
        [ cs "mdc-select__selected-text"
        , css "pointer-events" "none"
        ]
        [ text (Maybe.withDefault "" config.selectedText)
        ]
      ,
        styled Html.div
        [ cs "mdc-select__bottom-line"
        , cs "mdc-select__bottom-line--active" |> when model.menu.open
        ]
        []
      ]
    ,
      Menu.view (lift << MenuMsg) model.menu
      [ cs "mdc-select__menu"
      , Menu.index (Maybe.withDefault 0 config.index)
      , when isOpen << Options.many <|
        [ css "position" "fixed"
        , css "transform-origin" transformOrigin
        , css "left" (toString left ++ "px")
        , css "top" (toString adjustedTop ++ "px")
        , css "bottom" "unset"
        , css "right" "unset"
        ]
      ]
      ( Menu.ul Lists.ul [] items
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
    (Material.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.SelectMsg update


{-| Component render. Below is an example, assuming boilerplate setup as
indicated in `Material`, and a user message `Select String`.
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
    let
        windowScroll =
            Json.at ["ownerDocument", "defaultView"] <|
            Json.map2
              (\ scrollX scrollY ->
                { scrollX = scrollX
                , scrollY = scrollY
                }
              )
              (Json.at ["scrollX"] Json.float)
              (Json.at ["scrollY"] Json.float)

        windowInnerHeight =
            Json.at ["ownerDocument", "defaultView"] (Json.at ["innerHeight"] Json.float)

        boundingClientRect { scrollX, scrollY } =
            DOM.boundingClientRect
            |> Json.map (\ rectangle ->
                 { top = rectangle.top - scrollY
                 , left = rectangle.left - scrollX
                 , width = rectangle.width
                 , height = rectangle.height
                 }
               )

        menuHeight =
            DOM.childNode 1 DOM.offsetHeight

        itemOffsetTops =
            DOM.childNode 1 <|   -- .mdc-select__menu
            DOM.childNode 0 <|   -- .mdc-menu__items
            DOM.childNodes DOM.offsetTop
    in
    DOM.target
    ( windowScroll
      |> Json.andThen (\ windowScroll ->
           Json.map4 Geometry
               windowInnerHeight
               (boundingClientRect windowScroll)
               menuHeight
               itemOffsetTops
         )
    )
