module Demo.Lists exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Material.Lists as Lists
import Material
import Material.Options as Options
import Material.Icon as Icon
import Material.Toggles as Toggles
import Demo.Page as Page
import Demo.Code as Code


-- MODEL


type alias Mdl =
    Material.Model


type alias Model =
    { mdl : Material.Model
    }


model : Model
model =
    { mdl = Material.model
    }



-- ACTION, UPDATE


type Msg
    = ListsMsg
    | Mdl Material.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        ListsMsg ->
            ( model, Cmd.none )

        Mdl action' ->
            Material.update Mdl action' model



-- VIEW


simpleList : Model -> Html Msg
simpleList model =
    Lists.ul [ Options.css "width" "300px" ]
        [ Lists.li []
            [ Options.span [ Lists.primaryContent ] [ text "Bryan Cranston" ]
            ]
        , Lists.li []
            [ Options.span [ Lists.primaryContent ] [ text "Aaron Paul" ]
            ]
        , Lists.li []
            [ Options.span [ Lists.primaryContent ] [ text "Bob Odenkirk" ]
            ]
        ]


icons : Model -> Html Msg
icons model =
    Lists.ul [ Options.css "width" "300px" ]
        [ Lists.li []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.icon ]
                , text "Bryan Cranston"
                ]
            ]
        , Lists.li []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.icon ]
                , text "Aaron Paul"
                ]
            ]
        , Lists.li []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.icon ]
                , text "Bob Odenkirk"
                ]
            ]
        ]


avatarsAndActions : Model -> Html Msg
avatarsAndActions model =
    Lists.ul [ Options.css "width" "300px" ]
        [ Lists.li []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.avatar ]
                , Options.span [] [ text "Bryan Cranston" ]
                ]
            , Options.styled Html.a [ Lists.secondaryAction ] [ Options.styled Html.i [] [ Icon.view "star" [] ] ]
            ]
        , Lists.li []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.avatar ]
                , Options.span [] [ text "Aaron Paul" ]
                ]
            , Options.styled Html.a [ Lists.secondaryAction ] [ Options.styled Html.i [] [ Icon.view "star" [] ] ]
            ]
        , Lists.li []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.avatar ]
                , Options.span [] [ text "Bob Odenkirk" ]
                ]
            , Options.styled Html.a [ Lists.secondaryAction ] [ Options.styled Html.i [] [ Icon.view "star" [] ] ]
            ]
        ]


avatarsAndControls : Model -> Html Msg
avatarsAndControls model =
    Lists.ul [ Options.css "width" "300px" ]
        [ Lists.li []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.avatar ]
                , text "Bryan Cranston"
                ]
            , Options.span [ Lists.secondaryAction ]
                [ Toggles.checkbox Mdl
                    [ 0 ]
                    model.mdl
                    [ Toggles.value True
                    ]
                    []
                ]
            ]
        , Lists.li []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.avatar ]
                , text "Aaron Paul"
                ]
            , Options.span [ Lists.secondaryAction ]
                [ Toggles.radio Mdl
                    [ 0 ]
                    model.mdl
                    [ Toggles.value False
                    , Options.css "display" "inline"
                    ]
                    []
                ]
            ]
        , Lists.li []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.avatar ]
                , text "Bob Odenkirk"
                ]
            , Options.span [ Lists.secondaryAction ]
                [ Toggles.switch Mdl
                    [ 0 ]
                    model.mdl
                    [ Toggles.value True
                    ]
                    []
                ]
            ]
        ]


