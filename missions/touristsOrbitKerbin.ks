// kOS mission No. 1

// stages 
// 7: prelaunch
// 6: booster with TWR of 1.3 
// 5: decoupling start-stabilisation
// 4: LV
// 3: decoupling booster
// 2: decoupling LV
// 1: Parachutes
// [0: decoupling computer from Vessel] - won't be executed

importLib("functionsBasic").

sas off.
print "The ship '" + ship:name + "' is ready.".
print "Body: " + ship:body:name.
print "Altitude above sea level: " + round(ship:altitude, 0) + " m".

startCountdown(3).

sas off.
lock steering to heading(90, 90).

doNextStage().
print "Ignition".  

doNextStage().
print "Liftoff".  

when (stage:resourceslex["SolidFuel"]:amount < 0.01) then {
    lock throttle to (15 / 15).
    doNextStage().
}

//Kerbin @ 29.4 km & 70 km
doGravityTurnEast((ship:body:atm:height * 0.42), 
                (ship:body:atm:height * 1.0)).
print "End gravity turn.".


set missionStep to "establishOrbitEasyMode".

establishOrbitEasyMode("doReEntryEasyMode").

doReEntryEasyMode("Mission accomplished").

lock throttle to 0.

unlock steering.
print "***********".


global function establishOrbitEasyMode {
    parameter nextMissionStep.

    if (missionStep = "establishOrbitEasyMode") {
        set secondsToManeuver to 20.
        print "Waiting for maneuver.".
        print "Estimated Time of Arrival: T- " 
            + (round(ship:orbit:ETA:apoapsis, 3) - secondsToManeuver) 
            + " s".

        // ETA is always positive and counting down
        wait until ship:orbit:ETA:apoapsis <= secondsToManeuver. 
        print "Burning at apoapsis: " + round(ship:orbit:apoapsis, 0) + " m".
        lock throttle to 1.
        print "Target apoapsis: " + (ship:body:atm:height * 1.1).

        // Kerbin @ 77 km
        wait until (ship:orbit:apoapsis >= ship:body:atm:height * 1.1).
        lock throttle to 0. 
        print "New Apoapsis: " + round(ship:orbit:apoapsis, 0) + " m".
        print "Estimated Time of Arrival: T- " 
            + (round(ship:orbit:ETA:apoapsis, 3) - secondsToManeuver) 
            + " s".

        wait until ship:orbit:ETA:apoapsis <= secondsToManeuver. 
        print "Raising perapsis.".
        lock throttle to 1.
        
        // Kerbin @ 73.5 km
        wait until (ship:orbit:periapsis >= ship:body:atm:height * 1.05).
        lock throttle to 0.
        print "New periapsis: " + round(ship:orbit:periapsis, 0) + " m".
        print "New apoapsis: " + round(ship:orbit:apoapsis, 0) + " m".
        print "Succesfully established orbit around:".
        print "'" + ship:body:name + "'".

        set missionStep to nextMissionStep.
    }
}

global function doReEntryEasyMode {
    parameter nextMissionStep.

    if (missionStep = "doReEntryEasyMode") {
        lock steering to retrograde.
        //deorbit to 35 km
        wait until vAng(ship:facing:vector, ship:srfRetrograde:vector) <= 0.3.
        wait 10.
        lock throttle to 1.
        
        wait until ship:orbit:periapsis <= (ship:body:atm:height * 0.50).

        wait 0.
        lock throttle to 0.
        doNextStage().

        wait until ship:altitude <= 10_000.
        doNextStage().

        //landing
        wait until ship:status = "LANDED" or "SPLASHED".
        print ship:status.

        set missionStep to nextMissionStep.
    }
}