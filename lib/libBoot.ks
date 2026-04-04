global function openTerminal {
    core:part:getmodule("kOSProcessor"):doevent("open terminal").
}

global function closeTerminal {
    core:part:getmodule("kOSProcessor"):doevent("close terminal").
}

global function importLib {
    parameter libName.

    copyPath("0:/lib" + libName, "1:/lib/" + libName).
    runOncePath("1:/lib/" + libName).
}

global function runMission {
    parameter nameMission.

    copyPath("0:/mission" + nameMission, 
            "1:/mission/" + nameMission).
    cd("1:/mission").
    run nameMission.
}