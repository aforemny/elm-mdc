module Internal.Helpers exposing
    ( cmd
    , delayedCmd
    , succeedIfLeavingElement
    )

import Json.Decode as Decode exposing (Decoder)
import Platform.Cmd exposing (Cmd)
import Process
import Task


cmd : msg -> Cmd msg
cmd msg =
    Task.perform identity (Task.succeed msg)


delayedCmd : Float -> m -> Cmd m
delayedCmd time msg =
    Task.perform (always msg) <| Process.sleep time


{- Decoder functions to detect if focus moves away from the list itself.

   These functions check if a given DOM element is equal to another DOM
   element, or contained by it.

   Thanks: https://github.com/xarvh/elm-onclickoutside/blob/master/src/Html/OnClickOutside.elm
-}


succeedIfContainerOrChildOfContainer : String -> Decoder ()
succeedIfContainerOrChildOfContainer targetId =
    Decode.field "id" Decode.string
        |> Decode.andThen
            (\id ->
                if id == targetId then
                    Decode.succeed ()

                else
                    Decode.field "parentNode" (succeedIfContainerOrChildOfContainer targetId)
            )


invertDecoder : Decoder a -> Decoder ()
invertDecoder decoder =
    Decode.maybe decoder
        |> Decode.andThen
            (\maybe ->
                if maybe == Nothing then
                    Decode.succeed ()

                else
                    Decode.fail ""
            )


succeedIfLeavingElement : String -> Decoder ()
succeedIfLeavingElement targetId =
    succeedIfContainerOrChildOfContainer targetId
        |> Decode.field "relatedTarget"
        |> invertDecoder
