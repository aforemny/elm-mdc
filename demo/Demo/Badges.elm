module Demo.Badges exposing (..)

import Html exposing (..)
import Platform.Cmd exposing (Cmd)
import Material.Badge as Badge
import Material.Options as Options exposing (styled)
import Material.Icon as Icon
import Material.Grid exposing (..)
import Material.Helpers as Helpers
import Material.Button as Button
import Material.Options exposing (css)
import Material
import Demo.Code as Code
import Demo.Page as Page


type Msg
    = Increase
    | Decrease
    | SetCode String
    | CodeBox Code.Msg
    | Mdl (Material.Msg Msg)


type alias Model =
    { unread : Int
    , mdl : Material.Model
    , code : Maybe String
    , codebox : Code.Model
    }


model : Model
model =
    { unread = 1
    , mdl = Material.model
    , code = Nothing
    , codebox = Code.model
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        Decrease ->
            ( { model | unread = model.unread - 1 }
            , List.range 0 7
                |> List.map toFloat
                |> List.map (\i -> Helpers.delay (2 ^ i * 20 + 750) Increase)
                |> Cmd.batch
            )

        Increase ->
            ( { model | unread = model.unread + 1 }
            , Cmd.none
            )

        SetCode code ->
            Code.update (Code.Set code) model.codebox
                |> Helpers.map1st (\codebox -> { model | codebox = codebox })
                |> Helpers.map2nd (Cmd.map CodeBox)

        CodeBox msg_ ->
            Code.update msg_ model.codebox
                |> Helpers.map1st (\codebox -> { model | codebox = codebox })
                |> Helpers.map2nd (Cmd.map CodeBox)



-- VIEW


onHover : a -> Options.Style a
onHover =
    Options.onMouseOver


c : List (Html Msg) -> Cell Msg
c =
    cell [ size All 4 ]


view : Model -> Html Msg
view model =
    let
        demo2 =
            [ p []
                [ text "Typical use of a badge in, say, in an e-mail client:" ]
            , grid []
                [ c
                    [ Options.div
                        [ css "width" "10em", css "display" "inline-block" ]
                        [ Options.styled span
                            [ if model.unread /= 0 then
                                Badge.add (toString model.unread)
                              else
                                Options.nop
                            ]
                            [ text "Unread" ]
                        ]
                    , Button.render Mdl
                        [ 0 ]
                        model.mdl
                        [ Options.onClick Decrease
                        , Button.raised
                        , Button.ripple
                        , Button.colored
                        ]
                        [ text "Mark as read" ]
                    ]
                ]
            ]

        demo1 =
            [ p []
                [ text "Below are all possible combinations of badges. Hover to show source excerpt." ]
            , grid
                []
                [ c
                    [ let
                        c1 =
                            """
                  Options.span
                    [ Badge.add "3" ]
                    [ text "Badge" ]"""
                      in
                        Options.span
                            [ Badge.add "3"
                            , onHover <| SetCode c1
                            ]
                            [ text "Badge" ]
                    ]
                , c
                    [ let
                        c2 =
                            """
                  Options.span
                    [ Badge.add "♥" ]
                    [ text "Symbol" ]"""
                      in
                        Options.span
                            [ Badge.add "♥"
                            , onHover <| SetCode c2
                            ]
                            [ text "Symbol" ]
                    ]
                , c
                    [ let
                        c3 =
                            """
                  Icon.view "shopping_cart"
                    [ Icon.size24
                    , Badge.add "33"
                    ]"""
                      in
                        Options.styled span
                            [ onHover <| SetCode c3 ]
                            [ Icon.view "shopping_cart"
                                [ Icon.size24
                                , Badge.add "33"
                                ]
                            ]
                    ]
                , c
                    [ let
                        c4 =
                            """
                  Options.span
                    [ Badge.add "5"
                    , Badge.noBackground
                    ]
                    [ text "No background" ]"""
                      in
                        Options.span
                            [ Badge.add "5"
                            , Badge.noBackground
                            , onHover <| SetCode c4
                            ]
                            [ text "No background" ]
                    ]
                , c
                    [ let
                        c5 =
                            """
                  Options.span
                    [ Badge.add "8"
                    , Badge.overlap
                    ]
                    [ text "Overlap" ]"""
                      in
                        Options.span
                            [ Badge.add "8"
                            , Badge.overlap
                            , onHover <| SetCode c5
                            ]
                            [ text "Overlap" ]
                    ]
                , c
                    [ let
                        c6 =
                            """
                  Options.span
                    [ Badge.add "13"
                    , Badge.overlap
                    , Badge.noBackground
                    ]
                    [ text "Overlap, no background" ]"""
                      in
                        Options.span
                            [ Badge.add "13"
                            , Badge.overlap
                            , Badge.noBackground
                            , onHover <| SetCode c6
                            ]
                            [ text "Overlap, no background" ]
                    ]
                ]
            , Code.view model.codebox [ Options.css "margin" "20px 0" ]
            ]
    in
        Page.body1_ "Badges" srcUrl intro references demo1 demo2


intro : Html a
intro =
    Page.fromMDL "http://www.getmdl.io/components/#badges-section" """
> The Material Design Lite (MDL) badge component is an onscreen notification
> element. A badge consists of a small circle, typically containing a number or
> other characters, that appears in proximity to another object. A badge can be
> both a notifier that there are additional items associated with an object and
> an indicator of how many items there are.
>
> You can use a badge to unobtrusively draw the user's attention to items they
> might not otherwise notice, or to emphasize that items may need their
> attention. For example:
>
>  - A "New messages" notification might be followed by a badge containing the
> number of unread messages.
>  - A "You have unpurchased items in your shopping cart" reminder might include
>  a badge showing the number of items in the cart.
>  - A "Join the discussion!" button might have an accompanying badge indicating the
> number of users currently participating in the discussion.
>
> A badge is almost
> always positioned near a link so that the user has a convenient way to access
> the additional information indicated by the badge. However, depending on the
> intent, the badge itself may or may not be part of the link.
>
> Badges are a new feature in user interfaces, and provide users with a visual clue to help them discover additional relevant content. Their design and use is therefore an important factor in the overall user experience.
>
"""


srcUrl : String
srcUrl =
    "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Badges.elm"


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Badge"
      --, Page.mds "https://www.google.com/design/spec/components/buttons.html"
    , Page.mdl "https://www.getmdl.io/components/#badges-section"
    ]
