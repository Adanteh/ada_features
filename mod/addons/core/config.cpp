#define __INCLUDE_IDCS
#include "module.hpp"
#include "macros.hpp"

class CfgPatches {
    class ADDON {
        author = AUTHOR;
        name = ADDONNAME;
        units[] = {};
        weapons[] = {};
        version = VERSION;
        requiredaddons[] = {
            "A3_Data_F_Loadorder",
            "A3_Data_F_Curator_Loadorder",
            "A3_Data_F_Kart_Loadorder",
            "A3_Data_F_Bootcamp_Loadorder",
            "A3_Data_F_Heli_Loadorder",
            "A3_Data_F_Mark_Loadorder",
            "A3_Data_F_Exp_A_Loadorder",
            "A3_Data_F_Exp_B_Loadorder",
            "A3_Data_F_Exp_Loadorder",
            "A3_Data_F_Jets_Loadorder",
            "A3_Data_F_Argo_Loadorder",
            "A3_Data_F_Patrol_Loadorder",
            "A3_Data_F_Orange_Loadorder",
            "A3_Data_F_Tacops_Loadorder"
        };
    };
};


class PREFIX {
    class Modules {
        class MODULE {
            defaultLoad = 1;
            noHeader = 1;  // Skip the private variables set in function headers

            class ppEffectCreate;
            #include "functions\debug\functions.hpp"
            #include "functions\strings\functions.hpp"
            #include "functions\ui\functions.hpp"
        };
    };
};



// -- Add more functions through modular system, instead of here.
// #ifdef ISDEV
    // #define RECOMPILE recompile = 1;
// #else
    #define RECOMPILE
// #endif

class CfgFunctions {
    class ADDON {
        class Compiling {
            file = "x\ada\addons\core\compile";
            class compile { RECOMPILE };
            class moduleQueue { RECOMPILE };
            class moduleQueueExecute { RECOMPILE };
            class moduleLoad { RECOMPILE };
        };
    };
};

class Extended_PreInit_EventHandlers { 
    GVAR(moduleLoad) = QUOTE(['preinit'] call FUNC(moduleLoad));
    GVAR(moduleQueueExecute) = QUOTE(['preinit'] call FUNC(moduleQueueExecute));
};

class Extended_PostInit_EventHandlers {
    GVAR(a_preInit) = QUOTE(['init'] call FUNC(moduleQueueExecute));
    GVAR(b_postinit) = QUOTE(['postinit'] call FUNC(moduleQueueExecute))
};

#include "ui\ui.hpp"