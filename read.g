
 ReadPackage("viz/gap/dot.gi");
ReadPackage("viz/gap/splash.gi");
ReadPackage("viz/gap/tikz.gi");

# permutations and permutation groups
#ReadPackage("Viz","/gap/drawgrp.g");

# transformations and transformation semigroups
#ReadPackage("Viz","/gap/drawts.g");

VizViewers := ["xpdf","evince", "okular", "gv"];

if First(VizViewers, v -> Filename(DirectoriesSystemPrograms(),v) <> fail)= fail then
    Info(InfoWarning,1,"No pdf viewer from the list ", VizViewers, " is installed, thus there will be no output of any image\n");
  fi;
  if Filename(DirectoriesSystemPrograms(),"dot") = fail and Filename(DirectoriesSystemPrograms(),"dot2tex") = fail then
    Info(InfoWarning,1,"As neither GraphViz ( www.graphviz.org ) nor dot2tex ( www.fauskes.net/code/dot2tex ) is instaled, no image will be produced");
  elif Filename(DirectoriesSystemPrograms(),"dot") = fail then
    Info(InfoWarning,1,"GraphViz ( http://www.graphviz.org ) is not installed. Latex will be used to produce images\n");
  fi;
  if Filename(DirectoriesSystemPrograms(),"dot2tex") = fail then
    Info(InfoWarning,1,"dot2tex is not instaled; graphviz will be used to produce images\n");
  fi;
