global function calcDeltaV {
    parameter newPeriapsis, newApoapsis, shipAltitude.
    local bodyGravitationalParam is ship:body:mu.
    local shipAltitudeFrCenter is shipAltitude + ship:body:radius.
    local periapsisFrCenter is periapsis + ship:body:radius.
    local apoapsisFrCenter is apoapsis + ship:body:radius.
    local ellipseSemiMajorAxis is (periapsisFrCenter + apoapsisFrCenter) / 2.
    
    // delta v for the Hohmann transfer orbital maneuver
    return sqrt(bodyGravitationalParam * (2 / shipAltitudeFrCenter - 1 / ellipseSemiMajorAxis)). 
}