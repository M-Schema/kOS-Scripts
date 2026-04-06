global function updateTerminalWindow {
//TODO 
//print "" at (0, row). -> override row
}

global function startCountdown {
    parameter seconds.
    
    print "Starting countdown. Stage number prelaunch: " + ship:stageNum.
    
    from {local countdown is seconds.} 
    until countdown = 0 
    step {SET countdown to countdown - 1.} 
    do {
        print countdown.
        wait 1.
    }   
}

global function doNextStage {
    wait until stage:ready.
    stage.
    print "Stage Number: " + ship:stageNum.
}

global function doGravityTurnEast {
    parameter altitudeToPrograde, newApoapsis.
    
    sas off.

    when (ship:orbit:apoapsis >= newApoapsis) then {
        lock throttle to 0.
        print "New apoapsis: " + round(ship:orbit:apoapsis, 0) + " m".
    }
      
    wait until ship:velocity:surface:mag >= 40. // m/s
    print "Gravity Turn. Start heading to: East".
    lock steering to heading(90, 85, 0).

    wait until vectorAngle(ship:facing:vector, heading(90, 85, 0):vector) <= 0.3.
    print "Heading east.".

    wait until vectorAngle(ship:srfPrograde:vector, ship:facing:vector) <= 0.3.
    lock steering to srfPrograde. //surface prograde
    print "Start heading to: surface prograde".

    wait until ship:altitude >= 5_000.
    lock steering to heading(90, 45, 0).
    print "45°".

    wait until ship:altitude >= 10_000.
    lock steering to srfPrograde.
    print "surface prograde".

    wait until ship:altitude >= altitudeToPrograde.
    print "Steering to prograde at altitude: " 
        + round(ship:altitude, 0) + " m". 
    lock steering to prograde.
}

global function calcVelocity {
    parameter newPeriapsis, newApoapsis, shipAltitude.

    local bodyGravitationalParameter is ship:body:mu.
    local shipAltitudeFrCenter is shipAltitude + ship:body:radius.
    local periapsisFrCenter is newPeriapsis + ship:body:radius.
    local apoapsisFrCenter is newApoapsis + ship:body:radius.
    local ellipseSemiMajorAxis is (periapsisFrCenter + apoapsisFrCenter) / 2.
    
    return sqrt(bodyGravitationalParameter 
            * (2 / shipAltitudeFrCenter - 1 / ellipseSemiMajorAxis)
        ). 
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

    print "initial Velocity: " + round(initialVelocity, 2) + " m/s".
    print "  final Velocity: " + round(finalVelocity, 2) + " m/s".
    print "         delta V: " + round(deltaV, 2) + " m/s".

    return deltaV.
}

global function setHohmannTransferOrbitalManeuver {
    parameter startingAltitude, targetAltitude.

    print "Calculating: 'Hohmann transfer orbital maneuver'".
    set deltaV to calcDeltaV(startingAltitude, targetAltitude).

    if (startingAltitude >= ship:orbit:apoapsis - 3) {
        set maneuverETA to ship:orbit:ETA:apoapsis.
    } else if (startingAltitude <= ship:orbit:periapsis + 3){
        set maneuverETA to ship:orbit:ETA:periapsis.
    } else {
        print "Error: Couldn't find ETA. Setting it to 60.".
        set maneuverETA to 60. 
    }

    print "Setting maneuver node.".    
    set newManeuver to node((time:seconds + maneuverETA), 
                            0, 0, deltaV).
    add newManeuver.
}

global function doManeuver {

    if (not(hasNode)) {
        print "Error: No maneuver node found.".
        return.
    }
    
    set maxAcceleration to ship:maxThrust / ship:mass.
    set maneuverBurnDuration to newManeuver:deltaV:mag / maxAcceleration.
    set maneuverStartTime to (time:seconds + newManeuver:ETA - (maneuverBurnDuration /2)).
    set maneuverEndTime to (time:seconds + newManeuver:ETA + (maneuverBurnDuration /2)).

    wait until time:seconds >= (maneuverStartTime - 30).
    lock steering to newManeuver:burnVector.

    wait until vectorAngle(ship:facing:vector, newManeuver:burnVector) < 1.
    print "Facing burn vector".

    wait until time:seconds >= maneuverStartTime.
    lock throttle to 1.
    print "Starting maneuver. Burn duration: " + round(maneuverBurnDuration, 2) + " s".

    wait until time:seconds >= maneuverEndTime.
    
    //wait until (vectorAngle(newManeuver:burnVector, newManeuver:burnVector) < 0).
    

    lock throttle to 0.
    unlock throttle.
    unlock steering.

    remove newManeuver.

    print " ".
    print " *********** ".
    print "Done: 'Hohmann transfer orbital maneuver'". 
    print " ".
    print "Orbit's period: " + round(ship:orbit:period, 2).
    print "Orbit's inclination: " + round(ship:orbit:inclination, 2).
    print "Orbit's eccentricity: " + round(ship:orbit:eccentricity, 2). 
    print "Orbit's semimajoraxis: " + round(ship:orbit:semimajoraxis, 2). 
    print " *********** ".
    print " ".
}