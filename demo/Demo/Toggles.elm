module Demo.Toggles exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Array
import Bitwise
import Material.Grid as Grid
import Material.Options as Options exposing (css, cs)
import Material.Helpers as Helpers
import Material.Toggles as Toggles
import Material.Button as Button
import Material.Typography as Typography
import Material
import Demo.Page as Page
import Demo.Code as Code


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
    let
        demo1 =
            [ Grid.grid
                []
                [ Grid.cell row
                    [ Toggles.switch Mdl
                        [ 0 ]
                        model.mdl
                        [ Options.onToggle (Switch 0)
                        , Toggles.ripple
                        , Toggles.value (get 0 model)
                        ]
                        [ text "Switch" ]
                    , "Toggles.switch Mdl [0] model.mdl\n  [ Options.onToggle MyToggleMsg\n  , Toggles.ripple\n  , Toggles.value "
                        ++ toString (get 0 model)
                        ++ "\n  ]\n  [ text \"Switch\" ]"
                        |> Code.code [ css "margin" "16px 0" ]
                    ]
                , Grid.cell row
                    [ Toggles.checkbox Mdl
                        [ 1 ]
                        model.mdl
                        [ Options.onToggle (Switch 1)
                        , Toggles.ripple
                        , Toggles.value (get 1 model)
                        ]
                        [ text "Checkbox" ]
                    , "Toggles.checkbox Mdl [0] model.mdl\n  [ Options.onToggle MyToggleMsg\n  , Toggles.ripple\n  , Toggles.value "
                        ++ toString (get 1 model)
                        ++ "\n  ]\n  [ text \"Checkbox\" ]"
                        |> Code.code [ css "margin" "16px 0" ]
                    ]
                , Grid.cell row
                    [ Toggles.radio Mdl
                        [ 2 ]
                        model.mdl
                        [ Toggles.value (2 == model.radios)
                        , Toggles.group "MyRadioGroup"
                        , Toggles.ripple
                        , Options.onToggle (Radio 2)
                        ]
                        [ text "Emacs" ]
                    , Toggles.radio Mdl
                        [ 3 ]
                        model.mdl
                        [ css "margin-left" "2rem"
                        , Toggles.value (3 == model.radios)
                        , Toggles.group "MyRadioGroup"
                        , Toggles.ripple
                        , Options.onToggle (Radio 3)
                        ]
                        [ text "Vim" ]
                    , """
                  div
                    []
                    [ Toggles.radio Mdl [0] model.mdl
                        [ Toggles.value """
                        ++ toString (2 == model.radios)
                        ++ """
                        , Toggles.group "MyRadioGroup"
                        , Toggles.ripple
                        , Options.onToggle MyRadioMsg1
                        ]
                        [ text "Emacs" ]
                    , Toggles.radio Mdl [1] model.mdl
                        [ Toggles.value """
                        ++ toString (3 == model.radios)
                        ++ """
                        , Toggles.group "MyRadioGroup"
                        , Toggles.ripple
                        , Options.onToggle MyRadioMsg2
                        ]
                        [ text "Vim" ]
                    ] """
                        |> Code.code [ css "margin" "16px 0" ]
                    ]
                ]
            ]

        demo2 =
            [ Grid.grid
                []
                [ Grid.cell
                    [ Grid.size Grid.Desktop 6
                    , Grid.size Grid.Tablet 4
                    , Grid.size Grid.Phone 4
                    ]
                    [ Options.span
                        [ Typography.display4
                        , css "margin-right" "4rem"
                        ]
                        [ text <| toString model.counter ]
                    ]
                , Grid.cell
                    [ Grid.size Grid.Desktop 6
                    , Grid.size Grid.Tablet 4
                    , Grid.size Grid.Phone 4
                    , Grid.align Grid.Bottom
                    ]
                    [ Button.render Mdl
                        [ 5 ]
                        model.mdl
                        [ Button.raised
                        , Button.colored
                        , Button.ripple
                        , Options.onClick Inc
                        , css "margin-bottom" "2rem"
                        , css "width" "196px"
                        , css "display" "inline-block"
                        ]
                        [ text "Increase" ]
                    , Toggles.switch Mdl
                        [ 4 ]
                        model.mdl
                        [ Options.onToggle ToggleCounting
                        , Toggles.ripple
                        , Toggles.value model.counting
                        ]
                        [ text "Auto-increase" ]
                    ]
                , Grid.cell
                    [ Grid.size Grid.All 4
                    , css "display" "flex"
                    , css "flex-direction" "row"
                    ]
                    (List.range 0 10
                        |> List.map
                            (\idx ->
                                Toggles.checkbox Mdl
                                    [ 6, idx ]
                                    model.mdl
                                    [ Toggles.value (readBit idx model.counter)
                                    , Toggles.ripple
                                    , Options.onToggle (Update <| \m -> { m | counter = flipBit idx model.counter })
                                    , css "display" "inline-block"
                                    ]
                                    []
                            )
                        |> List.reverse
                    )
                ]
            ]
    in
        Page.body1_ "Toggles" srcUrl intro references demo1 demo2


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
