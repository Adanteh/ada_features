// -- Project settings
#define PREFIX ADA
#define AUTHOR "Adanteh"
#include "VERSION.hpp"

#define DOUBLE(var1,var2) var1##_##var2
#define TRIPLE(var1,var2,var3) DOUBLE(var1,DOUBLE(var2,var3))
#define QUOTE(var) #var

#define BASEPATH x\ada\addons
#define ICONPATH BASEPATH\core\icons
#define ICON(varCategory, varName) QUOTE(ICONPATH\varCategory\varName.paa)
#define TEXTURE(varName) QUOTE(BASEPATH\MODULE\data\varName)
#define MTEXTURE(varName) QUOTE(BASEPATH\Main\data\varName)

#ifndef MODULE
    #define MODULE Core
#endif

#define ADDON DOUBLE(PREFIX,MODULE)
#define ADDONNAME QUOTE(NoStep - MODULE)
#define QADDON QUOTE(ADDON)

// -- Module macros
#define EFUNC(var1,var2) TRIPLE(PREFIX,var1,DOUBLE(fnc,var2))
#define QEFUNC(var1,var2) QUOTE(EFUNC(var1,var2))
#define EGVAR(var1,var2) TRIPLE(PREFIX,var1,var2)
#define QEGVAR(var1,var2) QUOTE(EGVAR(var1,var2))

// Module vars
#define FUNC(var1) EFUNC(MODULE,var1)
#define QFUNC(var1) QUOTE(FUNC(var1))
#define DFUNC(var1) EFUNC(MODULE,var1)
#define GVAR(var1) EGVAR(MODULE,var1)
#define QGVAR(var1) QEGVAR(MODULE,var1)

// -- Core (library) variables
#define CVAR(var1) EGVAR(Core,var1)
#define QCVAR(var1) QEGVAR(Core,var1)
#define CFUNC(var1) EFUNC(Core,var1)
#define QCFUNC(var1) QUOTE(CFUNC(var1))

// -- Short variables (No module name, use for easy subclasses)
#define SVAR(var1) DOUBLE(PREFIX,var1)
#define QSVAR(var1) QUOTE(SVAR(var1))

#define RANDOMOFFSET(var1,var2) (var1 - (var2 / 2) + (random var2))

// -- Localization -- //
#define LSTRING(var1) localize QUOTE(TRIPLE(STR,ADDON,var1))
#define ELSTRING(var1,var2) QUOTE(TRIPLE(STR,DOUBLE(PREFIX,var1),var2))
#define CSTRING(var1) QUOTE(TRIPLE($STR,ADDON,var1))
#define ECSTRING(var1,var2) QUOTE(TRIPLE($STR,DOUBLE(PREFIX,var1),var2))
#define LSTR(var1) QUOTE(TRIPLE($STR,ADDON,var1))

// -- Script macros
#define LOCALIZE(var1) [var1, QUOTE(PREFIX), QUOTE(LANGUAGE)] call CFUNC(localize)
#define RETURN(var1) var1 breakOut (_fnc_scriptName + "_main")
#define ISFRIEND(var1) (side group var1 getFriend playerSide > 0.6)
#define THISFUNC (uiNamespace getVariable _fnc_scriptName)

#define LOGTHIS ["debugMessage", [_this, "cyan"]] call cba_fnc_localEvent;
#define LOGTHISBLUE ["debugMessage", [_this, "blue"]] call cba_fnc_localEvent;
#define LOGTHISGREEN ["debugMessage", [_this, "green"]] call cba_fnc_localEvent;
#define LOG(var1) ["debugMessage", [var1, "green"]] call cba_fnc_localEvent;

#define ISDEV
