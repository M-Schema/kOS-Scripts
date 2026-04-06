// kOS mission No. 2

importLib("functionsBasic").

print "The ship '" + ship:name + "' is ready.".
print "Body: " + ship:body:name.
print "Altitude above sea level: " + round(ship:altitude, 0) + " m".

//stages 
if (ship:status = "PRELAUNCH" and ship:stageNum = 10) {
    startCountdown(3).

    doNextStage().
} 

if (ship:stageNum = 9) {
    print "Ignition!". // solid booster w/ TWR 1.3 at sea level -> Limit @ 79.5 % 
    sas off.
    lock steering to heading(90, 90). // roll

    doNextStage(). // start stabilisation
}

if (ship:stageNum = 8) {
    print "Liftoff!".
    lock throttle to (15 / 15).
    doNextStage(). // liquid fuel engines
}

if (ship:stageNum = 7) {
    lock throttle to (0 / 15). 

    when (stage:resourceslex["SolidFuel"]:amount < 0.01) then {
        lock throttle to (15 / 15).
        doNextStage().
    }

    //Kerbin @ 35 km & 77 km
    doGravityTurnEast((ship:body:atm:height * 0.5), 
                    (ship:body:atm:height * 1.1)).
    print "End gravity turn.".
}

if (ship:stageNum = 6) {

    // maneuver at apoapsis
    setHohmannTransferOrbitalManeuver(ship:orbit:apoapsis, 
                                    ship:body:atm:height * 1.1).

    when ((stage:deltaV:current < 0.01)) then {
        doNextStage().
    }

    doManeuver().
}

if (ship:stageNum = 5) {
    print "Ship status: " + ship:status.
    print "in space!".



}

if (ship:stageNum = 4) {
    // -- mun landing -- // Mk-55 Bumms
    //RCS on.
    if RCS print "RCS is on.".

    //LIGHTS on.
    if LIGHTS print "Lights are on.".

    //GEAR on.
    if GEAR print "Deploys landing gear".

    //LADDERS on.

}

if (ship:stageNum = 3) {
    // -- mun launch & return -- // LV-909 Terrier
    RCS off.


    // reentry

}

if (ship:stageNum = 2) {
    // decoupling last engine

}

if (ship:stageNum = 1) {
    print "Waiting for parachutes".

    when (not CHUTESSAFE) then {
        CHUTESSAFE on.
        return (not CHUTES).
    }

    wait until ship:altitude <= 10_000. //safety
    CHUTES on.
}

if (ship:stageNum >= 0) { 
    print "Waiting for touchdown.".

    wait until ship:status = "LANDED" or "SPLASHED".
    print ship:status.
    // Last staging, decoupling heat shield, won't be used on this ship.
} else {
    print "ERROR: stage number not found".
}

lock throttle to 0.

unlock steering.
print "***********".