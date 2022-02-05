#include "macros.hpp"

class CfgPatches {
    class ADDON {
        author = AUTHOR;
        name = ADDONNAME;
        units[] = {};
        weapons[] = {};
        version = VERSION;
        requiredaddons[] = {QSVAR(Core)};
    };
};

class PREFIX {
    class Modules {
        class MODULE {
            defaultLoad = 1;
            dependencies[] = {"Core"}; // -- Requires keybind system in main

            class clientInit;

            class breakWindow;
            class findBuilding;
        };
    };
};
