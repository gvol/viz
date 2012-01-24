# this file contains methods for producing strings that contain dot format
# descriptions of various types of objects. 

# please keep the file alphabetized.

# 

# Usage: a small semigroup with generators. 

# Returns: a string.

# Notes: this does not draw a meaningful picture if applied to a transformation
# semigroup. 

# MP's code 

InstallOtherMethod(DotCayleyGraph, "for a semigroup with generators",
[IsSemigroup and HasGeneratorsOfSemigroup],
        function(S)
  local Zip, colors, gens, gen_colors, edges, dotstring, edge, node;

    Zip := function(a,b)
      local res,i;
      res := [];
      for i in [1..Minimum(Length(a), Length(b))] do
        Add(res, [ a[i], b[i] ]);
      od;
      return res;
    end;

    colors := ["red", "green", "blue", "yellow", "lightblue", "grey", "black"];
    colors := Concatenation(colors,colors);
    gens := GeneratorsOfSemigroup(S);

    gen_colors := Zip(gens, colors);
    edges := Concatenation(List(gen_colors, y -> 
     List(S, x->[x,y[1],x*y[1],y[2]])));

    dotstring := "digraph CayleyGraph {\n";

    for edge in edges do
      dotstring := Concatenation(dotstring, "\"", String(edge[1]), "\"->\"",    
       String(edge[3]), "\" [label=\"", String(edge[2]), "\",color=\"", edge[4],
       "\"];\n");
    od;

    for node in S do
     dotstring := Concatenation(dotstring, "\"", String(node),
     "\" [shape=circle, style=filled, fillcolor=white];\n");
    od;

    dotstring := Concatenation(dotstring, "};\n");

    return dotstring;
  end);

###

# Usage: semigroup, list, action. For example, 
# DotSemigroupAction(s, Elements(s), OnRight);
# DotSemigroupAction(s, Combinations([1..4]), OnSets);
# DotSemigroupAction(s, [1..4], OnPoints);  

# try the above with a group!

# Returns: a string

# Notes: generalizes Draw for a transformation semigroup. 

# AN's code, hash tables should be removed from here. Edge labels don't work
# properly.

if not TestPackageAvailability("orb", "3.7")=fail then 
  InstallGlobalFunction(DotSemigroupAction, 
  function(s, list, act)
    local gens, str, ht, entries, label, edge, currentlabel, t, i;
    
    gens := GeneratorsOfSemigroup(s);
    str:="";
    Append(str, "digraph aut{\n");
    Append(str, "node [shape=circle]");
    Append(str, "edge [len=1.2]");
    ht:=HTCreate("1 -> 2");
    entries := [];

    for t in [1..Size(gens)] do
      label := Concatenation("", String(t));
      for i in [1..Length(list)] do
        if list[i] <> act(list[i], gens[t]) then
          edge := Concatenation("\"", StringPrint(list[i]), "\"",
          " -> \"", StringPrint(act(list[i],gens[t])), "\"");
          currentlabel :=  HTValue(ht, edge);
          if currentlabel = fail then
             HTAdd(ht,edge,label);
             Add(entries, edge);
          else
             HTUpdate(ht,edge,Concatenation(currentlabel,",",label));
          fi;
        fi;
      od;
    od;
    #nodenames 
    for edge in entries do
      Append(str,Concatenation(edge , "[label=\"", HTValue(ht,edge) , 
       "\"]\n"));
    od;
    Append(str,"}\n");
    return str;
  end);
fi;

#############################################################################

