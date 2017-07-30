module Demo.Cards exposing (model, update, view, Model, Msg)

import Demo.Code as Code
import Demo.Page as Page
import Html.Attributes
import Html.Attributes as Html exposing (..)
import Html exposing (..)
import Material
import Material.Button as Button
import Material.Card as Card
import Material.Helpers exposing (map1st, map2nd)
import Material.Options as Options exposing (cs, css)
import Platform.Cmd exposing (Cmd, none)


-- MODEL


type alias Model =
    { mdl : Material.Model
    , raised : Int
    , tab : Int
    , code1 : Code.Model
    , code2 : Code.Model
    , clicks : Int
    }


model : Model
model =
    { mdl = Material.model
    , raised = -1
    , tab = 0
    , code1 = Code.model
    , code2 = Code.model
    , clicks = 0
    }



-- ACTION/UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | Raise Int
    | ShowCode1 String
    | ShowCode2 String
    | CodeMsg1 Code.Msg
    | CodeMsg2 Code.Msg
    | SetTab Int
    | Click


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        Raise k ->
            { model | raised = k } ! []

        SetTab k ->
            { model | tab = k } ! []

        ShowCode1 str ->
            Code.update (Code.Set str) model.code1
                |> map1st (\code -> { model | code1 = code })
                |> map2nd (Cmd.map CodeMsg1)

        ShowCode2 str ->
            Code.update (Code.Set str) model.code2
                |> map1st (\code -> { model | code2 = code })
                |> map2nd (Cmd.map CodeMsg2)

        CodeMsg1 msg_ ->
            Code.update msg_ model.code1
                |> map1st (\code -> { model | code1 = code })
                |> map2nd (Cmd.map CodeMsg1)

        CodeMsg2 msg_ ->
            Code.update msg_ model.code2
                |> map1st (\code -> { model | code2 = code })
                |> map2nd (Cmd.map CodeMsg2)

        Click ->
            { model | clicks = model.clicks + 1 } ! []



-- VIEW


type alias Card =
    Model -> ( Html Msg, String, Maybe (Html Msg) )


demoCard : List (Options.Style m) -> List (Html m) -> Html m
demoCard options =
    Card.view
    (  css "margin" "24px"
    :: css "min-width" "320px"
    :: css "max-width" "21.875rem"
    :: options
    )


demoSupportingText : Html msg
demoSupportingText =
    Card.supportingText []
    [ text "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor."
    ]


card0 : Model -> Html Msg
card0 model =
    demoCard
    [
    ]
    [ Card.media
      [ css "background-image" "url(images/16-9.jpg)"
      , css "background-size" "cover"
      , css "height" "12.313rem"
      ]
      [
      ]
    , demoSupportingText
    ]


demoMedia : List (Options.Style m) -> List (Html m) -> Html m
demoMedia options =
    Card.media
    ( css "background-size" "cover"
    :: css "height" "12.313rem"
    :: options
    )


demoActions : List (Options.Style Msg) -> Html Msg
demoActions options =
    Card.actions
    options
    [ Button.render Mdl [1,1,0] model.mdl
      [ Button.compact
      ]
      [ text "Action 1"
      ]
    , Button.render Mdl [1,1,1] model.mdl
      [ Button.compact
      ]
      [ text "Action 2"
      ]
    ]


demoTitle0 : Html m
demoTitle0 =
    Card.title [ Card.large ] [ text "Title" ]


demoSubtitle0 : Html m
demoSubtitle0 =
    Card.subtitle [] [ text "Subehead" ]


demoTitle1 : Html m
demoTitle1 =
    Card.title [ Card.large ] [ text "Title goes here" ]


demoSubtitle1 : Html m
demoSubtitle1 =
    Card.subtitle [] [ text "Subtitle here" ]


demoTitle2 : Html m
demoTitle2 =
    Card.title [ Card.large ] [ text "Title" ]


demoPrimary : List (Options.Style m) -> Html m
demoPrimary options =
    Card.primary
    (  css "position" "relative"
    :: options
    )
    [ Options.div
          [ css "position" "absolute"
          , css "background" "#bdbdbd"
          , css "height" "2.5rem"
          , css "width" "2.5rem"
          , css "border-radius" "50%"
          ]
          []
    , Card.title [ css "margin-left" "56px" ] [ text "Title" ]
    , Card.subtitle [ css "margin-left" "56px" ] [ text "Subhead" ]
    ]


card1 : Model -> Html Msg
card1 model =
    demoCard []
    [ demoPrimary []
    , demoMedia
      [ css "background-image" "url(images/16-9.jpg)"
      ]
      []
    , demoSupportingText
    , demoActions []
    ]


card2 : Model -> Html Msg
card2 model =
    demoCard []
    [ demoPrimary []
    , demoMedia
      [ css "background-image" "url(images/16-9.jpg)"
      ]
      []
    , demoActions [ Card.vertical ]
    ]


demoPrimary2 : List (Options.Style m) -> Html m
demoPrimary2 options =
    Card.primary
    (  css "position" "relative"
    :: options
    )
    [ demoTitle1
    , demoSubtitle1
    ]


