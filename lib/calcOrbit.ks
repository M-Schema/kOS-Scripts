global function calcDeltaV {
    parameter newPeriapsis, newApoapsis, shipAltitude.
    local bodyGravitationalParam is ship:body:mu.
    local shipAltitudeFrCenter is shipAltitude + ship:body:radius.
    local periapsisFrCenter is newPeriapsis + ship:body:radius.
    local apoapsisFrCenter is newApoapsis + ship:body:radius.
    local ellipseSemiMajorAxis is (periapsisFrCenter + apoapsisFrCenter) / 2.
    
    // delta v for the Hohmann transfer orbital maneuver
    return sqrt(bodyGravitationalParam 
            * (2 / shipAltitudeFrCenter - 1 / ellipseSemiMajorAxis)
        ). 
}

global function establishOrbit {
    parameter nextMissionStep.

    if (missionStep = "establishOrbit") {
        print "Waiting for maneuver.".
        print "Estimated Time of Arrival: T- " 
            + round(ship:orbit:ETA:apoapsis, 3) + " s".

        //PROBLEM
 
        wait until ship:orbit:ETA:apoapsis <= -5. // ETA is positive and running down!
        print "Apoapsis: " + round(ship:orbit:apoapsis, 0) + " m".
        lock throttle to 1.

        wait until ship:orbit:periapsis = ship:body:atm:height.
        lock throttle to 0.

        set missionStep to nextMissionStep.
    }
}

global function reEntry {
    parameter nextMissionStep.

    if (missionStep = "reEntry") {
        lock steering to retrograde.
        //deorbit to 35 km
        wait until vAng(ship:facing:vector, ship:srfRetrograde:vector) <= 0.3.
        lock throttle to 1.
        //wait until ship:facing:vector = .
        wait until ship:orbit:periapsis = (ship:body:atm:height * 0.50).
        lock throttle to 0.
        doNextStage().

        //Parachutes ship:srfPrograde:vector
        wait until ship:altitude >= 10_000.
        doNextStage().

        //landing
        wait until ship:status = "LANDED" or "SPLASHED".
        print ship:status.

        set missionStep to nextMissionStep.
    }
}