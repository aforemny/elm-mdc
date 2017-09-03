module Material
    exposing
        ( Model
        , defaultModel
        , Msg
        , update
        , subscriptions
        , init
        , top
        )

import Dict
import Html.Attributes as Html
import Html exposing (Html, text)
import Material.Button as Button
import Material.Checkbox as Checkbox
import Material.Component as Component exposing (Indexed)
import Material.Dispatch as Dispatch
import Material.Drawer as Drawer
import Material.Fab as Fab
import Material.Helpers exposing (map1st)
import Material.IconToggle as IconToggle
import Material.Menu as Menu
import Material.Msg exposing (Msg(..))
import Material.RadioButton as RadioButton
import Material.Ripple as Ripple
import Material.Select as Select
import Material.Slider as Slider
import Material.Snackbar as Snackbar
import Material.Switch as Switch
import Material.Tabs as Tabs
import Material.Textfield as Textfield
import Material.Toolbar as Toolbar


type alias Model = 
    { button : Indexed Button.Model
    , radio : Indexed RadioButton.Model
    , drawer : Indexed Drawer.Model
    , iconToggle : Indexed IconToggle.Model
    , fab : Indexed Fab.Model
    , textfield : Indexed Textfield.Model
    , menu : Indexed Menu.Model
    , checkbox : Indexed Checkbox.Model
    , switch : Indexed Switch.Model
    , tabs : Indexed Tabs.Model
    , select : Indexed Select.Model
    , ripple : Indexed Ripple.Model
    , snackbar : Indexed Snackbar.Model
    , slider : Indexed Slider.Model
    , toolbar : Indexed Toolbar.Model
    }


defaultModel : Model
defaultModel = 
    { button = Dict.empty
    , radio = Dict.empty
    , drawer = Dict.empty
    , iconToggle = Dict.empty
    , fab = Dict.empty
    , textfield = Dict.empty
    , menu = Dict.empty
    , checkbox = Dict.empty
    , switch = Dict.empty
    , tabs = Dict.empty
    , select = Dict.empty
    , ripple = Dict.empty
    , snackbar = Dict.empty
    , slider = Dict.empty
    , toolbar = Dict.empty
    }


type alias Msg m =
    Material.Msg.Msg m


update : (Msg m -> m) -> Msg m -> { c | mdl : Model } -> (  { c | mdl : Model }, Cmd m )
update lift msg container =
  update_ lift msg (.mdl container)
      |> map1st (Maybe.map (\mdl -> { container | mdl = mdl }))
      |> map1st (Maybe.withDefault container)


update_ : (Msg m -> m) -> Msg m -> Model -> ( Maybe Model, Cmd m )
update_ lift msg store =
    case msg of
       Dispatch msgs -> 
           (Nothing, Dispatch.forward msgs)

       ButtonMsg idx msg ->
           Button.react lift msg idx store

       ToolbarMsg idx msg ->
           Toolbar.react lift msg idx store

       RadioButtonMsg idx msg ->
           RadioButton.react lift msg idx store

       DrawerMsg idx msg ->
           Drawer.react lift msg idx store

       IconToggleMsg idx msg ->
           IconToggle.react lift msg idx store

       SnackbarMsg idx msg ->
           Snackbar.react (SnackbarMsg idx >> lift) msg idx store

       FabMsg idx msg ->
           Fab.react lift msg idx store

       TextfieldMsg idx msg ->
           Textfield.react lift msg idx store

       MenuMsg idx msg ->
           Menu.react (MenuMsg idx >> lift) msg idx store

       SelectMsg idx msg ->
           Select.react (SelectMsg idx >> lift) msg idx store

       CheckboxMsg idx msg ->
           Checkbox.react lift msg idx store

       SwitchMsg idx msg ->
           Switch.react lift msg idx store

       SliderMsg idx msg ->
           Slider.react (SliderMsg idx >> lift) msg idx store
           -- TODO: change all components to do this? ^^^^

       TabsMsg idx msg ->
           Tabs.react (TabsMsg idx >> lift) msg idx store

       RippleMsg idx msg ->
           Ripple.react lift msg idx store


subscriptions : (Msg m -> m) -> { model | mdl : Model } -> Sub m
subscriptions lift model =
    Sub.batch
        [ Drawer.subs lift model.mdl
        , Menu.subs lift model.mdl
        , Select.subs lift model.mdl
        , Slider.subs lift model.mdl
        , Tabs.subs lift model.mdl
        , Toolbar.subs lift model.mdl
        ]


init : (Msg m -> m) -> Cmd m
init lift =
    Cmd.none
    -- TODO: Layout init, etc.

--    Task.perform (\_ -> lift (Scroll { pageX = 0, pageY = 0 })) <|
--    Dom.onDocument
--      "scroll"
--      ( Json.map (Scroll >> lift) <|
--        Json.map2 (\pageX pageY -> { pageX = pageX, pageY = pageY })
--          ( Json.at [ "pageX" ] Json.int )
--          ( Json.at [ "pageY" ] Json.int )
--      )
--      ( \_ -> Task.succeed () )


top : Html a -> Html a
top content =
    Html.div []
    [
      content

    , Html.node "style"
      [ Html.type_ "text/css"
      ]
      [ [ "https://fonts.googleapis.com/css?family=Roboto+Mono"
        , "https://fonts.googleapis.com/icon?family=Material+Icons"
        , "https://fonts.googleapis.com/css?family=Roboto:300,400,500"
        , "https://raw.githubusercontent.com/aforemny/elm-mdc/master/material-components-web.css"
        , "https://raw.githubusercontent.com/aforemny/elm-mdc/master/dialog-polyfill.css"
        ]
        |> List.map (\url ->
               "@import url(" ++ url ++ ");"
           )
        |> String.join "\n"
        |> text
      ]

    , Html.node "script"
      [ Html.type_ "text/javascript"
      , Html.src "https://raw.githubusercontent.com/aforemny/elm-mdc/master/dialog-polyfill.js"
      ]
      []

    , -- node insertion, credits (https://davidwalsh.name/detect-node-insertion):
      Html.node "script"
      [ Html.type_ "text/javascript"
      ]
      [ text """
var insertListener = function(event) {
  if (event.animationName == "nodeInserted") {
    console.warn("Another node has been inserted! ", event, event.target);
    event.target.dispatchEvent(new Event('elm-mdc-init'));
  }
}

document.addEventListener("animationstart", insertListener, false); // standard + firefox
document.addEventListener("MSAnimationStart", insertListener, false); // IE
document.addEventListener("webkitAnimationStart", insertListener, false); // Chrome + Safari
"""
      ]

    , Html.node "script"
      [ Html.type_ "text/css"
      ]
      [ text """
@keyframes nodeInserted {
  from { opacity: 0.99; }
  to { opacity: 1; }
}

.elm-mdc-slider--uninitialized,
.elm-mdc-tab-bar--uninitialized,
.elm-mdc-toolbar--uninitialized,
.elm-mdc-simple-menu--uninitialized
{
  animation-duration: 0.001s;
  animation-name: nodeInserted;
}
"""
      ]
    ]