twoLines : Model -> Html Msg
twoLines model =
    Lists.ul [ Options.css "width" "300px" ]
        [ Lists.li2 []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.avatar ]
                , Options.span [] [ text "Bryan Cranston" ]
                , Options.span [ Lists.subTitle ] [ text "62 Episodes" ]
                ]
            , Options.span [ Lists.secondaryContent ]
                [ Options.span [ Lists.secondaryInfo ] [ text "Actor" ]
                , Options.styled Html.a [ Lists.secondaryAction ] [ Icon.view "star" [] ]
                ]
            ]
        , Lists.li2 []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.avatar ]
                -- [ Options.styled Html.i [ Lists.avatar ] [ Icon.view "person" [ Icon.size36 ] ]
                , Options.span [] [ text "Aaron Paul" ]
                , Options.span [ Lists.subTitle ] [ text "62 Episodes" ]
                ]
            , Options.span [ Lists.secondaryContent ]
                [ Options.span [ Lists.secondaryInfo ] [ text "Actor" ]
                , Options.styled Html.a [ Lists.secondaryAction ] [ Icon.view "star" [] ]
                ]
            ]
        , Lists.li2 []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.avatar ]
                , Options.span [] [ text "Bob Odenkirk" ]
                , Options.span [ Lists.subTitle ] [ text "62 Episodes" ]
                ]
            , Options.span [ Lists.secondaryContent ]
                [ Options.span [ Lists.secondaryInfo ] [ text "Actor" ]
                , Options.styled Html.a [ Lists.secondaryAction ] [ Icon.view "star" [] ]
                ]
            ]
        ]


threeLines : Model -> Html Msg
threeLines model =
    Lists.ul [ Options.css "width" "650px" ]
        [ Lists.li3 []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.avatar ]
                , Options.span [] [ text "Bryan Cranston" ]
                , Options.span [ Lists.textBody ] [ text "Bryan Cranston played the role of Walter in Breaking Bad. He is also known for playing Hal in Malcom in the Middle." ]
                ]
            , Options.span [ Lists.secondaryContent ]
                [ Options.span [ Lists.secondaryInfo ] [ text "Actor" ]
                , Options.styled Html.a [ Lists.secondaryAction ] [ Icon.view "star" [] ]
                ]
            ]
        , Lists.li3 []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.avatar ]
                , Options.span [] [ text "Aaron Paul" ]
                , Options.span [ Lists.textBody ] [ text "Aaron Paul played the role of Jesse in Breaking Bad. He also featured in the Need For Speed Movie." ]
                ]
            , Options.span [ Lists.secondaryContent ]
                [ Options.span [ Lists.secondaryInfo ] [ text "Actor" ]
                , Options.styled Html.a [ Lists.secondaryAction ] [ Icon.view "star" [] ]
                ]
            ]
        , Lists.li3 []
            [ Options.span [ Lists.primaryContent ]
                [ Icon.view "person" [ Icon.size36, Lists.avatar ]
                , Options.span [] [ text "Bob Odenkirk" ]
                , Options.span [ Lists.textBody ] [ text "Bob Odinkrik played the role of Saul in Breaking Bad. Due to public fondness for the character, Bob stars in his own show now, called Better Call Saul." ]
                ]
            , Options.span [ Lists.secondaryContent ]
                [ Options.span [ Lists.secondaryInfo ] [ text "Actor" ]
                , Options.styled Html.a [ Lists.secondaryAction ] [ Icon.view "star" [] ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    [ div
        []
        [ h4 [] [ text "Simple list" ]
        , simpleList model
        , h5 [] [ text "Example code for simple list:" ]
        , code
        , h4 [] [ text "Icon list" ]
        , icons model
        , h4 [] [ text "Avatars and Actions" ]
        , avatarsAndActions model
        , h4 [] [ text "Avatars and Controls" ]
        , avatarsAndControls model
        , h4 [] [ text "Two lines" ]
        , twoLines model
        , h4 [] [ text "Three lines" ]
        , threeLines model
        ]
    ]
        |> Page.body2 "Lists" srcUrl intro references


intro : Html m
intro =
    Page.fromMDL "https://www.getmdl.io/components/index.html#lists-section" """\x0D
> Lists present multiple line items vertically as a single continuous element.\x0D
> Refer the Material Design Spec to know more about the content options.\x0D
"""


srcUrl : String
srcUrl =
    "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Lists.elm"


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Lists"
    , Page.mds "https://material.google.com/components/lists.html"
    , Page.mdl "https://www.getmdl.io/components/index.html#lists"
    ]


code : Html msg
code =
    Code.code """
    Lists.ul [ Options.css "width" "300px" ]
        [ Lists.li []
            [ Options.span [ Lists.itemprimaryContent ] [ text "Bryan Cranston" ]
            ]
        , Lists.li []
            [ Options.span [ Lists.itemprimaryContent ] [ text "Aaron Paul" ]
            ]
        , Lists.li []
            [ Options.span [ Lists.itemprimaryContent ] [ text "Bob Odenkirk" ]
            ]
        ]

  """
