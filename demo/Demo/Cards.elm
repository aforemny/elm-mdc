module Demo.Cards exposing (model, update, view, Model, Msg)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Attributes
import Material.Card as Card
import Material.Button as Button
import Material.Icon as Icon
import Material.Elevation as Elevation
import Material.Color as Color
import Material.Options as Options exposing (cs, css)
import Material
import Material.Typography as Typography
import Material.Tabs as Tabs
import Material.Helpers exposing (map1st, map2nd)
import Demo.Page as Page
import Demo.Code as Code


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


margin1 : Options.Property a b
margin1 =
    css "margin" "0"


margin2 : Options.Property a b
margin2 =
    css "margin" "4px 8px 4px 0px"


dynamic : Int -> Msg -> Model -> Options.Style Msg
dynamic k showcode model =
    [ if model.raised == k then
        Elevation.e8
      else
        Elevation.e2
    , Elevation.transition 250
    , Options.onMouseEnter (Raise k)
    , Options.onMouseLeave (Raise -1)
    , Options.onClick showcode
    ]
        |> Options.many


white : Options.Property c m
white =
    Color.text Color.white


wide : Float
wide =
    400


type alias Card =
    Model -> ( Html Msg, String, Maybe (Html Msg) )


table : Card
table model =
    let
        white =
            Color.text Color.white

        card =
            Card.view
                [ dynamic 0 (ShowCode2 code) model
                , css "width" (toString wide ++ "px")
                , Color.background (Color.color Color.DeepPurple Color.S300)
                , margin2
                ]
                [ Card.media
                    [ css "background" "url('assets/images/table.jpg') center / cover"
                    , css "height" (toString (wide / 16 * 9) ++ "px")
                    ]
                    []
                , Card.title []
                    [ Card.head [ white ] [ text "Table mountain" ]
                    , Card.subhead [ white ] [ text "Cape Town, South Africa" ]
                    ]
                , Card.menu []
                    [ Button.render Mdl
                        [ 0, 0 ]
                        model.mdl
                        [ Button.icon, Button.ripple, white ]
                        [ Icon.i "share" ]
                    ]
                ]

        code =
            """
      Card.view
        [ css "width" \"""" ++ toString wide ++ """px")
        , Color.background (Color.color Color.DeepPurple Color.S300)
        ]
        [ Card.media
            [ css "background" "url('assets/table.jpg') center / cover"
            , css "height" \"""" ++ toString (wide / 16 * 9) ++ """px")
            ]
            []
        , Card.title [ ]
            [ Card.head [ white ] [ text "Table mountain" ]
            , Card.subhead [ white ] [ text "Cape Town, South Africa" ]
            ]
        , Card.menu []
            [ Button.render Mdl [0,0] model.mdl
              [ Button.icon, Button.ripple, white ]
              [ Icon.i "share" ]
            ]
        ] """

        comment =
            Nothing
    in
        ( card, code, comment )


grenadine : Card
grenadine model =
    let
        card =
            Card.view
                [ dynamic 1 (ShowCode1 code) model
                , css "width" "256px"
                , margin1
                ]
                [ Card.title
                    [ css "background" "url('assets/images/pomegranate.jpg') center / cover"
                    , css "height" "256px"
                    , css "padding" "0"
                      -- Clear default padding to encompass scrim
                    ]
                    [ Card.head
                        [ white
                        , Options.scrim 0.75
                        , css "padding" "16px"
                          -- Restore default padding inside scrim
                        , css "width" "100%"
                        ]
                        [ text "Grenadine" ]
                    ]
                , Card.text []
                    [ text "Non-alcoholic syrup used for both its tart and sweet flavour as well as its deep red color." ]
                , Card.actions
                    [ Card.border ]
                    [ Button.render Mdl
                        [ 1, 0 ]
                        model.mdl
                        [ Button.ripple, Button.accent ]
                        [ text "Ingredients" ]
                    , Button.render Mdl
                        [ 1, 1 ]
                        model.mdl
                        [ Button.ripple, Button.accent ]
                        [ text "Cocktails" ]
                    ]
                ]

        code =
            """
      Card.view
        [ dynamic 1 (ShowCode1 code) model
        , css "width" "256px"
        ]
        [ Card.title
            [ css "background" "url('assets/pomegranate.jpg') center / cover"
            , css "height" "256px"
            , css "padding" "0" -- Clear default padding to encompass scrim
            ]
            [ Card.head
                [ white
                , Options.scrim 0.75
                , css "padding" "16px" -- Restore default padding inside scrim
                , css "width" "100%"
                ]
                [ text "Grenadine" ]
            ]
        , Card.text []
            [ text "Non-alcoholic syrup used for both its tart and sweet flavour as well as its deep red color." ]
        , Card.actions
            [ Card.border ]
            [ Button.render Mdl [1,0] model.mdl
                [ Button.ripple, Button.accent ]
                [ text "Ingredients" ]
            , Button.render Mdl [1,1] model.mdl
                [ Button.ripple, Button.accent ]
                [ text "Cocktails" ]
            ]
        ]
"""

        comment =
            Nothing
    in
        ( card, code, comment )


