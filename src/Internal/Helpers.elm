module Internal.Helpers
    exposing
        ( cmd
        , delayedCmd
        )

import Platform.Cmd exposing (Cmd)
import Process
import Task
import Time exposing (Time)


cmd : msg -> Cmd msg
cmd msg =
    Task.perform identity (Task.succeed msg)


delayedCmd : Time -> m -> Cmd m
delayedCmd time msg =
    Task.perform (always msg) <| Process.sleep time
