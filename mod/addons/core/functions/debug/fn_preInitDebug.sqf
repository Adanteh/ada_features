/*
    Function:       ADA_Core_fnc_preInitDebug
    Author:         Adanteh
    Description:    Inits local debug system. This is just a big structured text window
*/
#include "macros.hpp"
#define __MAXMESSAGES 150

#ifndef LOGLEVEL
    #ifdef ISDEV
        #define LOGLEVEL 900
    #else
        #define LOGLEVEL 25
    #endif 
#endif

GVAR(debugStack) = [];
GVAR(dbgLogLevel) = LOGLEVEL;
GVAR(dbgFont) = if (isClass (configFile >> "CfgFontFamilies" >> "EtelkaMonospacePro")) then {
    "EtelkaMonospacePro"
} else {
    "LucidaConsoleB"
};

