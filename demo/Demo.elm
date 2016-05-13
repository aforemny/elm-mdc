module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Html.App as App
import Platform.Cmd exposing (..)
import Array exposing (Array)

{-
import Hop
import Hop.Types
import Hop.Navigate exposing (navigateTo)
import Hop.Matchers exposing (match1)
-}

import Material.Color as Color
import Material.Layout as Layout exposing (defaultLayoutModel)
import Material.Helpers exposing (lift, lift', key)
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
{-
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
-}

-- MODEL



type alias Model =
  { layout : Layout.Model
  --, routing : Routing
  , buttons : Demo.Buttons.Model
  , badges : Demo.Badges.Model
  , menus : Demo.Menus.Model
  , textfields : Demo.Textfields.Model
  --, toggles : Demo.Toggles.Model
  , snackbar : Demo.Snackbar.Model
  --, template : Demo.Template.Model
  , selectedTab : Int
  }


model : Model
model =
  { layout = defaultLayoutModel
  --, routing = route0 
  , buttons = Demo.Buttons.model
  , badges = Demo.Badges.model
  , menus = Demo.Menus.model
  , textfields = Demo.Textfields.model
  --, toggles = Demo.Toggles.model
  , snackbar = Demo.Snackbar.model
  --, template = Demo.Template.model
  , selectedTab = 0
  }



-- ACTION, UPDATE


type Msg
  = 
  -- Hop
  {- = ApplyRoute ( Route, Hop.Types.Location )
  | HopMsg ()
  | 
 -} 
    LayoutMsg Layout.Msg
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
    {-
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
-}
    LayoutMsg    a -> lift  .layout     (\m x->{m|layout    =x}) LayoutMsg   Layout.update          a model

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


drawer : List (Html Msg)
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


header : List (Html a)
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


tabs : List (String, String, Model -> Html Msg)
tabs =
  [ ("Buttons", "buttons", .buttons >> Demo.Buttons.view >> App.map ButtonsMsg)
  , ("Menus", "menus", .menus >> Demo.Menus.view >> App.map MenusMsg)
  , ("Badges", "badges", .badges >> Demo.Badges.view >> App.map BadgesMsg)
  , ("Elevation", "elevation", \_ -> Demo.Elevation.view)
  , ("Grid", "grid", \_ -> Demo.Grid.view)
  , ("Snackbar", "snackbar", .snackbar >> Demo.Snackbar.view >> App.map SnackbarMsg)
  , ("Textfields", "textfields", .textfields >> Demo.Textfields.view >> App.map TextfieldMsg)
--  , ("Toggles", "toggles", \model -> 
--      Demo.Toggles.view (Signal.forwardTo addr TogglesMsg) model.toggles)
  --, ("Template", "tempate", \model -> 
  --    Demo.Template.view (Signal.forwardTo addr TemplateMsg) model.template)
  ]


e404 : Model -> Html Msg
e404 _ =  
  div 
    [ 
    ]
    [ Style.styled Html.h1
        [ Style.cs "mdl-typography--display-4" 
        , Color.background Color.primary 
        ]
        [ text "404" ]
    ]


tabViews : Array (Model -> Html Msg)
tabViews = List.map (\(_,_,v) -> v) tabs |> Array.fromList


tabTitles : List (Html a)
tabTitles =
  List.map (\(x,_,_) -> text x) tabs


stylesheet : Html a
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


{-
setTab : Layout.Model -> Route -> Layout.Model
setTab layout route =
  let 
    idx = 
      case route of 
        Tab k -> k
        E404 -> -1 
  in 
    { layout | selectedTab = idx }
-}


view : Model -> Html Msg
view model =
  let
    top =
      div
        [ style
            [ ( "margin", "auto" )
            , ( "padding-left", "8%" )
            , ( "padding-right", "8%" )
            ]
        -- TODO: I don't see why the line below is necessary
        --, key <| toString (fst model.routing)
        ]
        [ (Array.get model.selectedTab tabViews
            |> Maybe.withDefault e404)
           model
        ]
  in
    Layout.view LayoutMsg model.layout
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

main : Program Never
main =
  App.program 
    { init = ( model, none ) 
    , view = view
    , subscriptions = always <| Layout.subscriptions LayoutMsg
    , update = update
    }



