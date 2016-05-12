module Main exposing (..)
import StartApp
import Html exposing (..)
import Html.Attributes exposing (href, class, style, key)
import Platform.Cmd exposing (..)
import Task
import Task exposing (Task)
import Array exposing (Array)

import Hop
import Hop.Types
import Hop.Navigate exposing (navigateTo)
import Hop.Matchers exposing (match1)

import Material.Color as Color
import Material.Layout as Layout exposing (defaultLayoutModel)
import Material.Helpers exposing (lift, lift')
import Material.Options as Style
import Material.Scheme as Scheme

import Demo.Buttons
import Demo.Menus
import Demo.Grid
import Demo.Textfields
import Demo.Snackbar
import Demo.Badges
import Demo.Elevation
--import Demo.Toggles
--import Demo.Template


-- ROUTING 


type Route 
  = Tab Int
  | E404


type alias Routing = 
  ( Route, Hop.Types.Location )

route0 : Routing 
route0 = 
  ( Tab 0, Hop.Types.newLocation )


router : Hop.Types.Router Route
router =
  Hop.new
    { notFound = E404
    , matchers = 
        (  match1 (Tab 0) "/"
        :: (tabs |> List.indexedMap (\idx (_, path, _) -> 
              match1 (Tab idx) ("/" ++ path))
           )
        )
    }


-- MODEL


layoutModel : Layout.Model
layoutModel =
  { defaultLayoutModel
  | state = Layout.initState (List.length tabs)
  , fixedHeader = True
  }


type alias Model =
  { layout : Layout.Model
  , routing : Routing
  , buttons : Demo.Buttons.Model
  , badges : Demo.Badges.Model
  , menus : Demo.Menus.Model
  , textfields : Demo.Textfields.Model
  --, toggles : Demo.Toggles.Model
  , snackbar : Demo.Snackbar.Model
  --, template : Demo.Template.Model
  }


model : Model
model =
  { layout = layoutModel
  , routing = route0 
  , buttons = Demo.Buttons.model
  , badges = Demo.Badges.model
  , menus = Demo.Menus.model
  , textfields = Demo.Textfields.model
  --, toggles = Demo.Toggles.model
  , snackbar = Demo.Snackbar.model
  --, template = Demo.Template.model
  }



-- ACTION, UPDATE


type Msg
  -- Hop
  = ApplyRoute ( Route, Hop.Types.Location )
  | HopMsg ()
  -- Tabs
  | LayoutMsg Layout.Msg
  | BadgesMsg Demo.Badges.Msg
  | ButtonsMsg Demo.Buttons.Msg
  | MenusMsg Demo.Menus.Msg
  | TextfieldMsg Demo.Textfields.Msg
  | SnackbarMsg Demo.Snackbar.Msg
  --| TogglesMsg Demo.Toggles.Msg
--  | TemplateMsg Demo.Template.Msg


nth : Int -> List a -> Maybe a
nth k xs = 
  List.drop k xs |> List.head


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of
    LayoutMsg a ->
      let
        ( lifted, layoutFx ) =
          lift .layout (\m x -> { m | layout = x }) LayoutMsg Layout.update a model
        routeFx =
          case a of 
            Layout.SwitchTab k -> 
              nth k tabs 
              |> Maybe.map (\(_, path, _) -> Cmd.map HopMsg (navigateTo path))
              |> Maybe.withDefault Cmd.none
            _ -> 
              Cmd.none
      in
        ( lifted, Cmd.batch [ layoutFx, routeFx ] )

    ApplyRoute route -> 
      ( { model 
        | routing = route 
        , layout = setTab model.layout (fst route)
        }
      , Cmd.none
      )

    HopMsg _ ->
      ( model, Cmd.none )


    ButtonsMsg   a -> lift  .buttons    (\m x->{m|buttons   =x}) ButtonsMsg  Demo.Buttons.update    a model

    BadgesMsg    a -> lift  .badges     (\m x->{m|badges    =x}) BadgesMsg   Demo.Badges.update    a model

    MenusMsg a -> lift  .menus    (\m x->{m|menus   =x}) MenusMsg  Demo.Menus.update    a model
--
    TextfieldMsg a -> lift  .textfields (\m x->{m|textfields=x}) TextfieldMsg Demo.Textfields.update a model
--
    SnackbarMsg  a -> lift  .snackbar   (\m x->{m|snackbar  =x}) SnackbarMsg Demo.Snackbar.update   a model
--
--    TogglesMsg    a -> lift .toggles   (\m x->{m|toggles    =x}) TogglesMsg Demo.Toggles.update   a model
--
    --TemplateMsg  a -> lift  .template   (\m x->{m|template  =x}) TemplateMsg Demo.Template.update   a model

        

-- VIEW


type alias Addr =
  Signal.Address Msg


drawer : List Html
drawer =
  [ Layout.title [] [ text "Example drawer" ]
  , Layout.navigation
    [] 
    [ {- Layout.link
        [ Style.attribute 
            <| href "https://github.com/debois/elm-mdl" ]
        [ text "github" ]
    , Layout.link
        [ Style.attribute 
            <| href "http://package.elm-lang.org/packages/debois/elm-mdl/latest/" ]
        [ text "elm-package" ]
        TODO
    -} ]
  ]


header : List Html
header =
  [ Layout.row 
      []
      [ Layout.title [] [ text "elm-mdl" ]
      , Layout.spacer
      , Layout.navigation []
          [ {- TODO Layout.link
            [ 
            Style.attribute 
               <| href "https://github.com/debois/elm-mdl"]
            [ span [] [text "github"] ]
          , Layout.link 
              [ Style.attribute 
                  <| href "http://package.elm-lang.org/packages/debois/elm-mdl/latest/" ]
              [ text "elm-package" ]
            -}
          ]
      ]
  ]


tabs : List (String, String, Addr -> Model -> Html)
tabs =
  [ ("Buttons", "buttons", \addr model ->
      Demo.Buttons.view (Signal.forwardTo addr ButtonsMsg) model.buttons)
  , ("Menus", "menus", \addr model ->
      Demo.Menus.view (Signal.forwardTo addr MenusMsg) model.menus)
  , ("Badges", "badges", \addr model -> 
      Demo.Badges.view (Signal.forwardTo addr BadgesMsg) model.badges)
  , ("Elevation", "elevation", \addr model -> Demo.Elevation.view )
  , ("Grid", "grid", \addr model -> Demo.Grid.view)
  , ("Snackbar", "snackbar", \addr model ->
      Demo.Snackbar.view (Signal.forwardTo addr SnackbarMsg) model.snackbar)
  , ("Textfields", "textfields", \addr model ->
      Demo.Textfields.view (Signal.forwardTo addr TextfieldMsg) model.textfields)
--  , ("Toggles", "toggles", \addr model -> 
--      Demo.Toggles.view (Signal.forwardTo addr TogglesMsg) model.toggles)
  --, ("Template", "tempate", \addr model -> 
  --    Demo.Template.view (Signal.forwardTo addr TemplateMsg) model.template)
  ]


e404 : Addr -> Model -> Html 
e404 _ _ =  
  div 
    [ 
    ]
    [ Style.styled Html.h1
        [ Style.cs "mdl-typography--display-4" 
        , Color.background Color.primary 
        ]
        [ text "404" ]
    ]


tabViews : Array (Addr -> Model -> Html)
tabViews = List.map (\(_,_,v) -> v) tabs |> Array.fromList


tabTitles : List Html
tabTitles =
  List.map (\(x,_,_) -> text x) tabs


stylesheet : Html
stylesheet =
  Style.stylesheet """
  /* The following line is better done in html. We keep it here for
     compatibility with elm-reactor.
   */
  @import url("assets/styles/github-gist.css");

  blockquote:before { content: none; }
  blockquote:after { content: none; }
  blockquote {
    border-left-style: solid;
    border-width: 1px;
    padding-left: 1.3ex;
    border-color: rgb(255,82,82);
    font-style: normal;
      /* TODO: Really need a way to specify "secondary color" in
         inline css.
       */
  }
  p, blockquote { 
    max-width: 40em;
  }

  h1, h2 { 
    /* TODO. Need typography module with kerning. */
    margin-left: -3px;
  }

  pre { 
    background-color: #f8f8f8; 
    padding-top: .5rem;
    padding-bottom: 1rem;
    padding-left:1rem;
  }
"""


setTab : Layout.Model -> Route -> Layout.Model
setTab layout route =
  let 
    idx = 
      case route of 
        Tab k -> k
        E404 -> -1 
  in 
    { layout | selectedTab = idx }


view : Signal.Address Msg -> Model -> Html
view addr model =
  let
    top =
      div
        [ style
            [ ( "margin", "auto" )
            , ( "padding-left", "8%" )
            , ( "padding-right", "8%" )
            ]
        , key <| toString (fst model.routing)
        ]
        [ (Array.get model.layout.selectedTab tabViews
            |> Maybe.withDefault e404)
           addr
           model
        ]
  in
    Layout.view (Signal.forwardTo addr LayoutMsg) model.layout
      []
      { header = header
      , drawer = drawer
      , tabs = (tabTitles, [ Color.background (Color.color Color.Teal Color.S400) ])
      , main = [ stylesheet, top ]
      }
    {- The following lines are not necessary when you manually set up
       your html, as done with page.html. Removing it will then
       fix the flicker you see on load.
    -}
    |> (\contents -> 
      div []
        [ Scheme.topWithScheme Color.Teal Color.Red contents
        , Html.node "script"
           [ Html.Attributes.attribute "src" "assets/highlight.pack.js" ]
           []
        ]
    )


init : ( Model, Cmd.Cmd Msg )
init =
  ( model, Cmd.none )


inputs : List (Signal.Signal Msg)
inputs =
  [ Layout.setupSignals LayoutMsg
  , Signal.map ApplyRoute router.signal
  ]


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , view = view
    , update = update
    , inputs = inputs
    }


main : Signal Html
main =
  app.html


-- PORTS


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks


port routeRunTask : Task () ()
port routeRunTask =
  router.run
