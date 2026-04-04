set stagePrelaunch to 6. // for reboot ability

// Stages
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

print "Mission: " + mission.

startCountdown(3, stagePrelaunch, "Liftoff").

liftoff("doGravityTurn"). 

doGravityTurn("establishOrbit").

establishOrbit("reEntry").

reEntry("Mission accomplished").


unlock steering.
print "***********".
print mission.