global function startCountdown {
    parameter seconds.

    print "Starting Countdown".
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
    print "Stage".
    wait 0.
}

global function returnSensors {
    until ship:altitude > 10_000 {
        print "Q: " + round(ship:Q,2) + " atm" at (0,0). //Tabellenfunktion
        print "Temperature: " + round(ship:sensors:temp, 2) + " K" at (0,1).
        print "Pressure: " + round(ship:sensors:pres, 2) + " kPa" at (0,2).

        wait 0.
    }
}

global function liftoff {
    sas off.
    lock steering to heading(90, 90).
    doNextStage(). //Booster
    print "Ignition".  
    doNextStage(). //Halterungen
    print "Liftoff".  
}

global function doGravityTurn {
    sas off.
    
    //lock throttle to (0 / 15).
    //doNextStage(). //Schwenker inkl throttle

    wait until ship:velocity:surface:mag >= 40. // m/s
    print "Gravity Turn.".
    lock steering to heading(90, 85, 0).

    wait until vAng(ship:facing:vector, heading(90, 85, 0):vector) <= 0.3.
    print "vector".

    wait until vAng(ship:srfPrograde:vector, ship:facing:vector) <= 0.3.
    lock steering to srfPrograde. //surface prograde
    print "surface prograde".

}