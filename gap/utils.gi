


InstallGlobalFunction(VizMakeDoc,
function()
  MakeGAPDocDoc(Concatenation(PackageInfo("viz")[1]!.
   InstallationPath, "/doc"), "viz.xml", ["draw.xml", "config.xml"], "viz",     "MathJax");;
end);
