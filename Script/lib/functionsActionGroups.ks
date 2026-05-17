// Boot: 361 Bytes
// functionsBoot: 1.418 Bytes


// functionsBasic: 5.237 Bytes -> 7016

// Mission touristsOrbitKerbin: 3.373 Bytes
// Mission assistanceMunLander: 2.463 Bytes


//Action Groups
//SET count TO 5.
//ON AG1 {
//  PRINT "You pressed '1', causing action group 1 to toggle.".
//  PRINT "Action group 1 is now " + AG1.
//  SET count TO count - 1.
//  PRINT "I will only pay attention " + count + " more times.".
//  if count > 0
//    RETURN true. // will keep the trigger alive.
//  else
//    RETURN false. // will let the trigger die.
//}

// error? round(timestamp(missionTime):clock, 2).


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

global function updateTerminalWindow {
//TODO 
//print "" at (0, row). -> override row
}