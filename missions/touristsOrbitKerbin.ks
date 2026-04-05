set stagePrelaunch to 7.

// Stages
// [7: decoupling Computer from Vessel] - won't be executed
// 6: Prelaunch
// 5: Booster with TWR of 1.3 
// 4: Start stabilisation
// 3: LV
// 2: decoupling Booster
// 1: decoupling LV
// 0: Parachutes

// Missionsziele: 
// I) Touristen suborbital ins All schießen;
// II) einen Orbit um Kerbin etablieren;
// III) Deorbit auf Kerbin;
// IV) sichere Landung mit Fallschirmen;

//TODO 
//ETA apo
//calcCurrentMissionStep


importLib("calcLaunch").
importLib("calcOrbit").

lock stageNumber to ship:stageNum.

sas off.
print "The ship '" + ship:name + "' is ready.".
print "Body: " + ship:body:name.
print "Altitude above sea level: " + round(ship:altitude, 0) + " m".

startCountdown(3, stagePrelaunch, "Liftoff").

liftoff("doGravityTurn"). 

doGravityTurn("establishOrbit").

establishOrbit("reEntry").

reEntry("Mission accomplished").


unlock steering.
print "***********".
print "'" + ship:name + "'. Time in mission: " 
    + round(timestamp(missionTime):clock, 2) + " s".