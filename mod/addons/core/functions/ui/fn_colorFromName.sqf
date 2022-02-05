/*
    Function:       ADA_Core_fnc_colorFromName
    Author:         Adanteh
    Description:    Uses some common colors from a given string name, returns hex color code
    Example:        ["red"] call ADA_Core_fnc_colorFromName
*/
#include "macros.hpp"

params [["_colorName", ""]];

private _color = switch (toLower _colorName) do {
    case "white": { "#FFFFFF"; };
    case "green": { "#00EE00" };
    case "black": { "#000000"; };
    case "warning";
    case "error";
    case "red": { "#F74A4A" };
    case "blue": { "#6871F9" };
    case "cyan": { "#33CCFF" };
    case "magenta": { "#FF3399" };
    case "lime": { "#87FF00" };
    case "green": { "#00C100" };
    case "olive": { "#82AC2C" };
    case "purple": { "#CC00CC" };
    case "orange": { "#F9B53A" };
    case "yellow": { "#FFFF3D" };
    case "grey": { "#A7A7A7" };
    default { _colorName };
};

_color;
