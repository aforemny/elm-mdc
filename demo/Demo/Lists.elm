module Demo.Lists exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Set exposing (Set)
import String
import Material.List as Lists
import Material
import Material.Options as Options exposing (when, css)
import Material.Icon as Icon
import Material.Toggles as Toggles
import Material.Color as Color
import Material.Helpers as Helpers
import Material.Button as Button
import Material.Grid as Grid
import Material.Typography as Typography
import Demo.Page as Page
import Demo.Code as Code


-- MODEL


type alias Model =
    { mdl : Material.Model
    , toggles : Set Int
    , str : String
    }


model : Model
model =
    { mdl = Material.model
    , toggles = Set.fromList [ 1, 9, 10 ]
    , str = ""
    }



-- ACTION, UPDATE


type Msg
    = ListsMsg
    | Flip Int
    | Click String
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        ListsMsg ->
            ( model, Cmd.none )

        Flip k ->
            if Set.member k model.toggles then
                ( { model | toggles = Set.remove k model.toggles }, Cmd.none )
            else
                ( { model | toggles = Set.insert k model.toggles }, Cmd.none )

        Click str ->
            ( { model | str = str }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


withCode : x -> y -> ( y, x )
withCode =
    flip (,)


basic : Model -> ( Html Msg, String )
basic model =
    Lists.ul [ css "margin" "0", css "padding" "0" ]
        [ Lists.li [] [ Lists.content [] [ text "Elm" ] ]
        , Lists.li [] [ Lists.content [] [ text "F#" ] ]
        , Lists.li [] [ Lists.content [] [ text "Lisp" ] ]
        ]
        |> withCode """
   Lists.ul []
    [ Lists.li [] [ Lists.content [] [ text "Elm" ] ]
    , Lists.li [] [ Lists.content [] [ text "F#" ] ]
    , Lists.li [] [ Lists.content [] [ text "Lisp" ] ]
    ]
  """


click : Model -> ( Html Msg, String )
click model =
    div
        []
        [ Lists.ul [ css "margin" "0", css "padding" "0" ]
            [ Lists.li []
                [ Lists.content
                    [ Options.onClick (Click "Elm") ]
                    [ text "Elm" ]
                ]
            , Lists.li []
                [ Lists.content
                    [ Options.onClick (Click "F#") ]
                    [ text "F#" ]
                ]
            , Lists.li []
                [ Lists.content
                    [ Options.onClick (Click "Lisp") ]
                    [ text "Lisp" ]
                ]
            ]
        , p []
            [ text <|
                "Try clicking a list item above. "
                    ++ if model.str /= "" then
                        "You chose '" ++ model.str ++ "'."
                       else
                        ""
            ]
        ]
        |> withCode """
 div
    []
    [ Lists.ul []
        [ Lists.li []
            [ Lists.content
                [ Options.attribute <| Html.Events.onClick (Click "Elm") ]
                [ text "Elm" ]
            ]
        , Lists.li []
            [ Lists.content
                [ Options.attribute <| Html.Events.onClick (Click "F#") ]
                [ text "F#" ]
            ]
        , Lists.li []
            [ Lists.content
                [ Options.attribute <| Html.Events.onClick (Click "Lisp") ]
                [ text "Lisp" ]
            ]
        ]
    , p []
        [ text <| "Try clicking a list item above. " ++
            if model.str /= "" then
              "You chose '" ++ model.str ++ "'."
            else
              ""
        ]
    ]
  """


icons : a -> ( Html b, String )
icons model =
    Lists.ul [ css "margin" "0", css "padding" "0" ]
        [ Lists.li []
            [ Lists.content []
                [ Lists.icon "inbox" []
                , text "Inbox"
                ]
            ]
        , Lists.li []
            [ Lists.content []
                [ Lists.icon "send" []
                , text "Sent mail"
                ]
            ]
        , Lists.li []
            [ Lists.content []
                [ Lists.icon "delete" []
                , text "Trash"
                ]
            ]
        ]
        |> withCode """
  Lists.ul []
    [ Lists.li []
        [ Lists.content []
            [ Lists.icon "inbox" []
            , text "Inbox"
            ]
        ]
    , Lists.li []
        [ Lists.content []
            [ Lists.icon "send" []
            , text "Sent mail"
            ]
        ]
    , Lists.li []
        [ Lists.content []
            [ Lists.icon "delete" []
            , text "Trash"
            ]
        ]
    ]
    """


avatars : Model -> ( Html Msg, String )
avatars model =
    Lists.ul [ css "margin" "0", css "padding" "0" ]
        [ Lists.li []
            [ Lists.content []
                [ Lists.avatarImage "assets/images/christoffer.jpg" []
                , text "Christoffer Wilhelm Eckersberg"
                ]
            ]
        , Lists.li []
            [ Lists.content []
                [ Lists.avatarImage "assets/images/edvard.jpg" []
                , text "Edvard Munch"
                ]
            ]
        , Lists.li []
            [ Lists.content []
                [ Lists.avatarImage "assets/images/peder.jpg" []
                , text "Peder Severin Krøyer"
                ]
            ]
        ]
        |> withCode """
  Lists.ul []
    [ Lists.li []
        [ Lists.content []
            [ Lists.avatarImage "assets/christoffer.jpg" []
            , text "Christoffer Wilhelm Eckersberg"
            ]
        ]
     , Lists.li []
        [ Lists.content []
            [ Lists.avatarImage "assets/edvard.jpg" []
            , text "Edvard Munch"
            ]
        ]
     , Lists.li []
        [ Lists.content []
            [ Lists.avatarImage "assets/peder.jpg" []
            , text "Peder Severin Krøyer"
            ]
        ]
    ]
"""


avatarsWithIcons : Model -> ( Html Msg, String )
avatarsWithIcons model =
    Lists.ul [ css "margin" "0", css "padding" "0" ]
        [ Lists.li []
            [ Lists.content []
                [ Lists.avatarIcon "photo_camera" []
                , text "Henri Cartier-Bresson"
                ]
            ]
        , Lists.li []
            [ Lists.content []
                [ Lists.avatarIcon "format_paint" []
                , text "Vincent Willem van Gogh"
                ]
            ]
        , Lists.li []
            [ Lists.content []
                [ Lists.avatarIcon "assistant_photo" []
                , text "Horatio Nelson"
                ]
            ]
        ]
        |> withCode """
   Lists.ul []
    [ Lists.li []
        [ Lists.content []
            [ Lists.avatarIcon "photo_camera" []
            , text "Henri Cartier-Bresson"
            ]
        ]
    , Lists.li []
        [ Lists.content []
            [ Lists.avatarIcon "format_paint" []
            , text "Vincent Willem van Gogh"
            ]
        ]
     , Lists.li []
        [ Lists.content []
            [ Lists.avatarIcon "assistant_photo" []
            , text "Horatio Nelson"
            ]
        ]
    ]
  """


comment : Html a -> String -> Html a
comment list txt =
    Options.div
        [ css "display" "flex"
        , css "height" "100%"
        , css "flex-direction" "column"
        , css "justify-content" "space-between"
        ]
        [ list
        , Options.div
            [ css "width" "100%" ]
            [ Options.styled p [ css "text-align" "right" ] [ text txt ] ]
        ]


secondaryAction1 : Model -> ( Html Msg, String )
secondaryAction1 model =
    let
        star model k =
            Button.render Mdl
                [ k ]
                model.mdl
                [ Button.icon
                , Button.accent |> when (Set.member k model.toggles)
                , Options.onClick (Flip k)
                ]
                [ Icon.i "star" ]
    in
        Lists.ul [ css "margin" "0", css "padding" "0" ]
            [ Lists.li []
                [ Lists.content [] [ text "Alan Turing" ]
                , star model 0
                ]
            , Lists.li []
                [ Lists.content [] [ text "Kurt Friedrich Gödel" ]
                , star model 1
                ]
            , Lists.li []
                [ Lists.content [] [ text "Georg Ferdinand Ludwig Philipp Cantor" ]
                , star model 2
                ]
            ]
            |> withCode """
  let
    star model k =
      Button.render Mdl [k] model.mdl
        [ Button.icon
        , Button.accent |> when (Set.member k model.toggles)
        , Options.onClick (Flip k)
        ]
        [ Icon.i "star" ]
  in
    Lists.ul []
      [ Lists.li []
          [ Lists.content [] [ text "Alan Turing" ]
          , star model 0
          ]
      , Lists.li []
          [ Lists.content [] [ text "Kurt Friedrich Gödel" ]
          , star model 1
          ]
      , Lists.li []
          [ Lists.content [] [ text "Georg Ferdinand Ludwig Philipp Cantor" ]
          , star model 2
          ]
      ]
  """


secondaryAction2 : Model -> ( Html Msg, String )
secondaryAction2 model =
    let
        list =
            Lists.ul [ css "margin" "0", css "padding" "0" ]
                [ Lists.li []
                    [ Lists.content [] [ text "Include checkbox?" ]
                    , Lists.content2 []
                        [ Toggles.checkbox Mdl
                            [ 4 ]
                            model.mdl
                            [ Toggles.value (Set.member 4 model.toggles)
                            , Options.onToggle (Flip 4)
                            ]
                            []
                        ]
                    ]
                , Lists.li []
                    [ Lists.content [] [ text "Radio button!" ]
                    , Lists.content2 []
                        [ Options.span
                            [ Lists.action2 ]
                            [ Toggles.radio Mdl
                                [ 5 ]
                                model.mdl
                                [ Toggles.value (Set.member 5 model.toggles)
                                , Options.onToggle (Flip 5)
                                , Options.css "display" "inline"
                                ]
                                []
                            ]
                        ]
                    ]
                , Lists.li []
                    [ Lists.content [] [ text "Include switch?" ]
                    , Lists.content2 []
                        [ Toggles.switch Mdl
                            [ 6 ]
                            model.mdl
                            [ Toggles.value (Set.member 6 model.toggles)
                            , Options.onToggle (Flip 6)
                            ]
                            []
                        ]
                    ]
                ]
    in
        comment list "Note the incantations necessary to get Radio Button positioning correct."
            |> withCode """
  Lists.ul []
    [ Lists.li []
        [ Lists.content [] [ text "Include checkbox?" ]
        , Lists.content2 []
            [ Toggles.checkbox Mdl [4] model.mdl
                [ Toggles.value (Set.member 4 model.toggles)
                , Options.onToggle (Flip 4)
                ]
                []
            ]
        ]
    , Lists.li []
        [ Lists.content [] [ text "Radio button!" ]
        , Lists.content2 []
            [ Options.span
                [Lists.action2]
                [ Toggles.radio Mdl [5] model.mdl
                    [ Toggles.value (Set.member 5 model.toggles)
                    , Options.onToggle (Flip 5)
                    , Options.css "display" "inline"
                    ]
                    []
                ]
            ]
        ]
    , Lists.li []
        [ Lists.content [] [ text "Include switch?" ]
        , Lists.content2 []
            [ Toggles.switch Mdl [6] model.mdl
                [ Toggles.value (Set.member 6 model.toggles)
                , Options.onToggle (Flip 6)
                ]
                []
            ]
        ]
    ]
  """


info : Model -> ( Html Msg, String )
info model =
    Lists.ul [ css "margin" "0", css "padding" "0" ]
        [ Lists.li []
            [ Lists.content [] [ text "MacBook" ]
            , Lists.content2 []
                [ Lists.info2 [] [ text "New" ]
                , Icon.view "info" [ Color.text Color.primary ]
                ]
            ]
        , Lists.li []
            [ Lists.content [] [ text "iMac \"27" ]
            , Lists.content2 []
                [ Lists.info2 [] [ text "Updated" ]
                , Icon.view "info" [ Color.text Color.primary ]
                ]
            ]
        , Lists.li []
            [ Lists.content [] [ text "Mac Pro" ]
            , Lists.content2 []
                [ Icon.view "info" [ Color.text Color.primary ]
                ]
            ]
        ]
        |> withCode """
  Lists.ul []
    [ Lists.li []
        [ Lists.content [] [ text "MacBook" ]
        , Lists.content2 []
            [ Lists.info2 [] [ text "New" ]
            , Icon.view "info" [ Color.text Color.primary ]
            ]
        ]
    , Lists.li []
        [ Lists.content [] [ text "iMac \\"27" ]
        , Lists.content2 []
            [ Lists.info2 [] [ text "Updated" ]
            , Icon.view "info" [ Color.text Color.primary ]
            ]
        ]
    , Lists.li []
        [ Lists.content [] [ text "Mac Pro" ]
        , Lists.content2 []
            [ Icon.view "info" [ Color.text Color.primary ]
            ]
        ]
"""


subtitle : Model -> ( Html Msg, String )
subtitle model =
    Lists.ul [ css "margin" "0", css "padding" "0" ]
        [ Lists.li [ Lists.withSubtitle ]
            [ Lists.content []
                [ text "Mark Wright"
                , Lists.subtitle [] [ text "4.02m (June 8, 1912)" ]
                ]
            ]
        , Lists.li [ Lists.withSubtitle ]
            [ Lists.content []
                [ text "Kjell Isaksson"
                , Lists.subtitle [] [ text "5.51m (April 8, 1972)" ]
                ]
            ]
        , Lists.li [ Lists.withSubtitle ]
            [ Lists.content []
                [ text "Sergey Bubka"
                , Lists.subtitle [] [ text "6.14m (July 31, 1994)" ]
                ]
            ]
        ]
        |> flip comment """Note that subtitle and body are mutually exclusive.
                         Note also the required Lists.withSubtitle argument to Lists.li."""
        |> withCode """
  Lists.ul []
    [ Lists.li [ Lists.withSubtitle ] -- NB! Required on every Lists.li containing subtitle.
        [ Lists.content []
            [ text "Mark Wright"
            , Lists.subtitle [] [ text "4.02m (June 8, 1912)" ]
            ]
        ]
    , Lists.li [ Lists.withSubtitle ]
        [ Lists.content []
            [ text "Kjell Isaksson"
            , Lists.subtitle [] [ text "5.51m (April 8, 1972)" ]
            ]
        ]
    , Lists.li [ Lists.withSubtitle ]
        [ Lists.content []
          [ text "Sergey Bubka"
          , Lists.subtitle [] [ text "6.14m (July 31, 1994)" ]
          ]
        ]
    ]
"""


body : Model -> ( Html Msg, String )
body model =
    Lists.ul [ css "margin" "0", css "padding" "0" ]
        [ Lists.li [ Lists.withBody ]
            -- NB! Required on every Lists.li containing body.
            [ Lists.content []
                [ text "Robert Frost"
                , Lists.body [] [ text """
I shall be telling this with a sigh /
Somewhere ages and ages hence: /
Two roads diverged in a wood, and I— /
I took the one less traveled by, /
And that has made all the difference.  """ ]
                ]
            ]
        , Lists.li [ Lists.withBody ]
            [ Lists.content []
                [ text "Errett Bishop"
                , Lists.body [] [ text """
And yet there is dissatisfaction in the mathematical community.
The pure mathematician is isolated from the world, which has
little need of his brilliant creations. He suffers from an
alienation which is seemingly inevitable: he has followed the gleam
and it has led him out of this world.
              """ ]
                ]
            ]
        , Lists.li [ Lists.withBody ]
            [ Lists.content []
                [ text "Hunter Stockton Thompson"
                , Lists.body [] [ text """
We were somewhere around Barstow on the edge of the desert when the drugs began
to take hold. I remember saying something like »I feel a bit lightheaded; maybe
you should drive...« """ ]
                ]
            ]
        ]
        |> flip comment """Note that body and subtitle are mutually exclusive.
                         Note also the required Lists.withBody argument to Lists.li."""
        |> withCode """
   Lists.ul []
    [ Lists.li [ Lists.withBody ] -- NB! Required on every Lists.li containing body.
        [ Lists.content []
            [ text "Robert Frost"
            , Lists.body [] [ text "I shall be telling this with a sigh / Somewhere ages and ages hence: / Two roads diverged in a wood, and I— / I took the one less traveled by, / And that has made all the difference." ]
            ]
        ]
    , Lists.li [ Lists.withBody ]
        [ Lists.content []
            [ text "Errett Bishop"
            , Lists.body [] [ text "And yet there is dissatisfaction in the mathematical community.  The pure mathematician is isolated from the world, which has little need of his brilliant creations. He suffers from an alienation which is seemingly inevitable: he has followed the gleam and it has led him out of this world."
              ]
            ]
        ]
    , Lists.li [ Lists.withBody ]
        [ Lists.content []
          [ text "Hunter Stockton Thompson"
          , Lists.body [] [ text "We were somewhere around Barstow on the edge of the desert when the drugs began to take hold. I remember saying something like »I feel a bit lightheaded; maybe you should drive...« " ]
          ]
        ]
    ]
"""


trains : List ( ( Char, Color.Hue ), String, number, String, Maybe String )
trains =
    let
        a =
            ( 'A', Color.LightBlue )

        b =
            ( 'B', Color.Green )

        c =
            ( 'C', Color.Orange )

        e =
            ( 'E', Color.Purple )

        h =
            ( 'H', Color.Red )
    in
        [ ( e, "Holte", 1, "14:48", Nothing )
          --, (a, "Hundige",        4, "14:49", Nothing)
        , ( b, "Farum", 1, "14:52", Just "+5m" )
        , ( c, "Klampenborg", 3, "14:54", Nothing )
        , ( c, "Ballerup", 2, "14:55", Nothing )
        , ( b, "Høje Taastrup", 4, "14:56", Just "cancelled" )
        , ( a, "Hillerød", 1, "14:57", Nothing )
          -- , (e, "Hundige",        4, "14:58", Just "+38m")
          -- , (e, "Holte",          1, "14:58", Nothing)
          -- , (a, "Hundige",        4, "14:59", Nothing)
          -- , (b, "Farum",          1, "15:00", Nothing)
        , ( h, "Frederikssund", 2, "15:01", Nothing )
          --, (c, "Klampenborg",    3, "15:02", Nothing)
          --, (c, "Frederikssund",  2, "15:02", Just "Cancelled")
          --, (h, "Farum",          3, "15:02", Nothing)
        ]


box : ( Char, Color.Hue ) -> Html m
box ( letter, hue ) =
    Options.div
        [ Options.center
        , Color.background (Color.color hue Color.S500)
        , Color.text Color.accentContrast
        , Typography.title
        , css "width" "36px"
        , css "height" "36px"
        , css "margin-right" "2rem"
        ]
        [ text (String.fromChar letter) ]


train : ( ( Char, Color.Hue ), String, a, String, Maybe String ) -> Html b
train ( ( letter, hue ), dest, track, time, msg ) =
    Lists.li [ Lists.withSubtitle ]
        [ Options.div
            [ Options.center
            , Color.background (Color.color hue Color.S500)
            , Color.text Color.accentContrast
            , Typography.title
            , css "width" "36px"
            , css "height" "36px"
            , css "margin-right" "2rem"
            ]
            [ text (String.fromChar letter) ]
        , Lists.content []
            [ Options.span [] [ text dest ]
            , Lists.subtitle [] [ text ("Track " ++ toString track) ]
            ]
        , Helpers.filter Lists.content2
            []
            [ msg |> Maybe.map (\m -> Lists.info2 [] [ text m ])
            , text time |> Just
            ]
        ]


schedule : Html Msg
schedule =
    Lists.ul [ css "margin" "0", css "padding" "0" ] (List.map train trains)


type File
    = Folder
    | File


files : List ( File, String, String, String, Color.Hue, Maybe Bool )
files =
    [ ( Folder, "demo", "2 days ago", "@aforemny", Color.Indigo, Just False )
    , ( Folder, "src", "2 days ago", "@vipentti", Color.Indigo, Nothing )
    , ( Folder, "examples", "2 days ago", "@aforemny", Color.BlueGrey, Nothing )
    , ( File, "CONTRIBUTING.md", "28 days ago", "@debois", Color.DeepOrange, Just True )
    , ( File, "README.md", "5 days ago", "@aforemny", Color.DeepOrange, Just True )
    , ( File, "elm-package.json", "6 days ago", "@debois", Color.Orange, Nothing )
    , ( File, "Makefile", "5 days ago", "@aforemny", Color.Teal, Just False )
    ]


git : ( File, String, String, String, Color.Hue, Maybe Bool ) -> Html a
git ( typ, name, modified, by, hue, x ) =
    Lists.li
        [ Lists.withSubtitle ]
        [ Lists.content []
            [ Lists.avatarIcon
                (if typ == Folder then
                    "folder"
                 else
                    "insert_drive_file"
                )
                [ Color.background (Color.color hue Color.S500) ]
            , text name
            , Lists.subtitle []
                [ Options.span [] [ text <| modified ++ " by " ++ by ] ]
            ]
        , case x of
            Just True ->
                Icon.view "star" [ Color.text Color.primary ]

            Just False ->
                Icon.view "error_outline" [ Color.text Color.accent ]

            _ ->
                div [] []
        ]


commits : Html a
commits =
    Lists.ul [ css "margin" "0", css "padding" "0" ]
        (List.map git files)


mails : List ( String, String, String, String, String )
mails =
    [ ( "Alexander Grothendieck", "alexander.jpg", "Re: How to open a nut", "1985", "I can illustrate the second approach with the same image of a nut to be opened. The first analogy that came to my mind is of immersing the nut in some softening liquid, and why not simply water? From time to time you rub so the liquid penetrates better, and otherwise you let time pass. The shell becomes more flexible through weeks and months—when the time is ripe, hand pressure is enough, the shell opens like a perfectly ripened avocado!" )
    , ( "Jean-Paul Sartre", "jean-paul.jpg", "Other people", "1944", "Alors, c'est ça l'enfer. Je n'aurais jamais cru... Vous vous rappelez: le soufre, le bûcher, le gril... Ah! quelle plaisanterie. Pas besoin de gril : l'enfer, c'est les Autres." )
    , ( "Albert Camus", "albert.jpg", "Maman est morte", "1942", "Aujourd'hui, maman est morte. Ou peut-être hier, je ne sais pas. J'ai reçu un télégramme de l'asile : «Mère décédée. Enterrement demain.  Sentiments distingués.» Cela ne veut rien dire. C'était peut-être hier." )
    , ( "Leopold Kronecker", "leopold.jpg", "Re: Cantor", "1893", "Die ganzen Zahlen hat der liebe Gott gemacht, alles andere ist Menschenwerk." )
    , ( "Oscar Wilde", "oscar.jpg", "Re: Women", "Older", "How can a woman be expected to be happy with a man who insists on treating her as if she were a perfectly normal human being?" )
    ]


mail : Model -> Int -> ( String, String, String, String, String ) -> Html Msg
mail model idx ( name, img, subj, date, txt ) =
    let
        k =
            idx + 7

        starred =
            Set.member k model.toggles
    in
        Lists.li [ Lists.withBody ]
            [ Lists.content []
                [ Lists.avatarImage ("assets/images/" ++ img) []
                , text subj
                , Lists.body []
                    [ Options.span [ css "font-weight" "600" ] [ text name ]
                    , Options.span [] [ text "—" ]
                    , Options.span [] [ text txt ]
                    ]
                ]
            , Lists.content2 []
                [ Lists.info2 [] [ text date ]
                , Button.render Mdl
                    [ k ]
                    model.mdl
                    [ Button.icon
                    , Options.onClick (Flip k)
                    ]
                    [ Icon.i
                        (if starred then
                            "star"
                         else
                            "star_border"
                        )
                    ]
                ]
            ]


inbox : Model -> Html Msg
inbox model =
    Lists.ul [ css "margin" "0", css "padding" "0" ] (List.indexedMap (mail model) mails)


demoList : String -> ( Html Msg, String ) -> List (Grid.Cell Msg)
demoList title ( list, code ) =
    let
        all =
            Options.many [ Grid.size Grid.Phone 4, Grid.size Grid.Tablet 8, Grid.size Grid.Desktop 12 ]

        half =
            Options.many [ Grid.size Grid.Phone 4, Grid.size Grid.Tablet 8, Grid.size Grid.Desktop 6 ]
    in
        [ Grid.cell [ all ]
            [ Options.span [ Typography.headline ] [ text title ] ]
        , Grid.cell [ half ]
            [ list ]
        , Grid.cell [ half ]
            [ Code.code [] code ]
        ]


view : Model -> Html Msg
view model =
    let
        docs =
            [ div
                []
                [ Grid.grid [ Grid.maxWidth "1200px" ]
                    (List.concatMap
                        (\( title, ctor ) -> demoList title (ctor model))
                        [ (,) "Basic list" basic
                        , (,) "List with icons" icons
                        , (,) "List with avatars" avatars
                        , (,) "List with icon-avatars" avatarsWithIcons
                        , (,) "List with secondary action" secondaryAction1
                        , (,) "List with secondary action & info" info
                        , (,) "List with secondary action toggles" secondaryAction2
                        , (,) "List with subtitles" subtitle
                        , (,) "List with body" body
                        , (,) "List with actions" click
                        ]
                    )
                ]
            ]

        demo =
            Grid.grid []
                [ Grid.cell
                    [ Grid.size Grid.Tablet 8, Grid.size Grid.Desktop 5 ]
                    [ Options.styled Html.h4 [ Typography.headline ] [ text "Departures" ]
                      --, Options.div [ Typography.title ] [ text "Nørreport Station, July 25 2017, 14:48" ]
                    , schedule
                    ]
                , Grid.cell
                    [ Grid.size Grid.Tablet 8, Grid.offset Grid.Desktop 1, Grid.size Grid.Desktop 5 ]
                    [ Options.styled Html.h4 [ Typography.headline ] [ text "Files" ]
                    , commits
                    ]
                , Grid.cell
                    [ Grid.size Grid.Tablet 8, Grid.size Grid.Desktop 6, Grid.offset Grid.Desktop 3 ]
                    [ Options.styled Html.h4 [ Typography.headline ] [ text "Unread mail" ]
                    , inbox model
                    ]
                ]
    in
        Page.body1_ "Lists" srcUrl intro references [ demo ] docs


intro : Html m
intro =
    Page.fromMDL "https://www.getmdl.io/components/index.html#lists-section" """
> Lists present multiple line items vertically as a single continuous element.
> Refer to the [Material Design
Spec](https://material.google.com/components/lists.html) to know more about the
content options.  """


srcUrl : String
srcUrl =
    "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Lists.elm"


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-List"
    , Page.mds "https://material.google.com/components/lists.html"
    , Page.mdl "https://www.getmdl.io/components/index.html#lists-section"
    ]