reminder : Card
reminder model =
    let
        card =
            Card.view
                [ dynamic 2 (ShowCode2 code) model
                , css "width" "192px"
                , css "height" "192px"
                , Color.background (Color.color Color.LightBlue Color.S400)
                , margin2
                ]
                [ Card.title [] [ Card.head [ white ] [ text "Call Petronella" ] ]
                , Card.text [ Card.expand ] []
                  -- Filler
                , Card.actions
                    [ Card.border
                      -- Modify flexbox to accomodate small text in action block
                    , css "display" "flex"
                    , css "justify-content" "space-between"
                    , css "align-items" "center"
                    , css "padding" "8px 16px 8px 16px"
                    , white
                    ]
                    [ Options.span [ Typography.caption, Typography.contrast 0.87 ] [ text "August 3, 2016" ]
                    , Button.render Mdl
                        [ 1 ]
                        model.mdl
                        [ Button.icon, Button.ripple ]
                        [ Icon.i "phone" ]
                    ]
                ]

        code =
            """
      Card.view
        [ css "width" "192px"
        , css "height" "192px"
        , Color.background (Color.color Color.LightBlue Color.S400)
        ]
        [ Card.title [] [ Card.head [ white ] [ text "Call Petronella" ] ]
        , Card.text [ Card.expand ]  [] -- Filler
        , Card.actions
            [ Card.border
            -- Modify flexbox to accomodate small text in action block
            , css "display" "flex"
            , css "justify-content" "space-between"
            , css "align-items" "center"
            , css "padding" "8px 16px 8px 16px"
            , white
            ]
            [ Options.span [ Typography.caption, Typography.contrast 0.87 ] [ text "August 3, 2016" ]
            , Button.render Mdl [1] model.mdl
                [ Button.icon, Button.ripple ]
                [ Icon.i "phone" ]
            ]
        ]
"""

        comment =
            Nothing
    in
        ( card, code, comment )


elm : Card
elm model =
    let
        card =
            Card.view
                [ css "width" "256px"
                , css "height" "256px"
                , css "background" "url('assets/images/elm.png') center / cover"
                , dynamic 3 (ShowCode1 code) model
                , margin1
                ]
                [ Card.text [ Card.expand ] []
                  -- Filler
                , Card.text
                    [ css "background" "rgba(0, 0, 0, 0.5)" ]
                    -- Non-gradient scrim
                    [ Options.span
                        [ white, Typography.title, Typography.contrast 1.0 ]
                        [ text "Elm programming" ]
                    ]
                ]

        code =
            """
      Card.view
        [ css "width" "256px"
        , css "height" "256px"
        , css "background" "url('assets/elm.png') center / cover"
        ]
        [ Card.text [ Card.expand ] [] -- Filler
        , Card.text
            [ css "background" "rgba(0, 0, 0, 0.5)" ] -- Non-gradient scrim
            [ Options.span
                [ white, Typography.title, Typography.contrast 1.0 ]
                [ text "Elm programming" ]
            ]
        ]
"""

        comment =
            Nothing
    in
        ( card, code, comment )


