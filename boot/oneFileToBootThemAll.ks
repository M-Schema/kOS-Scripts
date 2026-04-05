copyPath("0:/lib/functionsBoot.ks", "1:/lib/functionsBoot.ks").
runOncePath("1:/lib/functionsBoot.ks").

clearscreen. 

wait until ship:unpacked.
openTerminal().

wait 0.
shipNameSelectingMission().

wait 0.
set secondsToShutdown to 60.
print "kOS terminal window shutdown in " + secondsToShutdown + " s".
wait secondsToShutdown.
closeTerminal().