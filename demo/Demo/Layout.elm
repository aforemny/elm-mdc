module Demo.Layout exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)

import Material.Toggles as Toggles
import Material 

import Demo.Page as Page


-- MODEL


type alias Mdl = 
  Material.Model 


type HeaderType 
  = Waterfool Bool
  | Seamed
  | Standard
  | Scrolling


type alias Model =
  { mdl : Material.Model
  , fixedHeader : Bool
  , fixedDrawer : Bool
  , fixedTabs : Bool
  , header : Maybe HeaderType
  , rippleTabs : Bool
  , transparentHeader : Bool
  }


model : Model
model =
  { mdl = Material.model
  , fixedHeader = False
  , fixedTabs = False
  , fixedDrawer = False
  , header = Just Standard
  , rippleTabs = True
  , transparentHeader = False
  }


-- ACTION, UPDATE


type Msg 
  = TemplateMsg 
  | Update (Model -> Model)
  | Mdl Material.Msg 


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    TemplateMsg -> 
      (model, Cmd.none)

    Update f -> 
      (f model, Cmd.none)

    Mdl action' -> 
      Material.update Mdl action' model


-- VIEW



view : Model -> Html Msg
view model  =
  [ div 
      [] 
      [ span []
          [ Toggles.checkbox Mdl [0] model.mdl
              [ Toggles.onChange (Update <| \m -> { m | fixedHeader = not m.fixedHeader })
              , Toggles.value model.fixedHeader
              ]
          , text "Fixed header"
          ]
      ]
  ]
  |> Page.body2 "Layout" srcUrl intro references


intro : Html m
intro = 
  Page.fromMDL "https://getmdl.io/components/index.html#layout-section/layout" """
> The Material Design Lite (MDL) layout component is a comprehensive approach to
> page layout that uses MDL development tenets, allows for efficient use of MDL
> components, and automatically adapts to different browsers, screen sizes, and
> devices.
> 
> Appropriate and accessible layout is a critical feature of all user interfaces,
> regardless of a site's content or function. Page design and presentation is
> therefore an important factor in the overall user experience. See the layout
> component's Material Design specifications page for details.
> 
> Use of MDL layout principles simplifies the creation of scalable pages by
> providing reusable components and encourages consistency across environments by
> establishing recognizable visual elements, adhering to logical structural
> grids, and maintaining appropriate spacing across multiple platforms and screen
> sizes. MDL layout is extremely powerful and dynamic, allowing for great
> consistency in outward appearance and behavior while maintaining development
> flexibility and ease of use.
""" 


srcUrl : String 
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Layout.elm"


references : List (String, String)
references = 
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Layout"
  , Page.mds "http://www.google.com/design/spec/layout/principles.html"
  , Page.mdl "https://www.getmdl.io/components/index.html#layout-section/layout"
  ]