playing : Card
playing model =
    let
        card =
            Card.view
                [ css "width" (toString wide ++ "px")
                , Color.background (Color.color Color.Amber Color.S600)
                , dynamic 5 (ShowCode2 code) model
                , margin2
                ]
                [ Card.title
                    [ css "align-content" "flex-start"
                    , css "flex-direction" "row"
                    , css "align-items" "flex-start"
                    , css "justify-content" "space-between"
                    ]
                    [ Options.div
                        []
                        [ Card.head [ white ] [ text "Artificial Heart" ]
                        , Card.subhead [ white ] [ text "Jonathan Coulton" ]
                        ]
                    , Options.img
                        [ Options.attribute <| Html.Attributes.src "assets/images/artificial-heart.jpg"
                        , css "height" "96px"
                        , css "width" "96px"
                        ]
                        []
                    ]
                ]

        code =
            """
      Card.view
        [ css "width" \"""" ++ toString wide ++ """px"
        , Color.background (Color.color Color.Amber Color.S600)
        ]
        [ Card.title
            [ css "align-content" "flex-start"
            , css "flex-direction" "row"
            , css "align-items" "flex-start"
            , css "justify-content" "space-between"
            ]
            [ Options.div
                []
                [ Card.head [ white ] [ text "Artificial Heart" ]
                , Card.subhead [ white ] [ text "Jonathan Coulton" ]
                ]
            , Options.img
                [ Options.attribute <| Html.Attributes.src "assets/artificial-heart.jpg"
                , css "height" "96px"
                , css "width" "96px"
                ]
                []
            ]
        ]
"""

        comment =
            Nothing
    in
        ( card, code, comment )


weather : Card
weather model =
    let
        sun =
            Color.color Color.Amber Color.S500

        rain =
            Color.color Color.LightBlue Color.S500

        today =
            [ ( "now", 21, -1, Color.primary, "cloud" )
            , ( "16", 21, -1, Color.primary, "cloud" )
            , ( "17", 20, -1, Color.primary, "cloud" )
            , ( "18", 20, -1, rain, "grain" )
            , ( "19", 19, -1, rain, "grain" )
            , ( "20", 19, -1, Color.primary, "cloud_queue" )
            , ( "21", 28, -1, Color.primary, "cloud_queue" )
            ]

        next3 =
            [ ( "thu", 21, 14, sun, "wb_sunny" )
            , ( "fri", 22, 15, rain, "grain" )
            , ( "sat", 20, 13, sun, "wb_sunny" )
            , ( "sun", 21, 13, rain, "grain" )
            , ( "mon", 20, 13, rain, "grain" )
            , ( "tue", 20, 13, sun, "wb_sunny" )
            , ( "wed", 21, 15, sun, "wb_sunny" )
            ]

        cell =
            css "width" "64px"

        row ( time, high, low, color, icon ) =
            Card.subhead
                [ css "display" "flex"
                , css "justify-content" "space-between"
                , css "align-items" "center"
                , css "padding" ".3rem 2.5rem"
                ]
                [ Options.span [ cell ] [ text time ]
                , Options.span [ cell, css "text-align" "center" ]
                    [ Icon.view icon [ Color.text color, Icon.size18 ] ]
                , Options.span [ cell, css "text-align" "right" ]
                    [ text <| toString high ++ "° "
                    , Options.span
                        [ css "color" "rgba(0,0,0,0.37)" ]
                        [ text <|
                            if low >= 0 then
                                toString low ++ "°"
                            else
                                ""
                        ]
                    ]
                ]

        list items =
            [ Options.div
                [ css "display" "flex"
                , css "flex-direction" "column"
                , css "padding" "1rem 0"
                , css "color" "rgba(0, 0, 0, 0.54)"
                ]
                (List.map row items)
            ]

        card =
            Card.view
                [ dynamic 6 (ShowCode1 code) model
                , css "width" "256px"
                , margin1
                ]
                [ Card.title
                    [ css "flex-direction" "column" ]
                    [ Card.head [] [ text "Copenhagen" ]
                    , Card.subhead [] [ text "Wed, 14:55, mostly cloudy" ]
                    , Options.div
                        [ css "padding" "2rem 2rem 0 2rem" ]
                        [ Options.span
                            [ Typography.display4
                            , Typography.contrast 0.87
                            , Color.text Color.primary
                            ]
                            [ text "21°" ]
                        ]
                    ]
                , Card.actions []
                    [ Tabs.render Mdl
                        [ 5, 2 ]
                        model.mdl
                        [ Tabs.ripple
                        , Tabs.onSelectTab SetTab
                        , Tabs.activeTab model.tab
                        ]
                        [ Tabs.label [] [ text "Today" ]
                        , Tabs.label [] [ text "7-day" ]
                        ]
                        (list
                            (if model.tab == 0 then
                                today
                             else
                                next3
                            )
                        )
                    ]
                ]

        code =
            """
    sun =
      Color.color Color.Amber Color.S500

    rain =
      Color.color Color.LightBlue Color.S500

    today =
      [ ("now", 21, -1, Color.primary, "cloud")
      , ("16",  21, -1, Color.primary, "cloud")
      , ("17",  20, -1, Color.primary, "cloud")
      , ("18",  20, -1, rain, "grain")
      , ("19",  19, -1, rain, "grain")
      , ("20",  19, -1, Color.primary, "cloud_queue")
      , ("21",  28, -1, Color.primary, "cloud_queue")
      ]

    next3 =
      [ ("thu", 21, 14, sun, "wb_sunny")
      , ("fri", 22, 15, rain, "grain")
      , ("sat", 20, 13, sun, "wb_sunny")
      , ("sun", 21, 13, rain, "grain")
      , ("mon", 20, 13, rain, "grain")
      , ("tue", 20, 13, sun, "wb_sunny")
      , ("wed", 21, 15, sun, "wb_sunny")
      ]

    cell =
      css "width" "64px"

    row (time, high, low, color, icon) =
      Card.subhead
        [ css "display" "flex"
        , css "justify-content" "space-between"
        , css "align-items" "center"
        , css "padding" ".3rem 2.5rem"
        ]
        [ Options.span [ cell ] [ text time ]
        , Options.span [ cell, css "text-align" "center" ]
            [ Icon.view icon [ Color.text color, Icon.size18 ] ]
        , Options.span [ cell, css "text-align" "right" ]
            [ text <| toString high ++ "° "
            , Options.span
                [ css "color" "rgba(0,0,0,0.37)" ]
                [ text <| if low >= 0 then toString low ++ "°" else "" ]
            ]
        ]

    list items =
      [ Options.div
          [ css "display" "flex"
          , css "flex-direction" "column"
          , css "padding" "1rem 0"
          , css "color" "rgba(0, 0, 0, 0.54)"
          ]
          (List.map row items)
      ]

    card =
      Card.view
        [ css "width" "256px" ]
        [ Card.title
            [ css "flex-direction" "column" ]
            [ Card.head [ ] [ text "Copenhagen" ]
            , Card.subhead [ ] [ text "Wed, 14:55, mostly cloudy" ]
            , Options.div
                [ css "padding" "2rem 2rem 0 2rem" ]
                [ Options.span
                    [ Typography.display4
                    , Color.text Color.primary
                    ]
                    [ text "21°" ]
                ]
            ]
        , Card.actions [ ]
            [ Tabs.render Mdl [5,2] model.mdl
                [ Tabs.ripple
                , Tabs.onSelectTab SetTab
                , Tabs.activeTab model.tab
                ]
                [ Tabs.label [] [ text "Today" ]
                , Tabs.label [] [ text "7-day" ]
                ]
                (list (if model.tab == 0 then today else next3))
            ]
         ]
"""

        comment =
            Nothing
    in
        ( card, code, comment )