card3 : Model -> Html Msg
card3 model =
    demoCard []
    [ demoMedia
      [ css "background-image" "url(images/16-9.jpg)"
      ]
      []
    , demoPrimary2 []
    , demoActions []
    ]


card4 : Model -> Html Msg
card4 model =
    demoCard []
    [ Card.primary
      [ css "position" "relative"
      ]
      [ demoTitle1
      , demoSubtitle1
      ]
    , Card.supportingText []
      [ text "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
      ]
    , demoActions []
    ]


card5 : Model -> Html Msg
card5 model =
    demoCard
    [ Card.darkTheme
    , css "background-image" "url(images/1-1.jpg"
    , css "background-size" "cover"
    , css "height" "21.875rem"
    ]
    [ demoPrimary2
      [ css "background" "rgba(0,0,0,0.4)"
      ]
    , Card.actions
      [ css "background" "rgba(0,0,0,0.4)"
      ]
      [ Button.render Mdl [1,1,0] model.mdl
        [ Button.compact
        , Button.darkTheme
        ]
        [ text "Action 1"
        ]
      , Button.render Mdl [1,1,1] model.mdl
        [ Button.compact
        , Button.darkTheme
        ]
        [ text "Action 2"
        ]
      ]
    ]


card6 : Model -> Html Msg
card6 model =
    demoCard []
    [ demoMedia
      [ css "background-image" "url(images/1-1.jpg)"
      ]
      [ Card.title [ Card.large ] [ text "Title" ]
      ]
    , Card.actions []
      [ Button.render Mdl [1,6,0] model.mdl
        [ Button.compact
        ]
        [ text "Action 1"
        ]
      ]
    ]


mediaItem : List (Options.Style Msg) -> Html Msg
mediaItem options =
    Card.mediaItem options
    [ Html.img
      [ Html.src "images/1-1.jpg"
      , Html.style
        [ ("width", "auto")
        , ("height", "100%")
        ]
      ]
      []
    ]


demoPrimary3 : List (Options.Style Msg) -> Html Msg
demoPrimary3 options =
    Card.primary
    (  css "position" "relative"
    :: options
    )
    [ demoTitle3
    , demoSubtitle3
    ]


demoTitle3 : Html msg
demoTitle3 =
    Card.title [ Card.large ] [ text "Title here" ]


demoSubtitle3 : Html msg
demoSubtitle3 =
    Card.subtitle [] [ text "Subtitle here" ]


card7 : Model -> Html Msg
card7 model =
    demoCard []
    [ Card.horizontalBlock []
      [ demoPrimary3 []
      , mediaItem []
      ]
    , demoActions []
    ]


card8 : Model -> Html Msg
card8 model =
    demoCard []
    [ Card.horizontalBlock []
      [ demoPrimary3 []
      , mediaItem [ Card.x1dot5 ]
      ]
    , demoActions []
    ]


card9 : Model -> Html Msg
card9 model =
    demoCard []
    [ Card.horizontalBlock []
      [ demoPrimary3 []
      , mediaItem [ Card.x2 ]
      ]
    , demoActions []
    ]


card10 : Model -> Html Msg
card10 model =
    demoCard
    [
    ]
    [ Card.horizontalBlock []
      [ mediaItem [ Card.x3 ]
      , Card.actions
        [ Card.vertical
        ]
        [ Button.render Mdl [1,10,0] model.mdl
          [ Button.compact
          ]
          [ text "A 1"
          ]
        , Button.render Mdl [1,10,1] model.mdl
          [ Button.compact
          ]
          [ text "A 2"
          ]
        ]
      ]
    ]


view : Model -> Html Msg
view model =
    let
        demoWrapper =
            Options.div
            [ css "display" "flex"
            , css "margin" "24px"
            , css "flex-flow" "row wrap"
            , css "align-content" "left"
            , css "justify-content" "left"
            , cs "mdc-typography"
            ]
                << List.map (\card -> Html.div [] [ card ])
    in
    Page.body1_ "Cards"
        srcUrl
        intro
        references
        []
        [ demoWrapper
          [ card0 model
          , card1 model
          , card2 model
          , card3 model
          , card4 model
          , card5 model
          , card6 model
          , card7 model
          , card8 model
          , card9 model
          , card10 model
          ]
        ]


intro : Html m
intro =
    Page.fromMDL "https://getmdl.io/components/#cards-section" """
> The Material Design Lite (MDL) card component is a user interface element
> representing a virtual piece of paper that contains related data — such as a
> photo, some text, and a link — that are all about a single subject.
>
> Cards are a convenient means of coherently displaying related content that is
> composed of different types of objects. They are also well-suited for presenting
> similar objects whose size or supported actions can vary considerably, like
> photos with captions of variable length. Cards have a constant width and a
> variable height, depending on their content.
>
> Cards are a fairly new feature in user interfaces, and allow users an access
> point to more complex and detailed information. Their design and use is an
> important factor in the overall user experience. See the card component's
> Material Design specifications page for details.
"""


srcUrl : String
srcUrl =
    "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Cards.elm"


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Card"
    , Page.mds "https://material.google.com/components/cards.html"
    , Page.mdl "https://getmdl.io/components/#cards-section"
    ]
