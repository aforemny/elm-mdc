module Demo.Footer exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)

import Material.Footer as Footer
import Material
import Material.Options as Options
import Material.Icon as Icon

import Demo.Page as Page


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


-- VIEW


view : Model -> Html Msg
view model  =
  [ div
      []
      [
       Footer.mini [ Options.cs "demo-mini-footer" ]
         [ Footer.left []
             [ Footer.logo [ Options.cs "demo-mini-footer-logo" ]
                 [ text "Mini footer example" ]
             , Footer.links [ Options.cs "demo-mini-footer-links" ]
                 [ li []
                     [ Footer.link [Footer.href "#", Footer.onClick FooterMsg]
                         [text "Link 1"] ]
                 , li []
                     [ Footer.link [Footer.href "#", Footer.onClick FooterMsg]
                         [text "Link 2"] ]
                 ]
             ]
         , Footer.right []
             [Footer.logo [] [text "Mini footer example"]]
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
