set mission to "touristsOrbitKerbin".

// ***********
copyPath("0:/lib/functionsBoot.ks", "1:/lib/functionsBoot.ks").
runOncePath("1:/lib/functionsBoot.ks").

clearscreen. 

wait until ship:unpacked.
openTerminal().
sas off.

print "The ship " + ship:name + " is ready.".
print "Body: " + ship:body:name.
print "Altitude above sea level: " + ship:altitude + " m".

wait 0.
runMission(mission).

wait 0.
print "Shutdown".

wait 60.
closeTerminal().