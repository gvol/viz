ReadPackage("viz/gap/dot.gi");
ReadPackage("viz/gap/options.gi");
ReadPackage("viz/gap/splash.gi");
ReadPackage("viz/gap/tikz.gi");

# permutations and permutation groups
#ReadPackage("Viz","/gap/drawgrp.g");

# transformations and transformation semigroups
#ReadPackage("Viz","/gap/drawts.g");

######## The treatment of the viewers must be done in another way...
#VizViewers := ["xpdf","evince", "okular", "gv"];
    if ARCH_IS_UNIX( ) then
      VizViewers := ["xpdf","xdg-open","evince", "okular", "gv"];
    elif ARCH_IS_WINDOWS( ) then
      VizViewers := ["xpdf","evince", "okular", "gv"];
    elif ARCH_IS_MAC_OS_X( ) then
      VizViewers := ["xpdf","open","evince", "okular", "gv"];
    fi;

if First(VizViewers, v -> Filename(DirectoriesSystemPrograms(),v) <> fail)= fail then
    Info(InfoWarning,1,"No pdf viewer from the list ", VizViewers, " is installed, thus there will be no output of any image\n");
  fi;
  if Filename(DirectoriesSystemPrograms(),"dot") = fail and Filename(DirectoriesSystemPrograms(),"dot2tex") = fail then
    Info(InfoWarning,1,"As neither GraphViz ( www.graphviz.org ) nor dot2tex ( www.fauskes.net/code/dot2tex ) is installed, no image will be produced");
  elif Filename(DirectoriesSystemPrograms(),"dot") = fail then
    Info(InfoWarning,1,"GraphViz ( http://www.graphviz.org ) is not installed. Latex will be used to produce images\n");
  fi;
  if Filename(DirectoriesSystemPrograms(),"dot2tex") = fail then
    Info(InfoWarning,1,"dot2tex is not installed; graphviz will be used to produce images\n");
  fi;
