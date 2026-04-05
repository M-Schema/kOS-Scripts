// Stages
// [7: decoupling Computer from Vessel] - won't be executed
// 6: Prelaunch
// 5: Booster with TWR of 1.3 
// 4: decoupling start-stabilisation
// 3: LV
// 2: decoupling Booster
// 1: decoupling LV
// 0: Parachutes

importLib("functionsOrbitKerbinEasyMode").

if (ship:status = "PRELAUNCH") {
    set stagePrelaunch to ship:stageNum. 
} else {
    set stagePrelaunch to -1. 
}

lock stageNumber to ship:stageNum. // always re-evaluated

sas off.
print "The ship '" + ship:name + "' is ready.".
print "Body: " + ship:body:name.
print "Altitude above sea level: " + round(ship:altitude, 0) + " m".

startCountdown(3, stagePrelaunch, "Liftoff").

liftoff("doGravityTurn"). 

doGravityTurn("establishOrbitEasyMode").

establishOrbitEasyMode("doReEntryEasyMode").

doReEntryEasyMode("Mission accomplished").

lock throttle to 0.

unlock steering.
print "***********".