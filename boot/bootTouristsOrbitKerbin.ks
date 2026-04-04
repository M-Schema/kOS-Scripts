clearscreen. 

wait until ship:unpacked.
openTerminal().
sas off.

print "The ship " + ship:name
    + " is ready".
print "Body: " + ship:body:name
    + " with altitude above sea level: " + ship:altitude + " m".

wait 0.
runMission(touristsOrbitKerbin).

wait 0.
print "Boot Shutdown".

wait 60.
closeTerminal().


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