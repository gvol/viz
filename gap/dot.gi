


# Usage: poset[i] should be a list containing the maximal elements less than i.

# Returns: a string.

InstallGlobalFunction(DotPoset,
function(poset)
  local rel, str, j, i, k;

  rel:=List([1..Length(poset)], x-> Filtered(poset[x], y-> not x=y));
  str:="";

  if Length(poset)<40 then 
    Append(str,  "graph graphname {\n     node [shape=circle]\n");
  else
    Append(str,  "graph graphname {\n     node [shape=point]\n");
  fi;

  for i in [1..Length(rel)] do 
    j:=Difference(rel[i], Union(rel{rel[i]})); i:=String(i);
    for k in j do
      k:=String(k); 
      Append(str, Concatenation(i, " -- ", k, "\n"));
    od;
  od;

  Append(str, " }");

  return str;
end);

InstallGlobalFunction(NeatoGraph,
function(g, file)
local i, j, k, seen;
  if IsBound(GAPInfo.PackagesInfo.grape) and IsBound(IsGraph) and IsGraph(g) 
   then 
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
end);

#neato -x -Tpdf 7_825.dot > 7_825.pdf
# makes the picture much nicer!

#dot -Tjpg cube3.dot > cube3.jpg
