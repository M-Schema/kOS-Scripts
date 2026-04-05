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
        print "Pressure on Vessel: " + round(ship:DYNAMICPRESSURE,2) + " atm".
        print "Temperature: " + round(ship:sensors:temp, 2) + " K".
        print "Air Pressure: " + round(ship:sensors:pres, 2) + " kPa".
        print " ".

        wait pauseSeconds.
        preserve.
    }
}

global function startCountdown {
    parameter seconds.
    parameter activeStage.
    parameter nextMissionStep.

    if (activeStage = ship:stageNum and ship:status = "PRELAUNCH") {
        print "Starting Countdown. Stage Number prelaunch: " + stageNumber.
        
        from {local countdown is seconds.} until countdown = 0 
        step {SET countdown to countdown - 1.} 
        do {
            print countdown.
            wait 1.
        }   

        set missionStep to nextMissionStep. 
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
        sas off.
        lock throttle to (0 / 15).
        doNextStage().

        //returnSensors(3, 10_000).

        when stage:resourceslex["SolidFuel"]:amount < 0.01 then {
            doNextStage().
            lock throttle to 1.
        }
        
        wait until ship:velocity:surface:mag >= 40. // m/s
        print "Gravity Turn. Start heading to: East".
        lock steering to heading(90, 85, 0).
        wait until vAng(ship:facing:vector, heading(90, 85, 0):vector) <= 0.3.
        
        wait until vAng(ship:srfPrograde:vector, ship:facing:vector) <= 0.3.
        lock steering to srfPrograde. //surface prograde
        print "Start heading to: surface prograde".

        //Kerbin @ 29,4 km        
        wait until ship:altitude >= (ship:body:atm:height * 0.42). 
        print "Steering to prograde at altitude: " 
            + round(ship:altitude, 0) + " m". 
        lock steering to prograde.

        //Kerbin @ 70 km
        wait until ship:orbit:apoapsis >= ship:body:atm:height.
        lock throttle to 0.
        print "New apoapsis: " + round(ship:orbit:apoapsis, 0) + " m".
   
        set missionStep to nextMissionStep.
    }
}

global function establishOrbitEasyMode {
    parameter nextMissionStep.

    if (missionStep = "establishOrbitEasyMode") {
        set secondsToManeuver to 20.
        print "Waiting for maneuver.".
        print "Estimated Time of Arrival: T- " 
            + (round(ship:orbit:ETA:apoapsis, 3) - secondsToManeuver) 
            + " s".

        // ETA is always positive and counting down
        wait until ship:orbit:ETA:apoapsis <= secondsToManeuver. 
        print "Burning at apoapsis: " + round(ship:orbit:apoapsis, 0) + " m".
        lock throttle to 1.
        print "Target apoapsis: " + (ship:body:atm:height * 1.1).

        // Kerbin @ 77 km
        wait until (ship:orbit:apoapsis >= ship:body:atm:height * 1.1).
        lock throttle to 0. 
        print "New Apoapsis: " + round(ship:orbit:apoapsis, 0) + " m".
        print "Estimated Time of Arrival: T- " 
            + (round(ship:orbit:ETA:apoapsis, 3) - secondsToManeuver) 
            + " s".

        wait until ship:orbit:ETA:apoapsis <= secondsToManeuver. 
        print "Raising perapsis.".
        lock throttle to 1.
        
        // Kerbin @ 73.5 km
        wait until (ship:orbit:periapsis >= ship:body:atm:height * 1.05).
        lock throttle to 0.
        print "New periapsis: " + round(ship:orbit:periapsis, 0) + " m".
        print "New apoapsis: " + round(ship:orbit:apoapsis, 0) + " m".
        print "Succesfully established orbit around:".
        print "'" + ship:body:name + "'".

        set missionStep to nextMissionStep.
    }
}

global function doReEntryEasyMode {
    parameter nextMissionStep.

    if (missionStep = "doReEntryEasyMode") {
        lock steering to retrograde.
        //deorbit to 35 km
        wait until vAng(ship:facing:vector, ship:srfRetrograde:vector) <= 0.3.
        wait 10.
        lock throttle to 1.
        
        wait until ship:orbit:periapsis <= (ship:body:atm:height * 0.50).

        wait 0.
        lock throttle to 0.
        doNextStage().

        //Parachutes ship:srfPrograde:vector
        wait until ship:altitude <= 10_000.
        doNextStage().

        //landing
        wait until ship:status = "LANDED" or "SPLASHED".
        print ship:status.

        set missionStep to nextMissionStep.
    }
}