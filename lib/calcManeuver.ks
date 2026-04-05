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

//print ship:orbit:apoapsis. // shows the ship's apoapsis
//print ship:orbit:periapsis. // shows the ship's periapsis
//
//print ship:orbit:period. // shows the ship's period
//print ship:orbit:inclination. // shows the ship's inclination
//print ship:orbit:eccentricity. // shows the ship's eccentricity
//print ship:orbit:semimajoraxis. // shows the ship's semimajoraxis


