module Demo.Footer exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)

import Material.Footer as Footer
import Material
import Material.Options as Options
import Material.Icon as Icon

import Demo.Page as Page

import Html.Attributes as Html


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
  = FooterMsg
  | Mdl Material.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    FooterMsg ->
      (model, Cmd.none)

    Mdl action' ->
      Material.update Mdl action' model



createLinks : Int -> List (Footer.Content m)
createLinks nr =
  let
    nrs = List.repeat nr 0
    makeLink idx _ =
      (Footer.linkItem [Footer.href "#footers"] [Footer.text ("Link " ++ toString (idx + 1))])
  in
    List.indexedMap makeLink nrs


customStyles : String
customStyles = """
  .custom-footer {
    justify-content: center;
    flex-direction: column;
  }
  .custom-footer ul {
    padding: 0;
    display: flex;
    align-items: center;
    flex-direction: row;
    list-style-type: none;
    justify-content: center;
  }
  .custom-footer .mdl-mini-footer__social-btn {
    background-color: transparent;
    margin: 0 16px 0 16px;
    width: 24px;
    height: 24px;
  }
  .custom-footer > ul > li > a {
    color: white;
    margin: 0 8px 0 8px;
    font-weight: 400;
    font-size: 12px;
  }
  """

-- VIEW

view : Model -> Html Msg
view model  =
  [ Options.stylesheet customStyles

  , p [] [text """Footers come in two sizes, mini and mega.
                Mega footers usually contain more content than mini footers."""]

  , p [] [text "Example of a mini footer"]
  , div []
    [ Footer.mini []
        [ Footer.left []
            [ Footer.logo []
                [Footer.wrap <| text "Mini Footer Example"]
            , Footer.links []
                <| createLinks 3
            ]
        , Footer.right []
            [ Footer.logo []
                [Footer.text "Right Section"]
            , Footer.socialButton [Options.css "margin-right" "6px"] []
            , Footer.socialButton [Options.css "margin-right" "6px"] []
            , Footer.socialButton [] []
            ]
        ]
    ]
  , div [Html.style [("margin-top", "60px")]] []
  , p [] [text """Example of a mega footer that contains more content than a mini footer.
                Mega footers also have more sections than minifooters"""]
  , div []
    [ Footer.mega []
        [ Footer.top []
            [ Footer.left []
                [ Footer.logo [] [ Footer.text "Mega Footer Top Section" ]
                , Footer.socialButton [Options.css "margin-right" "6px"] []
                , Footer.socialButton [Options.css "margin-right" "6px"] []
                , Footer.socialButton [] []
                ]
            , Footer.right []
                [ Footer.wrap <|
                    Footer.link [Footer.href "#footers"] [text "Link 1"]
                , Footer.wrap <|
                    Footer.link [Footer.href "#footers"] [text "Link 2"]
                , Footer.wrap <|
                    Footer.link [Footer.href "#footers"] [text "Link 3"]
                ]
            ]
        , Footer.middle []
            [ Footer.dropdown []
                [ Footer.heading []
                    [Footer.text "Mega Footer Middle Section"]
                , Footer.links []
                    <| createLinks 6
                ]
            , Footer.dropdown []
                [ Footer.heading []
                    [Footer.text "Can have"]
                , Footer.links []
                    <| createLinks 4
                ]

            , Footer.dropdown []
                [ Footer.heading []
                    [Footer.text "Multiple dropdowns"]
                , Footer.links []
                    <| createLinks 5
                ]
            ]
        , Footer.bottom []
            [ Footer.logo []
                [ Footer.text "Mega Bottom Section Example" ]
            , Footer.links []
                <| createLinks 5
            ]
        ]
    ]

  , div [Html.style [("margin-top", "60px")]] []
  , p [] [text "An example of a custom mini footer with custom content"]
  , div []
    [ Footer.mini [Options.cs "custom-footer"]
        [ Footer.wrap <|
            Html.ul []
              [ Html.li [Html.class "mdl-mini-footer__social-btn"]
                  [Html.a [Html.href "#footers"] [Icon.i "face"]]
              , Html.li [Html.class "mdl-mini-footer__social-btn"]
                  [Html.a [Html.href "#footers"] [Icon.i "settings"]]
              , Html.li [Html.class "mdl-mini-footer__social-btn"]
                  [Html.a [Html.href "#footers"] [Icon.i "donut_large"]]
              ]
        , Footer.wrap <|
            Html.ul []
              [ Html.li []
                  [Html.a [Html.href "#footers"] [text "Link 1"]]
              , Html.li []
                  [Html.a [Html.href "#footers"] [text "Link 2"]]
              ]
        ]
    ]
  ]
  |> Page.body2 "Footers" srcUrl intro references


intro : Html m
intro =
  Page.fromMDL "https://getmdl.io/components/index.html#layout-section/footer" """
> The Material Design Lite (MDL) footer component is a comprehensive container
> intended to present a substantial amount of related content in a visually
> attractive and logically intuitive area. Although it is called "footer", it
> may be placed at any appropriate location on a device screen, either before or
> after other content.
>
> An MDL footer component takes two basic forms: mega-footer and mini-footer. As
> the names imply, mega-footers contain more (and more complex) content than
> mini-footers. A mega-footer presents multiple sections of content separated by
> horizontal rules, while a mini-footer presents a single section of content. Both
> footer forms have their own internal structures, including required and optional
> elements, and typically include both informational and clickable content, such
> as links.
>
> Footers, as represented by this component, are a fairly new feature in user
> interfaces, and allow users to view discrete blocks of content in a coherent and
> consistently organized way. Their design and use is an important factor in the
> overall user experience.
"""


srcUrl : String
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Footer.elm"


references : List (String, String)
references =
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Footer"
  , Page.mds "https://material.google.com/layout/structure.html"
  , Page.mdl "https://getmdl.io/components/index.html#layout-section/footer"
  ]
