global function openTerminal {
    core:part:getmodule("kOSProcessor"):doevent("open terminal").
}

global function closeTerminal {
    core:part:getmodule("kOSProcessor"):doevent("close terminal").
}

global function importLib {
    parameter libName.

    copyPath("0:/lib" + libName + ".ks", 
            "1:/lib/" + libName + ".ks").
    runOncePath("1:/lib/" + libName + ".ks").
}

global function runMission {
    parameter nameMission.

    copyPath("0:/missions/" + nameMission + ".ks", 
            "1:/missions/" + nameMission + ".ks").
    cd("1:/missions").
    runPath (nameMission).
}