module Demo.Tooltip exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Attributes as Html exposing (..)
import Material.Tooltip as Tooltip
import Material
import Demo.Page as Page
import Demo.Code as Code
import Material.Button as Button
import Material.Icon as Icon
import Material.Options as Options exposing (css)
import Material.Color as Color


-- MODEL


type alias Model =
    { mdl : Material.Model
    , tooltip : Tooltip.Model
    }


model : Model
model =
    { mdl = Material.model
    , tooltip = Tooltip.defaultModel
    }



-- ACTION, UPDATE


type Msg
    = NoOp
    | TooltipMsg Tooltip.Msg
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        NoOp ->
            ( model, Cmd.none )

        TooltipMsg msg_ ->
            let
                updated =
                    Tuple.first <| (Tooltip.update msg_ model.tooltip)
            in
                ( { model | tooltip = updated }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


demoTooltip : List (Html a) -> String -> String -> Html a
demoTooltip elements description code =
    Options.div
        [ css "width" "45%" ]
        [ p [] [ text description ]
        , Options.div
            [ css "display" "flex"
            , css "align-items" "center"
            , css "justify-content" "center"
            , css "height" "5rem"
            , Color.background Page.background
            ]
            elements
        , Code.code [ css "margin" "24px 0" ] code
        ]


view : Model -> Html Msg
view model =
    [ Html.p [] [ text "Example use:" ]
    , Options.div
        [ css "display" "flex"
        , css "flex-direction" "column"
        , css "flex-wrap" "wrap"
        , css "align-items" "center"
        , css "justify-content" "center"
        ]
        [ demoTooltip
            [ Icon.view "add" [ Tooltip.attach Mdl [ 0 ] ]
            , Tooltip.render Mdl
                [ 0 ]
                model.mdl
                []
                [ text "This is an add icon" ]
            ]
            "Hover over the icon below to see the default tooltip."
            """
        [ Icon.view "add"
            [ Tooltip.attach Mdl [0] ]
        , Tooltip.render Mdl [0] model.mdl
            []
            [ text "This is an add icon" ]
        ]
        """
        , demoTooltip
            [ span [] [ text "HTML is related to " ]
            , Options.styled span
                [ Tooltip.attach Mdl [ 1 ] ]
                [ i [] [ text "XML" ] ]
            , Tooltip.render Mdl
                [ 1 ]
                model.mdl
                [ Tooltip.left ]
                [ text "XML is an acronym for eXtensible Markup Language" ]
            ]
            "Hover over \"XML\" below to see a left-positioned tooltip"
            """
        [ span [] [ text "HTML is related to " ]
        , Options.styled span
            [ Tooltip.attach Mdl [1] ]
            [ i [] [text "XML"] ]
        , Tooltip.render Mdl [1] model.mdl
            [ Tooltip.left ]
            [ text "XML: eXtensible Markup Language" ]
        ]
        """
        , demoTooltip
            [ Icon.view "share"
                [ Tooltip.attach Mdl [ 2 ] ]
            , Tooltip.render Mdl
                [ 2 ]
                model.mdl
                [ Tooltip.large
                , Tooltip.right
                ]
                [ text "This is a share icon" ]
            ]
            "Hover over the share icon below to see a large, right-positioned tooltip."
            """
        [ Icon.view "share"
            [ Tooltip.attach Mdl [2] ]
        , Tooltip.render Mdl [2] model.mdl
            [ Tooltip.large
            , Tooltip.right
            ]
            [text "This is a share icon"]
        ]
        """
        , demoTooltip
            [ Button.render Mdl
                [ 0 ]
                model.mdl
                [ Button.raised
                , Tooltip.attach Mdl [ 3 ]
                ]
                [ text "Click me!" ]
            , Tooltip.render Mdl
                [ 3 ]
                model.mdl
                [ Tooltip.top
                , Tooltip.large
                ]
                [ text "Tooltips also work with material components" ]
            ]
            "Hover over the button to see a large, above-positioned tooltip."
            """
      [ Button.render Mdl [0] model.mdl
          [ Button.raised
          , Tooltip.attach Mdl [3]
          ]
          [ text "Click me!"]
      , Tooltip.render Mdl [3] model.mdl
          [ Tooltip.top
          , Tooltip.large
          ]
          [ text "Tooltips also work with material components" ]
      ]
      """
        , demoTooltip
            [ span
                [ Tooltip.onEnter TooltipMsg
                , Tooltip.onLeave TooltipMsg
                ]
                [ text "Shorthand-independent tooltip"
                ]
            , Tooltip.view TooltipMsg
                model.tooltip
                [ Tooltip.large ]
                [ text "No shorthand!" ]
            ]
            "Hover to see a tooltip using built using only classic TEA."
            """
        [ span
            [ Tooltip.onEnter TooltipMsg
            , Tooltip.onLeave TooltipMsg
            ]
            [ text "Shorthand-independent tooltip" ]
            ]
        , Tooltip.view TooltipMsg model.tooltip
            [ Tooltip.large ]
            [ text "No shorthand!" ]
        ]

        -- TooltipMsg must be dispatched in update.
        """
        , demoTooltip
            [ Icon.view "face"
                [ Tooltip.attach Mdl [ 4 ] ]
            , Tooltip.render Mdl
                [ 4 ]
                model.mdl
                [ Tooltip.large
                , Tooltip.top
                , Tooltip.element Html.span
                ]
                [ img [ src "assets/images/elm.png", width 24, height 24 ] []
                , text " Elm"
                ]
            ]
            "Hover to see a with both image and text."
            """
        [ Icon.view "face"
            [ Tooltip.attach Mdl [4] ]
        , Tooltip.render Mdl [4] model.mdl
            [ Tooltip.large
            , Tooltip.top
            , Tooltip.container Html.span
            ]
              [ img [src "assets/elm.png", width 24, height 24] []
              , text " Elm"
              ]
        ]
        """
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


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Tooltip"
    , Page.mds "https://material.google.com/components/tooltips.html"
    , Page.mdl "https://www.getmdl.io/components/index.html#tooltips-section"
    ]
