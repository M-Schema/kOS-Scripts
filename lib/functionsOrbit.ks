global function doManeuver {
    if (not(hasNode)) {
        print "Error: No maneuver node found.".
        return.
    }
    // Tsiolkovsky rocket equation
    set maxAcceleration to (ship:maxThrust / ship:mass).
    set maneuverBurnDuration to nextNode:deltaV:mag / maxAcceleration.
    set maneuverStartTime to ((time:seconds + nextNode:ETA) - (maneuverBurnDuration /2)).
    set maneuverEndTime to ((time:seconds + nextNode:ETA) + (maneuverBurnDuration /2)).
    
    //set maneuverStartTime to ((time:seconds + nextNode:ETA) - (nextNode:ETA / 2)).
    //set maneuverEndTime to ((time:seconds + nextNode:ETA) + (nextNode:ETA / 2)).
    

    //wait until time:seconds >= (maneuverStartTime - 30).
    lock steering to nextNode:burnVector.
    //print "maneuverStartTime: " + maneuverStartTime .

    wait until vectorAngle(ship:facing:vector, nextNode:burnVector) < 1.
    print "Facing burn vector".

    wait until time:seconds >= maneuverStartTime.
    lock throttle to 1.
    print "Starting maneuver.". 
    // Burn duration: " + round(maneuverBurnDuration, 2) + " s".

    // little correction
    when (time:seconds >= (maneuverEndTime -10)) then {
        //lock steering to prograde.    
        unlock steering.
        SAS on.
    }
    
    wait until time:seconds >= maneuverEndTime.
    
    //wait until (vectorAngle(newManeuver:burnVector, newManeuver:burnVector) < 0).
    

    lock throttle to 0.
    unlock throttle.
    //unlock steering.
    //set maxAcceleration to 0.
    //set maneuverBurnDuration to 0.
    //set maneuverStartTime to 0.
    //set maneuverEndTime to 0.

    remove nextNode. //newManeuver.
    print "Done: maneuver".
    SAS off.

    print " ".
    print " *********** ". 
    print "Orbit's period: " + round(ship:orbit:period, 2) + " s".
    print "Orbit's inclination: " + round(ship:orbit:inclination, 2) + "°".
    print "Orbit's eccentricity: " + round(ship:orbit:eccentricity, 2) + " ". 
    print "Orbit's semimajoraxis: " + round(ship:orbit:semimajoraxis, 2) + " m". 
    print " *********** ".
    print " ".
}

global function setHohmannTransferOrbitalManeuver {
    parameter startingAltitude, targetAltitude.

    print "Calculating: 'Hohmann transfer orbital maneuver'".
    set deltaV to calcDeltaV(startingAltitude, targetAltitude).

    if (startingAltitude >= ship:orbit:apoapsis - 3) {
        set maneuverETA to ship:orbit:ETA:apoapsis.
        //print "set maneuverETA to " + ship:orbit:ETA:apoapsis.
    } else if (startingAltitude <= ship:orbit:periapsis + 3){
        set maneuverETA to ship:orbit:ETA:periapsis.
        //print "set maneuverETA to " + ship:orbit:ETA:periapsis.
    } else {
        print "Error: Couldn't find ETA. Setting it to 60.".
        set maneuverETA to 60. 
    }

    print "Setting maneuver node.".    
    set newManeuver to node((time:seconds + maneuverETA), 
                            0, 0, deltaV).
    add newManeuver.
}

global function calcDeltaV {
    parameter startingAltitude, targetAltitude.

    set initialVelocity to calcVelocity(ship:orbit:periapsis, ship:orbit:apoapsis, startingAltitude).
    
    if (startingAltitude < targetAltitude) {
        set finalVelocity to calcVelocity(startingAltitude, targetAltitude, startingAltitude).
    } else {
        set finalVelocity to calcVelocity(targetAltitude, startingAltitude, startingAltitude).    
    }
    
    set deltaV to finalVelocity - initialVelocity.

    print "initial velocity: " + round(initialVelocity, 2) + " m/s".
    print "  final velocity: " + round(finalVelocity, 2) + " m/s".
    print "         delta v: " + round(deltaV, 2) + " m/s".

    return deltaV.
}

global function calcVelocity {
    parameter newPeriapsis, newApoapsis, shipAltitude.

    local bodyGravitationalParameter is ship:body:mu.
    local shipAltitudeFrCenter is shipAltitude + ship:body:radius.
    local periapsisFrCenter is newPeriapsis + ship:body:radius.
    local apoapsisFrCenter is newApoapsis + ship:body:radius.
    local ellipseSemiMajorAxis is ((periapsisFrCenter + apoapsisFrCenter) / 2).
    
    return sqrt(bodyGravitationalParameter * (2 / shipAltitudeFrCenter - 1 / ellipseSemiMajorAxis)).
}