event : Card
event model =
    let
        card =
            Card.view
                [ dynamic 7 (ShowCode2 code) model
                , Color.background (Color.color Color.DeepOrange Color.S400)
                , css "width" "192px"
                , css "height" "192px"
                , margin2
                ]
                [ Card.title [] [ Card.head [ white ] [ text "Roskilde Festival" ] ]
                , Card.text [ white ] [ text "Buy tickets before May" ]
                , Card.actions
                    [ Card.border, css "vertical-align" "center", css "text-align" "right", white ]
                    [ Button.render Mdl
                        [ 8, 1 ]
                        model.mdl
                        [ Button.icon, Button.ripple ]
                        [ Icon.i "favorite_border" ]
                    , Button.render Mdl
                        [ 8, 2 ]
                        model.mdl
                        [ Button.icon, Button.ripple ]
                        [ Icon.i "event_available" ]
                    ]
                ]

        code =
            """
      Card.view
        [ Color.background (Color.color Color.DeepOrange Color.S400)
        , css "width" "192px"
        , css "height" "192px"
        ]
        [ Card.title [ ] [ Card.head [ white ] [ text "Roskilde Festival" ] ]
        , Card.text [ white ] [ text "Buy tickets before May" ]
        , Card.actions
            [ Card.border, css "vertical-align" "center", css "text-align" "right", white ]
            [ Button.render Mdl [8,1] model.mdl
                [ Button.icon, Button.ripple ]
                [ Icon.i "favorite_border" ]
            , Button.render Mdl [8,2] model.mdl
                [ Button.icon, Button.ripple ]
                [ Icon.i "event_available" ]
            ]
        ]"""

        comment =
            Nothing
    in
        ( card, code, comment )


