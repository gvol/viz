
ReadPackage("viz","config");

ReadPackage("viz/gap/dot.gd");
ReadPackage("viz/gap/options.gd");
ReadPackage("viz/gap/tikz.gd");
ReadPackage("viz/gap/splash.gd");

if not TestPackageAvailability("smallsemi", "0.6.4")=fail then 
  LoadPackage("smallsemi");
fi;

DeclareInfoClass("InfoViz");
