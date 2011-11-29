

ReadPackage("viz","config");

ReadPackage("viz/gap/dot.gd");
ReadPackage("viz","/gap/draw.gd");

if not IsBound(IsGraph) then 
  IsGraph:=ReturnFalse;
fi;

