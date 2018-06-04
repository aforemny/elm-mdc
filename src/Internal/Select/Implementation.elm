module Internal.Select.Implementation exposing
    ( box
    , disabled
    , index
    , label
    , Property
    , react
    , selectedText
    , subs
    , view
    )

import DOM
import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json exposing (Decoder)
import Internal.Component as Component exposing (Indexed, Index)
import Internal.GlobalEvents as GlobalEvents
import Internal.Menu.Implementation as Menu
import Internal.Menu.Model as Menu
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Internal.Select.Model exposing (Model, defaultModel, Msg(..), Geometry, defaultGeometry)


subscriptions : Model -> Sub (Msg m)
subscriptions model =
    Sub.map (MenuMsg Nothing) (Menu.subscriptions model.menu)


update : (Msg msg -> msg) -> Msg msg -> Model -> ( Maybe Model, Cmd msg )
update lift msg model =
    case msg of

        MenuMsg index msg_ ->
            let
                (menu, menuCmd) =
                    Menu.update (lift << MenuMsg index) msg_ model.menu
            in
            case menu of
                Just menu ->
                    ( Just
                        { model
                            | menu = menu
                            , index =
                                case msg_ of
                                    Menu.Toggle ->
                                        if not model.menu.open then
                                            index
                                        else
                                            Nothing
                                    _ ->
                                        model.index
                        }
                    , menuCmd
                    )
                Nothing ->
                    ( Nothing, menuCmd )

        Init geometry ->
            ( Just { model | geometry = Just geometry }, Cmd.none )



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


type alias Property m =
    Options.Property Config m


label : String -> Property m
label =
    Options.option << (\value config -> { config | label = value })


index : Int -> Property m
index index =
    Options.option (\config -> { config | index = Just index })


selectedText : String -> Property m
selectedText selectedText =
    Options.option (\ config -> { config | selectedText = Just selectedText })


disabled : Property m
disabled =
    Options.option (\config -> { config | disabled = True })


box : Property m
box =
    cs "mdc-select--box"


select
    : (Msg m -> m)
    -> Model
    -> List (Property m)
    -> List (Menu.Item m)
    -> Html m
select lift model options items =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        geometry =
            Maybe.withDefault defaultGeometry model.geometry

        itemOffsetTop =
            model.index
            |> Maybe.andThen (\index ->
                List.drop (Maybe.withDefault 0 model.index) geometry.itemOffsetTops
                |> List.head
               )
            |> Maybe.map Just
            |> Maybe.withDefault (
                List.drop (Maybe.withDefault 0 config.index) geometry.itemOffsetTops
                |> List.head
               )
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
    Options.apply summary Html.div
    [ cs "mdc-select"
    , cs "mdc-select--open" |> when isOpen
    , when (model.menu.animating && model.menu.geometry == Nothing) <|
      GlobalEvents.onTickWith
          { targetRect = True
          , parentRect = False
          }
          (Json.map (lift << Init) decodeGeometry)
    , Menu.connect (lift << MenuMsg config.index) |> when (not config.disabled)
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
      Menu.menu (lift << MenuMsg config.index) model.menu
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
      ( Menu.ul [] items
      )
    ]


type alias Store s =
    { s | select : Indexed Model }


( get, set ) =
    Component.indexed .select (\x y -> { y | select = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Internal.Msg.SelectMsg update


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Menu.Item m)
    -> Html m
view =
    Component.render get select Internal.Msg.SelectMsg


subs : (Internal.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Internal.Msg.SelectMsg .select subscriptions


decodeGeometry : Decoder Geometry
decodeGeometry =
    let
        windowInnerHeight =
            Json.at ["ownerDocument", "defaultView"] (Json.at ["innerHeight"] Json.float)

        boundingClientRect =
            Json.at ["targetRect"] <|
            Json.map4 (\top left width height ->
                 { top = top
                 , left = left
                 , width = width
                 , height = height
                 }
               )
            (Json.at ["top"] Json.float)
            (Json.at ["left"] Json.float)
            (Json.at ["width"] Json.float)
            (Json.at ["height"] Json.float)

        menuHeight =
            DOM.childNode 1 DOM.offsetHeight

        itemOffsetTops =
            DOM.childNode 1 <|   -- .mdc-select__menu
            DOM.childNode 0 <|   -- .mdc-menu__items
            DOM.childNodes DOM.offsetTop
    in
    boundingClientRect
    |> Json.andThen (\boundingClientRect ->
    Json.map3 (Geometry boundingClientRect)
        (DOM.target windowInnerHeight)
        (DOM.target menuHeight)
        (DOM.target itemOffsetTops)
      )
