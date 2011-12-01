# this file contains methods for producing strings that contain dot format
# descriptions of various types of objects. 

# please keep the file alphabetized.


# Usage: a list of adjacencies of a directed graph (as pos. ints)
# For example, [[1,2],[3],[4,5,6], [], [], []] indicates that
# 1->1, 1->2, 2->3, 3->4, 3->5, 3->6. 

# Returns: a string. 

InstallGlobalFunction(DotDigraph, 
function(digraph)
  local str, str_i, i, j;

  str:="";

  Append(str,"digraph hgn{\n");
  Append(str,"node [shape=circle]\n");

  for i in [1..Length(digraph)] do
    str_i:=String(i);
    for j in [1..Length(digraph[i])] do 
      Append(str, Concatenation(str_i, " -> ", String(j) , "\n"));
    od;
  od;
  Append(str,"}\n");
  return str;
end);

# Usage: a list of adjacencies of a functional directed graph (as pos. ints). 
# For example, [1,2,3,3,4] indicates that 1->1, 2->2, 3->3, 4->3, 5->5. 

# Returns: a string. 

InstallGlobalFunction(DotFunctionalDigraph, 
function(digraph)
  local str, str_i, i;
  
  str:="";

  Append(str,"digraph hgn{\n");
  Append(str,"node [shape=circle]\n");

  for i in [1..Length(digraph)] do
    str_i:=String(i);
    Append(str, Concatenation(String(i), " -> ", String(digraph[i]), "\n"));
  od;
  Append(str, "}\n");
  return str;
end);


# Usage: a list of adjacencies of a graph (as pos. ints) or a Grape package
# graph object

# Returns: a string. 

InstallGlobalFunction(DotGraph,
function(g)
  local str, seen, j, i, k;

  if IsGraph(g) then 
    g:=g.adjacencies;
  fi;

  str:="";

  Append(str,  "graph {\n     node [shape=point]\n");
  seen:=List([1..Length(g)], x-> []);

  for i in [1..Length(g)] do 
    if g[i]=[] then 
      Append(str, Concatenation(String(i), "\n"));
    else
      j:=Difference(g[i], seen[i]);
      for k in j do
        Add(seen[k], i);
        Append(str, Concatenation(String(i), " -- ", String(k), "\n"));
      od;
    fi;
  od;

  Append(str, " }");
  return str;
end);

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

#EOF
