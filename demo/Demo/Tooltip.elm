module Demo.Tooltip exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Attributes as Html exposing (..)

import Material.Tooltip as Tooltip
import Material

import Demo.Page as Page

import Material.Grid as Grid
import Demo.Code as Code
import Markdown

import Material.Button as Button
import Material.Icon as Icon

-- MODEL

type alias Model =
  { mdl : Material.Model
  , nopart : Tooltip.Model
  }


model : Model
model =
  { mdl = Material.model
  , nopart = Tooltip.defaultModel
  }


-- ACTION, UPDATE
type Msg
  = NoOp
  | TooltipMsg Tooltip.Msg
  | Mdl Material.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    NoOp ->
        (model, Cmd.none)

    TooltipMsg msg' ->
      let
        updated = fst <| (Tooltip.update msg' model.nopart)
      in
        ({ model | nopart = updated }, Cmd.none)

    Mdl action' ->
      Material.update Mdl action' model


code : String -> Html a
code str =
  div
    [ style [("overflow", "hidden")] ]
    [ Markdown.toHtml [] <| "```elm\n" ++ Code.trim str ++ "\n```" ]

-- VIEW


demoTooltip : (Html a, String) -> Grid.Cell a
demoTooltip (tooltip, description) =
  Grid.cell
    [Grid.size Grid.All 4]
    [ div [style [("text-align", "center")]]
        [tooltip]
    , p [style [("font-size", "11pt"), ("margin-top", "1em")]]
        [text description]
    ]

view : Model -> Html Msg
view model  =
  [ Html.p [] [text "Example use:"]
  , Grid.grid []
    [Grid.cell [Grid.size Grid.All 12]
       [code """
              import Material.Tooltip as Tooltip
              import Material.Icon as Icon

              -- Note the index in both the Render as well as the mouse event handlers

              tooltip : Model -> Html Msg
              tooltip model =
                div []
                  [ Icon.view "add" [ Tooltip.attach Mdl [0] ]

                  , Tooltip.render Mdl [0] model.mdl
                      [Tooltip.default]
                      [text "Default tooltip"]
                  ]
              """]
    ]

  , Grid.grid []
    [ demoTooltip
        (div []
           [ Icon.view "add"
               [ Tooltip.attach Mdl [0] ]

           , Tooltip.render Mdl [0] model.mdl
             []
             [text "Default tooltip"]
           ]


        , """
           Default tooltip positioned below
           """
        )

    , demoTooltip
        (div []
           [ p [style [("margin-bottom", "5px")]]
               [ text "HTML is related to but different from "

               , span [ Tooltip.onMouseEnter Mdl [1]
                      , Tooltip.onMouseLeave Mdl [1]
                      ]
                   [i [] [text "XML"]]
               ]

           , Tooltip.render Mdl [1] model.mdl
             [Tooltip.left]
             [text "XML is an acronym for eXtensible Markup Language"]
           ]


        , """
           Hover over `XML` to see a tooltip
           on the left
           """
        )

    , demoTooltip
        (div []
           [ Icon.view "share"
               [ Tooltip.attach Mdl [2] ]

           , Tooltip.render Mdl [2] model.mdl
             [ Tooltip.large
             , Tooltip.right]
               [text "Large tooltip"]
           ]


        , """
           A large tooltip positioned on
           the right
           """
        )

    , demoTooltip
        (div []
           [ Button.render Mdl [0] model.mdl
               [ Button.raised
               , Tooltip.attach Mdl [3]
               ]
               [ text "BUTTON"]

           , Tooltip.render Mdl [3] model.mdl
             [ Tooltip.top
             , Tooltip.large]
               [text "Tooltips also work with material components"]
           ]


        , """
           A large tooltip positioned
           above the button
           """
        )

    , demoTooltip
        (div []
           [ p [style [("margin-bottom", "5px")]]
               [ text "HTML is related to but different from "
               , span [ Tooltip.onEnter TooltipMsg
                      , Tooltip.onLeave TooltipMsg
                      ]
                   [i [] [text "XML"]]
               , p [] [text "This element should not interfere"]
               ]

           , Tooltip.view TooltipMsg model.nopart
             [Tooltip.large]
             [text "No parts!"]
           ]


        , """
           Tooltips also work without
             using Parts model
             """
        )

    , demoTooltip
        (div []
           [ Icon.view "face"
               [ Tooltip.attach Mdl [4] ]

           , Tooltip.render Mdl [4] model.mdl
             [ Tooltip.large
             , Tooltip.top
             , Tooltip.container Html.span]
               [ img [src "assets/elm.png", width 24, height 24] []
               , text "A target with a tooltip containing both an image and text."
               ]
           ]


        , """
           Tooltips can also be contained in other elements, such as a span or p.
           They can also contain both images and text.
           """
        )
    ]
  ]
  |> Page.body2 "Tooltips" srcUrl intro references


intro : Html m
intro =
  Page.fromMDL "https://getmdl.io/components/index.html#tooltips-section" """
> The Material Design Lite (MDL) tooltip component is an enhanced version of the
> standard HTML tooltip as produced by the `title` attribute. A tooltip consists
> of text and/or an image that clearly communicates additional information about
> an element when the user hovers over or, in a touch-based UI, touches the
> element. The MDL tooltip component is pre-styled (colors, fonts, and other
> settings are contained in material.min.css) to provide a vivid, attractive
> visual element that displays related but typically non-essential content,
> e.g., a definition, clarification, or brief instruction.
>
> Tooltips are a ubiquitous feature of most user interfaces, regardless of a
> site's content or function. Their design and use is an important factor in the
> overall user experience. See the tooltip component's Material Design
> specifications page for details.
"""


srcUrl : String
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Tooltip.elm"


references : List (String, String)
references =
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Tooltip"
  , Page.mds "https://material.google.com/components/tooltips.html"
  , Page.mdl "https://www.getmdl.io/components/index.html#tooltips-section"
  ]
