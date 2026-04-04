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

        wait until ship:altitude = (ship:orbit:apoapsis - 100).
        print "Apoapsis: " + ship:orbit:apoapsis.
        lock throttle to 1.

        wait until ship:orbit:periapsis = ship:orbit:apoapsis.
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

        //Parachutes ship:srfPrograde:vector

        //landing

        set missionStep to nextMissionStep.
    }
}