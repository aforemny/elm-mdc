module Demo.Footer exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)

import Material.Footer as Footer
import Material
import Material.Options as Options

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
      (Footer.linkItem [Footer.href "#footers"] [Footer.html <| text ("Link " ++ toString (idx + 1))])
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
                Mega footers usually contain more content than mini footers.
                Note that "dropdowns" become dropdowns only when the screen is
                small enough (resize your viewport to observe)."""]

  , div [Html.style [("margin-top", "60px")]] []
  , h4 [] [text "Mini footer"]
  , div []
    [ Footer.mini []
        { left =
            Footer.left []
              [ Footer.logo [] [ Footer.html <| text "Mini Footer Example" ]
              , Footer.links [] <| createLinks 3
              ]

        , right =
            Footer.right []
              [ Footer.logo [] [ Footer.html <| text "Mini Footer Right Section" ]
              , Footer.socialButton [Options.css "margin-right" "6px"] []
              , Footer.socialButton [Options.css "margin-right" "6px"] []
              , Footer.socialButton [Options.css "margin-right" "0px"] []
              ]
        }
    ]
  , div [Html.style [("margin-top", "60px")]] []
  , h4 [] [ text "Mega footer" ]
  , p [] [text """The mega footer typically has more contents and more
                  sections than a mini footer."""]
  , div []
    [ Footer.mega []
        { top =
            Footer.top []
            { left = Footer.left []
                [ Footer.logo [] [ Footer.html <| text "Mega Footer Top Section" ]
                , Footer.socialButton [Options.css "margin-right" "6px"] []
                , Footer.socialButton [Options.css "margin-right" "6px"] []
                , Footer.socialButton [] []
                ]
            , right = Footer.right []
                [ Footer.link [Footer.href "#footers"] [text "Link 1"]
                , Footer.link [Footer.href "#footers"] [text "Link 2"]
                , Footer.link [Footer.href "#footers"] [text "Link 3"]
                ]
            }
        , middle = Footer.middle []
            [ Footer.dropdown []
                [ Footer.heading [] [Footer.html <| text "Mega Footer Middle Section"]
                , Footer.links [] <| createLinks 6
                ]

            , Footer.dropdown []
                [ Footer.heading [] [Footer.html <| text "Can have"]
                , Footer.links [] <| createLinks 4
                ]

            , Footer.dropdown []
                [ Footer.heading [] [Footer.html <| text "Many dropdowns"]
                , Footer.links [] <| createLinks 5
                ]

            , Footer.dropdown []
                [ Footer.heading [] [Footer.html <| text "And more dropdowns"]
                , Footer.links [] <| createLinks 2
                ]
            ]

        , bottom = Footer.bottom []
            [ Footer.logo [] [ Footer.html <| text "Mega Bottom Section Example" ]
            , Footer.links [] <| createLinks 5
            ]
        }
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
