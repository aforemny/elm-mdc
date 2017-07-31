module Demo.Layout exposing (..)

import Dom.Scroll
import Task
import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Events
import String
import Array exposing (Array)
import Material.Toggles as Toggles
import Material.Options as Options exposing (css, cs, when)
import Material
import Material.Layout as Layout
import Material.Grid as Grid
import Material.Color as Color
import Material.Button as Button
import Material.Elevation as Elevation
import Material.Typography as Typography


-- MODEL


type HeaderType
    = Waterfall Bool
    | Seamed
    | Standard
    | Scrolling


type alias Model =
    { mdl : Material.Model
    , fixedHeader : Bool
    , fixedDrawer : Bool
    , fixedTabs : Bool
    , header : HeaderType
    , rippleTabs : Bool
    , transparentHeader : Bool
    , withDrawer : Bool
    , withHeader : Bool
    , withTabs : Bool
    , primary : Color.Hue
    , accent : Color.Hue
    }


model : Model
model =
    { mdl = Material.model
    , fixedHeader = True
    , fixedTabs = False
    , fixedDrawer = False
    , header = Standard
    , rippleTabs = True
    , transparentHeader = False
    , withDrawer = True
    , withHeader = True
    , withTabs = True
    , primary = Color.Teal
    , accent = Color.Red
    }



-- ACTION, UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | ScrollToTop
    | Nop
    | SetPrimaryColor Color.Hue
    | SetAccentColor Color.Hue
    | ToggleHeader
    | ToggleDrawer
    | ToggleTabs
    | ToggleFixedHeader
    | ToggleFixedDrawer
    | ToggleFixedTabs
    | SetHeader HeaderType


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        ScrollToTop ->
            model ! [ Task.attempt (always Nop) <| Dom.Scroll.toTop Layout.mainId ]

        Nop ->
            model ! [] 

        SetPrimaryColor hue -> 
            fixColors { model | primary = hue } ! [] 

        SetAccentColor hue -> 
            { model | accent = hue } ! [] 

        ToggleHeader -> 
            { model | withHeader = not model.withHeader } ! [] 

        ToggleDrawer -> 
            { model | withDrawer = not model.withDrawer } ! [] 

        ToggleTabs -> 
            { model | withTabs = not model.withTabs } ! [] 

        ToggleFixedHeader -> 
            { model | fixedHeader = not model.fixedHeader } ! [] 

        ToggleFixedDrawer -> 
            { model | fixedDrawer = not model.fixedDrawer } ! [] 

        ToggleFixedTabs -> 
            { model | fixedTabs = not model.fixedTabs } ! [] 

        SetHeader h -> 
            { model | header = h } ! [] 


{- Make sure we didn't pick the same primary and accent colour. -}
fixColors : Model -> Model
fixColors model =
    if model.primary == model.accent then
        if model.primary == Color.Indigo then
            { model | accent = Color.Red }
        else
            { model | accent = Color.Indigo }
    else
        model



-- VIEW


view : Model -> Html Msg
view model =
    div [] []
