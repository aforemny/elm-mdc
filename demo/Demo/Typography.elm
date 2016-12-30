module Demo.Typography exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)


--import Html.Attributes as Html

import Material.Typography as Typo
import Material.Options as Options exposing (css)
import Material
import Material.Grid as Grid
import Demo.Page as Page
import Demo.Code as Code


-- MODEL


type alias Model =
    { mdl : Material.Model
    }


model : Model
model =
    { mdl = Material.model
    }



-- ACTION, UPDATE


type Msg
    = TypographyMsg
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        TypographyMsg ->
            ( model, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


demo1 : List ( Html a, String )
demo1 =
    [ ( Options.styled p [ Typo.display4 ] [ text "Light 112px" ]
      , """
       Options.styled p
         [ Typo.display4 ]
         [ text "Light 112px" ]
       """
      )
    , ( Options.styled p [ Typo.display3 ] [ text "Regular 56px" ]
      , """
      Options.styled p
        [ Typo.display3 ]
        [ text "Regular 56px" ]
      """
      )
    , ( Options.styled p [ Typo.display2 ] [ text "Regular 45px" ]
      , """
      Options.styled p
        [ Typo.display2 ]
        [ text "Regular 45px" ]
      """
      )
    , ( Options.styled p [ Typo.display1 ] [ text "Regular 34px" ]
      , """
      Options.styled p
        [ Typo.display1 ]
        [ text "Regular 34px" ]
      """
      )
    , ( Options.styled p [ Typo.headline ] [ text "Regular 24px" ]
      , """
       Options.styled p
         [ Typo.headline ]
         [ text "Regular 24px" ]
       """
      )
    , ( Options.styled p [ Typo.title ] [ text "Medium 20px" ]
      , """
      Options.styled p
        [ Typo.title ]
        [ text "Medium 20px" ]
      """
      )
    , ( Options.styled p [ Typo.subhead ] [ text "Regular 16px (Device), Regular 15px (Desktop)" ]
      , """
       Options.styled p
         [ Typo.subhead ]
         [ text "Regular 16px (Device), Regular 15px (Desktop)" ]
       """
      )
    , ( Options.styled p [ Typo.body2 ] [ text "Medium 14px (Device), Medium 13px (Desktop)" ]
      , """
        Options.styled p
          [ Typo.body2 ]
          [ text "Medium 14px (Device), Medium 13px (Desktop)" ]
        """
      )
    , ( Options.styled p [ Typo.body1 ] [ text "Regular 14px (Device), Regular 13px (Desktop)" ]
      , """
        Options.styled p
          [ Typo.body1 ]
          [ text "Regular 14px (Device), Regular 13px (Desktop)" ]
        """
      )
    , ( Options.styled p [ Typo.caption ] [ text "Regular 12px" ]
      , """
        Options.styled p
          [ Typo.caption ]
          [ text "Regular 12px" ]
        """
      )
    , ( Options.styled p [ Typo.button ] [ text "Medium (All Caps) 14px" ]
      , """
        Options.styled p
          [ Typo.button ]
          [ text "Medium (All Caps) 14px" ]
        """
      )
    , ( Options.styled p [ Typo.menu ] [ text "Medium 14px (Device), Medium 13px (Desktop)" ]
      , """
        Options.styled p
          [ Typo.menu ]
          [ text "Medium 14px (Device), Medium 13px (Desktop)" ]
        """
      )
    ]


demo2 : List ( Html a, String )
demo2 =
    [ ( Options.styled p [ Typo.left ] [ text "Left align" ]
      , """
       Options.styled p
         [ Typo.left ]
         [ text "Left align" ]
       """
      )
    , ( Options.styled p [ Typo.center ] [ text "Center align" ]
      , """
       Options.styled p
         [ Typo.center ]
         [ text "Center align" ]
       """
      )
    , ( Options.styled p [ Typo.right ] [ text "Right align" ]
      , """
       Options.styled p
         [ Typo.right ]
         [ text "Right align" ]
       """
      )
    , ( Options.styled p [ Typo.justify ] [ text "Justified" ]
      , """
       Options.styled p
         [ Typo.justify ]
         [ text "Justified" ]
       """
      )
    , ( Options.styled p [ Typo.capitalize ] [ text "capitalized" ]
      , """
       Options.styled p
         [ Typo.capitalize ]
         [ text "capitalized" ]
       """
      )
    , ( Options.styled p [ Typo.lowercase ] [ text "LOWERCASE" ]
      , """
       Options.styled p
         [ Typo.lowercase ]
         [ text "LOWERCASE" ]
       """
      )
    , ( Options.styled p [ Typo.uppercase ] [ text "uppercase" ]
      , """
       Options.styled p
         [ Typo.uppercase ]
         [ text "uppercase" ]
       """
      )
    ]


view : Model -> Html Msg
view model =
    let
        head =
            Grid.cell
                [ Grid.size Grid.All 12 ]
                [ p [] [ text "Imports" ]
                , Code.code [ css "margin" "24px 0" ] """
                     import Material.Typography as Typo
                     import Material.Options as Options
                     import Html exposing (p)
                     """
                , p [] [ text "Example use" ]
                ]

        cell x =
            Grid.cell
                [ Grid.size Grid.Desktop 6
                , Grid.size Grid.Tablet 8
                , Grid.size Grid.Phone 4
                , Grid.align Grid.Middle
                ]
                [ x ]

        demo =
            List.concatMap (\( d, c ) -> [ cell d, cell (Code.code [] c) ])
    in
        Page.body1_ "Typography"
            srcUrl
            intro
            references
            [ Grid.grid [] <| head :: demo demo1 ]
            [ Grid.grid [] <| demo demo2 ]


intro : Html m
intro =
    Page.fromMDL "https://github.com/google/material-design-lite/tree/mdl-1.x/src/typography#introduction" """
> The Material Design Lite (MDL) typography component is a comprehensive approach
> to standardizing the use of typefaces in applications and page displays. MDL
> typography elements are intended to replace the myriad fonts used by developers
> (which vary significantly in appearance) and provide a robust, uniform library
> of text styles from which developers can choose.
>
> The "Roboto" typeface is the standard for MDL display; it can easily be
> integrated into a web page using the CSS3 @font-face rule. However, Roboto is
> most simply accessed and included using a single standard HTML <link> element,
> which can be obtained at this Google fonts page.
>
> Because of the many possible variations in font display characteristics in HTML
> and CSS, MDL typography aims to provide simple and intuitive styles that use the
> Roboto font and produce visually attractive and internally consistent text
> results. See the typography component's [Material Design specifications](https://material.google.com/style/typography.html) page for
> details.
"""


srcUrl : String
srcUrl =
    "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Typography.elm"


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Typography"
    , Page.mds "https://material.google.com/style/typography.html"
    , Page.mdl "https://github.com/google/material-design-lite/tree/mdl-1.x/src/typography#introduction"
    ]
