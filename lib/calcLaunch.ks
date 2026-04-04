global function startCountdown {
    parameter seconds.
    parameter activeStage.
    parameter nextMissionStep.

    if (activeStage = ship:stageNum and ship:status = "PRELAUNCH") {
        print "Starting Countdown. Stage Number: " + stageNumber.
        
        from {local countdown is seconds.} until countdown = 0 
        step {SET countdown to countdown - 1.} 
        do {
            print countdown.
            wait 1.
        }   

        set missionStep to nextMissionStep. 
    }
}

global function doNextStage {
    wait until stage:ready.
    stage.
    print "Stage Number: " + stageNumber.
    wait 0.
}

global function returnSensors { //TODO
    parameter pauseSeconds.
    parameter targetAltitude.

    print " ".
    when (ship:altitude < targetAltitude) then {
        print "Pressure on Vessel: " + round(ship:Q,2) + " atm".
        print "Temperature: " + round(ship:sensors:temp, 2) + " K".
        print "Air Pressure: " + round(ship:sensors:pres, 2) + " kPa".
        print " ".

        wait pauseSeconds.
        preserve.
    }
}

global function liftoff {
    parameter nextMissionStep.

    if (missionStep = "Liftoff") {    
        sas off.
        lock steering to heading(90, 90).
        doNextStage().
        print "Ignition".  
        doNextStage().
        print "Liftoff". 

        set missionStep to nextMissionStep. 
    }
}

global function doGravityTurn {
    parameter nextMissionStep.

    if (missionStep = "doGravityTurn") {
        set boosterThrust to ship:thrust.
        sas off.
        lock throttle to (0 / 15).
        doNextStage().

        //returnSensors(3, 10_000).

        wait until ship:velocity:surface:mag >= 40. // m/s
        print "Gravity Turn.".
        lock steering to heading(90, 85, 0).

        wait until vAng(ship:facing:vector, heading(90, 85, 0):vector) <= 0.3.
        print "Start heading to: vector".

        wait until vAng(ship:srfPrograde:vector, ship:facing:vector) <= 0.3.
        lock steering to srfPrograde. //surface prograde
        print "Start heading to: surface prograde".

        wait until ship:availableThrust < boosterThrust.
        doNextStage().
        lock throttle to 1.
        print "Next target: " + (ship:body:atm:height * 0.50) + " m".

        //Kerbin @ 35 km        
        wait until ship:altitude >= (ship:body:atm:height * 0.50). 
        print "Steering to prograde at altitude: " 
            + round(ship:altitude, 0) + " m". 
        lock steering to prograde.

        //Kerbin @ 80,5 km
        wait until ship:orbit:apoapsis >= (ship:body:atm:height * 1.15). 
        lock throttle to 0.
        print "New apoapsis: " + ship:orbit:apoapsis + " m".
        wait 0.
        SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0. //safety
   
        set missionStep to nextMissionStep.
    }
}


// ***********
global function doDummyStep {
    parameter nextMissionStep.

    if (missionStep = "DUMMY") {
        //

        set missionStep to nextMissionStep.
    }
}