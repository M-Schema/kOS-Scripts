importLib("functionsOrbit").

// trans-lunar injection (TLI)
global function setTransMoonManeuver {
  parameter targetMoon.
  //parameter doWarp is false.

  if (targetMoon = "Mun" or "Minimus") {
    set target to targetMoon.
  } else {
    print "Error: Target moon isn't 'Mun' or 'Minimus'.".
    return.
  }

  local targetAngle is 180 - calcTargetAngle(target).
  lock phaseAngle to calcPhaseAngle(target).
  
  until abs(targetAngle - phaseAngle) < 30 { // absolute value -> always positive
    //set warp to 3.
    wait 1.
    print "Target angle: " + round(targetAngle, 2) + "°".
    print "Phase angle: " + round(phaseAngle, 2) + "°".
  }
  //set warp to 0.
  //wait until kuniverse:timewarp:rate = 1.

  local deltaAngle is abs(targetAngle - phaseAngle).
  local deltaTime is deltaAngle * (ship:orbit:period / 360).
  //clearScreen.

  local deltaV is calcDeltaV(ship:altitude, 
                  (target:orbit:apoapsis - target:radius - 30_000)).
  add node(time:seconds + deltaTime, 0, 0, deltaV).
  
  //exeMnv().

  //if orbit:nextpatch:periapsis < 2000 {
    //lock steering to retrograde.
    //set canStage to false.
    //local lim is max(0.5, abs(orbit:nextpatch:periapsis/50_000)).
    //limitThrust(lim).
    //wait 0.
    //wait until vAng(ship:facing:vector, retrograde:vector) < 1.
    //until orbit:nextpatch:periapsis > 10000 {
   //   lock throttle to 1.
  //  }
  //}
  //lock throttle to 0.
  //limitThrust(100).
  //set canStage to true.

  //wait 2.
//////////////////////////////////////////////
  //if doWarp {
  //  warpto(time:seconds + ETA:transition + 120).
  //  wait until kuniverse:timewarp:rate = 1.
  //}
}

function calcTargetAngle {
  parameter targetMoon.
  //local nextPe is ship:apoapsis.
  local semiMajorAxis is (body:radius + ship:apoapsis 
                        + body:radius + targetMoon:orbit:apoapsis) 
                        / 2.
  local semiPeriod is constant:PI * sqrt(semiMajorAxis^3 / body:mu).
  //local targetMoonPeriod is targetMoon:orbit:period.
  return semiPeriod * 360 / targetMoon:orbit:period. //targetMoonPeriod  
}

function calcPhaseAngle {
  parameter targetMoon.
  
  local shipAngle is calcAngle(ship).
  local targetAngle is calcAngle(targetMoon).

  local diffAngle is targetAngle - shipAngle.
  return diffAngle - 360 * floor(diffAngle/360).
}

function calcAngle {
  parameter Obj. // is ship.
  local angle is Obj:orbit:lan + Obj:orbit:argumentofperiapsis + Obj:orbit:trueanomaly.
  return angle - 360*floor(angle / 360). // round down
}