aux : Model -> List (Html Msg)
aux model =
    [ h4 [] [ text "Setup" ]
    , Code.code [] """
      import Material.Card as Card

      white : Options.Property c m
      white =
        Color.text Color.white
    """
    , h4 [] [ text "Card click" ]
    , p [] [ text "To react to a card-wide click event, register an onClick handler as indicated below. Be aware that clicks in the action block is ignored in order to not confuse the a click on a control in that block with a click on the entire card." ]
    , Options.div
        [ css "display" "flex"
        , css "align-items" "flex-start"
        , css "flex-flow" "row wrap"
        ]
        [ Card.view
            [ css "width" "128px"
            , Color.background (Color.color Color.Pink Color.S500)
              -- Click
            , Options.onClick Click
            , css "margin" "0 16px 0 0"
            , css "flex-shrink" "0"
            ]
            [ Card.title [] [ Card.head [ white ] [ text "Click anywhere" ] ]
            , Card.text [ white ] [ text <| toString model.clicks ++ " clicks so far." ]
            , Card.actions [ Card.border, white ] [ text "(not here)" ]
            ]
        , Options.div
            [ css "flex-grow" "1"
            ]
            [ Code.code [] """
            Card.view
              [ css "width" "128px"
              , Color.background (Color.color Color.Pink Color.S500)
              -- Click
              , Options.onClick Click
              ]
              [ Card.title [] [ Card.head [ white ] [ text "Click anywhere" ] ]
              , Card.text [ white ] [ text <| toString model.clicks ++ " clicks so far." ]
              , Card.actions [ Card.border, white ] [ text "(not here)" ]
              ]"""
            ]
        ]
    , h4 [] [ text "Elevation animation" ]
    , p [] [ text "If desired, use Elevation.transition to install elevation transitions, e.g., on hover, as demonstrated in the example below." ]
    , let
        k =
            12
      in
        Options.div
            [ css "display" "flex"
            , css "align-items" "flex-start"
            , css "flex-flow" "row wrap"
            ]
            [ Card.view
                [ css "height" "128px"
                , css "width" "128px"
                , Color.background (Color.color Color.Pink Color.S500)
                  -- Elevation
                , if (model.raised == k) then
                    Elevation.e8
                  else
                    Elevation.e2
                , Elevation.transition 250
                , Options.onMouseEnter (Raise k)
                , Options.onMouseLeave (Raise -1)
                , css "margin" "0 16px 0 0"
                , css "flex-shrink" "0"
                ]
                [ Card.title [] [ Card.head [ white ] [ text "Hover here" ] ] ]
            , Options.div
                [ css "flex-grow" "1"
                ]
                [ Code.code [] """
                Card.view
                    [ css "height" "128px"
                    , css "width" "128px"
                    , Color.background (Color.color Color.Brown Color.S500)
                    -- Elevation
                    , if model.raised == k then Elevation.e8 else Elevation.e2
                    , Elevation.transition 250
                    , Options.onMouseEnter (Raise k)
                    , Options.onMouseLeave (Raise -1)
                    ]
                    [ Card.title [] [ Card.head [ white ] [ text "Hover here" ] ] ]"""
                ]
            ]
    ]


view : Model -> Html Msg
view model =
    let
        cards1 =
            [ p [] [ text "Click a card below to see its implementation further down the page." ]
            , Options.div
                [ css "display" "flex"
                , css "flex-flow" "row wrap"
                , css "justify-content" "space-between"
                , css "align-items" "flex-start"
                , css "width" "100%"
                , css "margin-top" "4rem"
                ]
                (List.map (\( html, _, _ ) -> html)
                    [ weather model
                    , grenadine model
                    , elm model
                    ]
                )
            , Code.view model.code1 [ css "margin-top" "16px" ]
            ]

        cards2 =
            [ Options.div
                [ css "display" "flex"
                , css "flex-flow" "row wrap"
                , css "align-items" "flex-end"
                , css "margin-top" "64px"
                ]
                [ Options.div
                    [ css "display" "flex"
                    , css "flex-flow" "row wrap"
                    , css "justify-content" "space-between"
                    , css "align-items" "center"
                    , css "min-width" "256px"
                    , css "max-width" "400px"
                    , css "flex" "1 1 auto"
                    ]
                    (List.map (\( html, _, _ ) -> html)
                        [ table model
                        , playing model
                        , reminder model
                        , event model
                        ]
                    )
                , Options.div
                    [ css "margin" "32px -12px"
                    , css "width" "100%"
                    ]
                    (Code.view model.code2 []
                        :: aux model
                    )
                ]
            ]
    in
        Page.body1_ "Cards"
            srcUrl
            intro
            references
            cards1
            cards2


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
