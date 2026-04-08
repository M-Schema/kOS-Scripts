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