if TestPackageAvailability("citrus", "0.6") then 
  InstallGlobalFunction(DotDClass, 
  function(d)
    local str, h, l, j, x;
    
    if not IsGreensClassOfTransSemigp(d) or not IsGreensDClass(d) then 
      Error("the argument should be a D-class of a trans. semigroup.");
    fi;

    str:="";
    Append(str, "digraph  DClasses {\n");
    Append(str, "node [shape=plaintext]\n");

    Append(str, "1 [label=<\n<TABLE BORDER=\"0\" CELLBORDER=\"1\"");
    Append(str, " CELLPADDING=\"10\" CELLSPACING=\"0\">\n");

    for l in LClasses(d) do 
      Append(str, "<TR>");
      if not IsRegularLClass(l) then  
        for j in [1..NrRClasses(d)] do    
          Append(str, "<TD></TD>");
        od;
      else
        h:=HClasses(l);
        for x in h do
          if IsGroupHClass(x) then 
            Append(str, "<TD>*</TD>");
          else
            Append(str, "<TD></TD>");
          fi;
        od;
      fi;   
      Append(str, "</TR>\n");
    od;
    Append(str, "</TABLE>>];\n}");

    return str;
  end);
fi;

#############################################################################

if TestPackageAvailability("citrus", "0.6") then 
  InstallGlobalFunction(DotDClasses,
  function(arg)
    local s, opts, str, i, gp, h, rel, j, k, d, l, x;
   
    s:=arg[1]; 
    if Length(arg)>1 then 
      opts:=arg[2];
    else
      opts:=rec(maximal:=false, number:=true);
    fi;

    if not IsTransformationSemigroup(s) then 
      Error("the argument should be a trans. semigroup");
      return fail;
    fi;

    str:="";
    Append(str, "digraph  DClasses {\n");
    Append(str, "node [shape=plaintext]\n");
    Append(str, "edge [color=red,arrowhead=none]\n");
    i:=0;
    
    for d in DClasses(s) do 
      i:=i+1;
      Append(str, String(i));
      Append(str, " [shape=box style=dotted label=<\n<TABLE BORDER=\"0\" CELLBORDER=\"1\"");
      Append(str, " CELLPADDING=\"10\" CELLSPACING=\"0\"");
      Append(str, Concatenation(" PORT=\"", String(i), "\">\n"));
      
      if opts!.number then 
        Append(str, "<TR BORDER=\"0\"><TD COLSPAN=\"");
        Append(str, String(NrRClasses(d)));
        Append(str, "\" BORDER=\"0\" >");
        Append(str, String(i));
        Append(str, "</TD></TR>");
      fi;
      
      if opts!.maximal and IsRegularDClass(d) then 
         gp:=StructureDescription(GroupHClass(d));
      fi;
      
      for l in LClasses(d) do
        Append(str, "<TR>");
        if not IsRegularLClass(l) then
          for j in [1..NrRClasses(d)] do
            Append(str, "<TD CELLPADDING=\"10\"> </TD>"); 
          od;
        else
          h:=HClasses(l);
          for x in h do
            if IsGroupHClass(x) then
              if opts!.maximal then 
                Append(str, Concatenation("<TD BGCOLOR=\"grey\">", gp, "</TD>"));
              else
                Append(str, "<TD BGCOLOR=\"grey\">*</TD>");
              fi;
            else
              Append(str, "<TD></TD>");
            fi;
          od;
        fi;   
        Append(str, "</TR>\n");
      od;
      Append(str, "</TABLE>>];\n");
    od;
    
    rel:=PartialOrderOfDClasses(s);
    rel:=List([1..Length(rel)], x-> Filtered(rel[x], y-> not x=y));

    for i in [1..Length(rel)] do
      j:=Difference(rel[i], Union(rel{rel[i]})); i:=String(i);
      for k in j do
        k:=String(k);
        Append(str, Concatenation(i, " -> ", k, "\n"));
      od;
    od;

    Append(str, " }");

    return str;
  end);
fi;

# Usage: a list of adjacencies of a directed graph (as pos. ints)
# For example, [[1,2],[3],[4,5,6], [], [], []] indicates that
# 1->1, 1->2, 2->3, 3->4, 3->5, 3->6. 

# Returns: a string. 

# AN's code

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

# AN's code

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

# JDM's code

InstallGlobalFunction(DotGraph,
function(g)
  local str, seen, j, i, k;

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

# JDM's code

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
