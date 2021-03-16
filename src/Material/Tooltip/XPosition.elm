module Material.Tooltip.XPosition exposing
    ( XPosition(..)
    )

type XPosition
    = Detected
    | Start
    | End
    | Center -- Note: CENTER is not valid for rich tooltips.
