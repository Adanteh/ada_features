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
            noHeader = 1;
            dependencies[] = {"Core"};

            class preinit;
            class clientInit;

            class handleEffects;
            class onPlayerSwitch;
        };
    };
};