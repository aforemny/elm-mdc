module Demo.Toggles exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Array
import Bitwise
import Material.Grid as Grid
import Material.Options as Options exposing (css, cs)
import Material.Helpers as Helpers
import Material.Toggles as Toggles
import Material
import Demo.Page as Page


-- MODEL


type alias Model =
    { mdl : Material.Model
    , toggles : Array.Array Bool
    , radios : Int
    , counter : Int
    , counting : Bool
    }


model : Model
model =
    { mdl = Material.model
    , toggles = Array.fromList [ True, False ]
    , radios = 2
    , counter = 0
    , counting = False
    }



-- ACTION, UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | Switch Int
    | Radio Int
    | Inc
    | Update (Model -> Model)
    | ToggleCounting
    | AutoCount


get : Int -> Model -> Bool
get k model =
    Array.get k model.toggles |> Maybe.withDefault False


delay : Float
delay =
    150


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Switch k ->
            ( { model
                | toggles = Array.set k (get k model |> not) model.toggles
              }
            , none
            )

        Radio k ->
            ( { model | radios = k }, none )

        Inc ->
            ( { model | counter = model.counter + 1 }
            , Cmd.none
            )

        AutoCount ->
            ( { model | counter = model.counter + 1 }
            , if model.counting then
                Helpers.delay delay AutoCount
              else
                Cmd.none
            )

        Update f ->
            ( f model, Cmd.none )

        ToggleCounting ->
            ( { model | counting = not model.counting }
            , if not model.counting then
                Helpers.delay delay AutoCount
              else
                Cmd.none
            )

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


row : List (Options.Style a)
row =
    [ Grid.size Grid.Desktop 4, Grid.size Grid.Tablet 8, Grid.size Grid.Phone 4 ]


readBit : Int -> Int -> Bool
readBit k n =
    0 /= (Bitwise.and 0x01 (Bitwise.shiftRightBy n k))


setBit : Bool -> Int -> Int -> Int
setBit x k n =
    if x then
        Bitwise.or (Bitwise.shiftLeftBy 0x01 k) n
    else
        Bitwise.and (Bitwise.complement (Bitwise.shiftLeftBy 0x01 k)) n


flipBit : Int -> Int -> Int
flipBit k n =
    setBit (not (readBit k n)) k n


view : Model -> Html Msg
view model =
    Page.body1_ "Toggles" srcUrl intro references []
    [ Toggles.checkbox Mdl [0] model.mdl
      [
      ]
      [ text "Switch"
      ]
    ]


intro : Html Msg
intro =
    Page.fromMDL "https://getmdl.io/components/index.html#toggles-section" """
> The Material Design Lite (MDL) checkbox component is an enhanced version of the
> standard HTML `<input type="checkbox">` element. A checkbox consists of a small
> square and, typically, text that clearly communicates a binary condition that
> will be set or unset when the user clicks or touches it. Checkboxes typically,
> but not necessarily, appear in groups, and can be selected and deselected
> individually. The MDL checkbox component allows you to add display and click
>     effects.
>
> Checkboxes are a common feature of most user interfaces, regardless of a site's
> content or function. Their design and use is therefore an important factor in
> the overall user experience. [...]
>
> The enhanced checkbox component has a more vivid visual look than a standard
> checkbox, and may be initially or programmatically disabled.
"""


srcUrl : String
srcUrl =
    "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Toggles.elm"


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Toggles"
    , Page.mds "https://www.google.com/design/spec/components/selection-controls.html"
    , Page.mdl "https://getmdl.io/components/index.html#toggles-section"
    ]
