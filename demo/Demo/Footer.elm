module Demo.Footer exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)

import Material.Footer as Footer
import Material
import Material.Options as Options
import Material.Icon as Icon

import Demo.Page as Page

import Html.Attributes as Attrs


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
      (Debug.log "FOOTER" model, Cmd.none)

    Mdl action' ->
      Material.update Mdl action' model



createLinks : Int -> List (Footer.Content m)
createLinks nr =
  let
    nrs = List.repeat nr 0
    makeLink idx _ =
      (Footer.linkItem [Footer.href "#"] [Footer.text ("Link " ++ toString (idx + 1))])
  in
    List.indexedMap makeLink nrs

-- VIEW

view : Model -> Html Msg
view model  =
  [ p [] [text """Footers come in two sizes, mini and mega"""]

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
  , div [Attrs.style [("margin-top", "60px")]] []
  , p [] [text """Example of a mega footer that contains more content than a mini footer"""]
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
                    Footer.link [Footer.href "#"] [text "Link 1"]
                , Footer.wrap <|
                    Footer.link [Footer.href "#"] [text "Link 2"]
                , Footer.wrap <|
                    Footer.link [Footer.href "#"] [text "Link 3"]
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
