InstallGlobalFunction(Dot,
function(s, file)
local d, i, j, k, gens;
  d:=PartialOrderOfDClasses(s);
  d:=List([1..Length(d)], x-> Filtered(d[x], y-> not x=y));
  gens:=List(Generators(s), x-> 
   PositionProperty(GreensDClasses(s), y-> x in y));

  if NrGreensDClasses(s)<40 then 
    PrintTo(file,  "graph graphname {\n     node [shape=circle]\n");
  else
    PrintTo(file,  "graph graphname {\n     node [shape=point]\n");
  fi;

  for i in [1..Length(d)] do 
    j:=Difference(d[i], Union(d{d[i]}));
    for k in j do
      if i in gens then 
        i:=Concatenation("\"", String(i), "*", "\""); 
      else 
        i:=String(i); 
      fi;
      if k in gens then 
        k:=Concatenation("\"", String(k), "*", "\""); 
      else 
        k:=String(k); 
      fi;

      AppendTo(file, Concatenation(i, " -- ", k, "\n"));
    od;
  od;

  AppendTo(file, " }");

  return true;
end);

InstallGlobalFunction(Neato,
function(g, file)
local i, j, k, seen;
  if IsBound(GAPInfo.PackagesInfo.grape) and IsGraph(g) then 
    g:=g.adjacencies;
  fi;

  PrintTo(file,  "graph {\n     node [shape=point]\n");
  seen:=List([1..Length(g)], x-> []);

  for i in [1..Length(g)] do 
    j:=Difference(g[i], seen[i]);
    for k in j do
      Add(seen[k], i);
      AppendTo(file, Concatenation(String(i), " -- ", String(k), "\n"));
    od;
  od;

  AppendTo(file, " }");
  Exec("neato -x -Tpdf ", file, "> ", Concatenation(SplitString(file, ".")[1],
  ".pdf"));
  return true;
end;

#neato -x -Tpdf 7_825.dot > 7_825.pdf
# makes the picture much nicer!

#dot -Tjpg cube3.dot > cube3.jpg
