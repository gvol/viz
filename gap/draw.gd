#############################################################################
##
## draw.gd           VIZ package  
##
## Drawing GAP objects graphically. 
##

DeclareGlobalFunction("VizMakeDoc");
DeclareGlobalFunction("VizLoadExtensions");

DeclareOperation("Draw",[IsObject,IsRecord]);
DeclareOperation("Splash",[IsObject,IsRecord]);

# this is handy for automata (and similar) drawings
INPUTSYMBOLS := ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
	     "A","B","C","D","E","F","G","H","I","J","K","L","M","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
#just the integers as a fallback
STATES := [1..999];
