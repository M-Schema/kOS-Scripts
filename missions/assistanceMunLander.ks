// kOS mission No. 2

// upgrade disc space up to 20_000

importLib("functionsLaunch").
importLib("functionsOrbit").


print "The ship '" + ship:name + "' is ready.".
print "Body: " + ship:body:name.
print "Altitude above sea level: " + round(ship:altitude, 0) + " m".
print "Ship stage number: " + ship:stageNum.

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

    //Kerbin @ 35 km & 80.5 km
    doGravityTurnEast((ship:body:atm:height * 0.5), 
                    (ship:body:atm:height * 1.15)).
    print "End gravity turn.".
}

if (ship:stageNum = 6) {

    // maneuver calculation can't handle two stages at once, yet,
    // so burning the current down with ~250 m/s
    lock steering to heading(90, -20, 0).
    wait until vectorAngle(ship:facing:vector, heading(90, -20, 0):vector) <= 0.3.
    print "Heading east.".
    lock throttle to 1.
    when ((stage:deltaV:current < 0.01)) then {
        lock throttle to 0.
        doNextStage().
    }

    print "Waiting for Kerbin @ " 
        + (ship:body:atm:height * 0.75) + " km".
    wait until (ship:altitude >= ship:body:atm:height * 0.75).
 
    // maneuver at apoapsis
    setHohmannTransferOrbitalManeuver(ship:orbit:apoapsis, 
                                    (ship:orbit:apoapsis)).
    doManeuver().
}

if (ship:stageNum = 5) {
    print "Ship status: " + ship:status.

    if (ship:orbit:periapsis >= ship:body:atm:height) {
        print "... in space!".
        print " ".
        print "Mun 'orbit insertion maneuver'".
        print "... isn't implemented, yet.".
        print " ".
        print "Your instructions: ".
        print "Please do it yourself.".
        print "Then stage by hand with the spacebar.".

    } else print "something went wrong. Please check!".

    lock throttle to 0.
    unlock throttle.
    unlock steering.
    SAS on.

    wait until (ship:stageNum = 4).
    print "kOS taking over again.".
    SAS off.
}

if (ship:stageNum = 4) {
    // TODO
    
    // -- mun landing -- // Mk-55 Bumms

// orbit mun

    //RCS on.
    if RCS print "RCS is on.".

    //LIGHTS on.
    if LIGHTS print "Lights are on.".

    //GEAR on.
    if GEAR print "Deploys landing gear".

    //LADDERS on.

    // MUN-Stein: Biome Canyons, Hochland oder Zwillingskrater


    wait until ship:status = "LANDED".
    print ship:status.

}

if (ship:stageNum = 3) {
    // -- mun launch & return -- // LV-909 Terrier
    RCS off.


    // reentry

}

if (ship:stageNum = 2) {
    lock steering to retrograde.
    //deorbit to 35 km
    wait until vAng(ship:facing:vector, ship:srfRetrograde:vector) <= 0.3.
    wait 10.
    lock throttle to 1.
    
    wait until ship:orbit:periapsis <= (ship:body:atm:height * 0.50).

    wait 0.
    lock throttle to 0.
    doNextStage(). // decoupling last engine

}

if (ship:stageNum = 1) {
    print "Waiting for parachutes".

    when (not CHUTESSAFE) then {
        CHUTESSAFE on.
        return (not CHUTES).
    }

    wait until ship:altitude <= 10_000. //safety
    CHUTES on.

    //Parachutes ship:srfPrograde:vector




    //wait until ship:altitude <= 10_000.
    //doNextStage().

    wait until ship:status = "LANDED" or "SPLASHED".
    print ship:status.
}

if (ship:stageNum = (1 or 0)) { 
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