module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, h3, p, text)
import Html.Attributes exposing (href)

import Material
import Material.Drawer.Modal as Drawer
import Material.List as Lists
import Material.Options as Options exposing (styled, when)
import Material.TopAppBar as TopAppBar


type alias Model =
    { mdc : Material.Model Msg
    , drawer_open : Bool
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    , drawer_open = False
    }


type Msg
    = Mdc (Material.Msg Msg)
    | OpenDrawer
    | CloseDrawer


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( defaultModel, Material.init Mdc )


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdc model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdc msg_ ->
            Material.update Mdc msg_ model

        OpenDrawer ->
            ( { model | drawer_open = True }, Cmd.none )

        CloseDrawer ->
            ( { model | drawer_open = False }, Cmd.none )



view : Model -> Html Msg
view model =
    Html.div [  ]
        [ viewTopAppBar model
        , viewDrawer model
        , Drawer.scrim [ Options.onClick CloseDrawer ] []
        , styled Html.main_ [ TopAppBar.fixedAdjust ] [ viewContent ]
        ]


viewTopAppBar : Model -> Html Msg
viewTopAppBar model =
    TopAppBar.view Mdc
        "my-top-app-bar"
        model.mdc
        []
        [ TopAppBar.section
            [ TopAppBar.alignStart
            ]
            [ TopAppBar.navigationIcon Mdc "my-top-app-bar--menu" model.mdc
                  [ Options.onClick OpenDrawer ]
                  "menu"
            , TopAppBar.title [] [ text "Basic App Example" ]
            ]
        ]


viewDrawer : Model -> Html Msg
viewDrawer model =
    Drawer.view Mdc
        "my-drawer"
        model.mdc
        [ Drawer.open |> when model.drawer_open
        , Drawer.onClose CloseDrawer
        ]
        [ Drawer.header
            []
            [ styled h3 [ Drawer.title ] [ text "A Header" ]
            ]
        , Drawer.content []
            [ Lists.nav Mdc "my-drawer-list" model.mdc [ ]
                  [ drawerLink "Dashboard"
                  , drawerLink  "My account"
                  , Lists.hr [] []
                  , drawerLink "Logout"
                  ]
            ]
        ]


drawerLink : String -> Lists.ListItem Msg
drawerLink linkContent =
    Lists.a
        [ Options.attribute (href "#")
        , Lists.activated |> when isActive
        ]
    [ text linkContent ]


isActive : Bool
isActive = False



viewContent =
    div []
        [ h1 [] [ text "My content" ]
        , p [] [ text "My body text goes here." ] ]
