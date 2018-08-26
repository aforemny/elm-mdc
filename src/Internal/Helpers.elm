module Internal.Helpers
    exposing
        ( cmd
        , delayedCmd
        )

import Platform.Cmd exposing (Cmd)
import Process
import Task


cmd : msg -> Cmd msg
cmd msg =
    Task.perform identity (Task.succeed msg)


delayedCmd : Float -> m -> Cmd m
delayedCmd time msg =
    Task.perform (always msg) <| Process.sleep time
