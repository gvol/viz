InstallGlobalFunction(VizMakeDoc,
function()
  MakeGAPDocDoc(Concatenation(PackageInfo("viz")[1]!.
          InstallationPath, "/doc"), "viz.xml",
          ["draw.xml", "config.xml"], "viz",     "MathJax");;
end);

#returns a string of the elements of the list 
#separated by commas, taking care of the last comma
InstallGlobalFunction(List2CommaSeparatedString,
function(l)
local str,i,out;  
  if IsEmpty(l) then return ""; fi;
  str := "";
  out := OutputTextString(str,true);  

  for i in [1..Length(l)-1] do
    AppendTo(out,l[i]);
    AppendTo(out,",");
  od;
  AppendTo(out,l[Length(l)]);

  CloseStream(out);
  return str;
end);  