// Missionsziele: 
// I) Touristen suborbital ins All schießen;
// II) einen Orbit um Kerbin etablieren;
// III) Deorbit auf Kerbin;
// IV) sichere Landung mit Fallschirmen;

//kopiert Datei vom Archiv ins Schiff
copyPath("0:/lib/calcLaunch.ks", "1:/lib/calcLaunch.ks").
copyPath("0:/lib/calcOrbit.ks", "1:/lib/calcOrbit.ks").

//import
runOncePath("1:/lib/calcLaunch.ks").
runOncePath("1:/lib/calcOrbit.ks").

//OuterSpace Boundary Kerbin @ 70 km

//deOrbit to 35 km


// TWR of 1.3 

//returnSensors().
startCountdown(10).

set boosterThrust to ship:thrust.
when ship:availableThrust < (boosterThrust -10) then {
    wait until stage:ready.
    stage.
    print "Stage".
    set boosterThrust to ship:thrust.
    wait 0.
    if stage:number > 0 {preserve.}
}    

liftoff().
doGravityTurn().
print "turn Ende".

when ship:altitude >= 25_000 or (ship:body:atm:height * 0.50) then { //Kerbin @ 35 km
    print ship:body:atm:height. 
    lock steering to prograde.
        
    lock throttle to 1.
    doNextStage().
    print "15/15".
}

when ship:orbit:apoapsis >= 70_000 and (ship:body:atm:height * 1.15) then { //Kerbin @ 80,5 km
    print "6". lock throttle to 0. 
    wait 0.
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0. //safety
}

unlock steering.
