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
  local   Zip,  gens,  len,  colors,  nc,  gen_colors,  edges,  dotstring,
          edge,  node;

    Zip := function(a,b)
      local res,i;
      res := [];
      for i in [1..Minimum(Length(a), Length(b))] do
        Add(res, [ a[i], b[i] ]);
      od;
      return res;
    end;

    gens := GeneratorsOfSemigroup(S);
    len := Length(gens);

    # the colors below have been chosen to be used without restrictions with the
    #LaTeX xcolor package (It is convenient when prodicing tikz code by using dot2tex)
    colors := ["red", "green", "blue", "cyan", "magenta", "yellow", "black",
               "gray", "white", "darkgray", "lightgray", "brown", "lime", "olive",
               "orange", "pink", "purple", "teal", "violet"];
    nc := Length(colors);
    #to reuse colors when the set of generators is large
    if len > nc then
      colors := List([1 .. len], i -> colors[(i mod nc) + 1]);
    fi;

    gen_colors := Zip(gens, colors);
    edges := Concatenation(List(gen_colors, y ->
                     List(S, x->[x,y[1],x*y[1],y[2]])));

    dotstring := "digraph CayleyGraph {\n";

    for edge in edges do
     Append(dotstring,Concatenation("\"", String(edge[1]), "\"->\"",
     String(edge[3]), "\" [label=\"", String(edge[2]), "\",color=\"", edge[4],
     "\"];\n"));
    od;

    for node in S do
      Append(dotstring,Concatenation( "\"", String(node),
       "\" [shape=circle, style=filled, fillcolor=white];\n"));
    od;

    Append(dotstring, "};\n");

    return dotstring;
  end);
  
  ########################################################################
  #Outputs a dot string for the (right) Cayley graph of a semigroup (or a monoid)
  # The input is a semigroup and a record with options (which may not be given)
  #Example: 
  #S := Semigroup(Transformation( [ 2, 3, 4, 1, 5 ] ), Transformation( [ 1, 2, 4, 5, 5 ] ));;
  #dotstring:= DotRightCayleyGraph(S,rec(edge_labels:="letters",node_labels:="numbers",highlight:=[[Idempotents,[],"blue"],[MultiplicativeNeutralElement,"box","red"]]));;
  #
  # The result can be viewed by executing: Splash(dotstring);
  #
  # Without options: Splash(DotRightCayleyGraph(S));
InstallGlobalFunction(DotRightCayleyGraph,
function(arg)
  local S, size, elts, opt, o, gens, len, highlight, triple, fs, nodes, 
        edge_labels, node_labels, p, Zip, gen_colors, edges, dotstring, edge, 
        node, i, edg;

  S := arg[1];
  size := Size(S);
  if size = 1 then
    Info(InfoViz,1,"The semigroup is trivial...");
    dotstring := "/*dot*/ \n digraph CayleyGraph {\n  0 };\n";
    return dotstring;
  fi;
  elts := Elements(S);

  if Length(arg) = 1 then
    opt := VizDefaultOptionsRecordForGraphs;   
  elif Length(arg) = 2 then
    o := arg[2];
    if not IsSubset(RecNames(VizDefaultOptionsRecordForGraphs),RecNames(o)) then
      Info(InfoViz,1,"The options ", Difference(RecNames(o),RecNames(VizDefaultOptionsRecordForGraphs))," have no effect.");
    fi;
    opt := ProcessVizOptionsForGraphs(arg[2]);
  fi;

  ####### process options that are specific to this function #######
  ## <highligth> options and some labeling options
  #
  
  gens := Generators(S); #monoid or semigroup generators according to whether S is a monoid or a semigroup.
  len := Length(gens);  
  #
  ## highlight
  #
#  Error("");
  if IsBound(opt.highlight)  and not (opt.highlight = false) then
    highlight := StructuralCopy(opt.highlight);
    for triple in highlight do
      # the sets of nodes to be highlighted which are given by functions are
      ## computed 
      if IsFunction(triple[1]) then
        fs := triple[1](S);
        if IsList(fs) then
          triple[1] := triple[1](S);
        else
          triple[1] := [triple[1](S)];
        fi;
      fi;
      triple[1] := List(triple[1], s -> Position(elts,s));
    od;
  else
    highlight := [];
  fi;
  nodes := TreatNodeData(size,highlight);

  ####### post-process options (labels) #######
  ####edge_labels
  # When "generators" is the value of the option edge_labels and the number
  ####of generators is large, this option must be post-processed inside the function 
  if opt.edge_labels = "generators" then
    if len > Length(VizDefaultAlphabet) then
      Info(InfoViz,2,"The number of generators is too large to use them as labels."); 
      Info(InfoViz,2,"numbers will be used instead.");
      edge_labels := [1..len];
    else 
      edge_labels := [gens];
    fi;
  elif opt.edge_labels = "letters" then
    if len > Length(VizDefaultAlphabet) then
      Info(InfoViz,2,"The number of generators is too large to use letters as labels."); 
      Info(InfoViz,2,"numbers will be used instead.");
      edge_labels := [1..len];
    else 
      edge_labels := VizDefaultAlphabet;
    fi;
  elif opt.edge_labels = "none" then
    edge_labels := [];
  elif opt.edge_labels = "numbers" then
    edge_labels := [1..len];
  else
    edge_labels := opt.edge_labels; # the user may give the labels
  fi;
  ####node_labels
  if opt.node_labels = "numbers" then
    node_labels := [1..size];
  elif opt.node_labels = "elements" then
    node_labels := elts;
  elif opt.node_labels = "none" then
    node_labels := [];
  elif IsList(opt.node_labels) and opt.node_labels[1][2] in S then
    # the user may give labels: a list of pairs of the form ["label",element]
    node_labels := [];
    for p in opt.node_labels do
      node_labels[Position(elts,p[2])] := p[1];
    od;
  else
    node_labels := [];
  fi;
  ####### end of process labels #######    

  ####### end of process options #######


  ## a local functions ##
  Zip := function(a,b)
    local res,i;
    res := [];
    for i in [1..Minimum(Length(a), Length(b))] do
      Add(res, [ a[i], b[i] ]);
    od;
    return res;
  end;

  ## end of local functions ##


  gen_colors := Zip(gens, opt.edge_colors);
  if edge_labels = [] or opt.caption <> false then
    edges := Concatenation(List(gen_colors, y -> 
                     List(S, x->[Position(elts,x),,
                             Position(elts,x*y[1]),y[2]])));
  else
    edges := Concatenation(List(gen_colors, y -> 
                     List(S, x->[Position(elts,x),
                               edge_labels[Position(gens,y[1])],
                             Position(elts,x*y[1]),y[2]])));
  fi;
  dotstring := "/*dot*/ \n digraph CayleyGraph {\n";
  if IsBound(opt.rankdir) then #by default, this attribut of dot is "TB"
    Append(dotstring,Concatenation("rankdir = ",opt.rankdir,";\n"));
  fi;
  for edge in edges do
    if not IsBound(edge[2]) then
      Append(dotstring,Concatenation(String(edge[1]), "->",    
              String(edge[3]), "[label=\"", "\", color=\"", edge[4],"\"];\n"));
    else
        Append(dotstring,Concatenation(String(edge[1]), "->",    
                String(edge[3]), "[label=\"", 
                String(edge[2]), "\", color=\"", edge[4],"\"];\n"));
    fi;
  od;
  #
  for node in nodes do
    if node_labels = [] or (not IsBound(node_labels[node[1]])) then
      Append(dotstring,Concatenation( String(node[1]), " [label=\"", "\",shape=\"",node[2], "\",style=filled, fillcolor=\"",node[3],"\"];\n"));
    elif IsString(node_labels[node[1]]) then
      Append(dotstring,Concatenation( String(node[1]), " [label=\"", node_labels[node[1]],"\",shape=\"",node[2], "\",style=filled, fillcolor=\"",node[3],"\"];\n"));
    else
      Append(dotstring,Concatenation( String(node[1]), " [label=\"", String(node_labels[node[1]]),"\",shape=\"",node[2], "\",style=filled, fillcolor=\"",node[3],"\"];\n"));
    fi;
  od;

          ######### caption....   there is still work to do ...     
#
  if not IsBound(opt.caption) then 
    for i in [1..len] do
      # append a node with label corresponding to the label of generator i
      # and a fictitious node
      
      # add an edge between both nodes (with [arrowhead=none]) and appropriate color
      
    od;
  fi;
  if opt.caption = "colors" then
    if edge_labels = [] then
      edg := gens;
    else
      edg := edge_labels;
    fi;
    Append(dotstring, "subgraph caption{\n");
    for i in [1..len] do
      Append(dotstring,Concatenation("capt",String(i), " [label = \"", String(edg[i]), "\", color=white];\n"));
    od;
    Append(dotstring,Concatenation("captextra [label = \"", "\", color=white];\n"));
    for i in [1..len-1] do
      Append(dotstring,Concatenation("capt",String(i), " -> ", "capt", String(i+1), " [color = \"", gen_colors[i][2], "\", arrowhead = none];\n"));
    od;
    Append(dotstring,Concatenation("capt",String(len), " -> ", "captextra [color = \"", gen_colors[len][2], "\", arrowhead = none];\n"));  
    Append(dotstring, "};\n");
  fi;
  Append(dotstring, "};\n");

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

if not TestPackageAvailability("citrus", "0.6") = fail then
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
      if not IsRegularClass(l) then
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

if not TestPackageAvailability("citrus", "0.6") = fail then
  InstallGlobalFunction(DotDClasses,
  function(arg)
    local s, opts, str, i, gp, h, rel, j, k, d, l, x;

    s:=arg[1];
    if Length(arg)>1 then
      opts:=arg[2];
    else
      opts:=rec(maximal:=false, number:=true);
    fi;

    if not (IsTransformationSemigroup(s) or IsPartialPermSemigroup(s)) then 
      Error("the argument should be a semigroup of transformations or partial perms");
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
        if not IsRegularClass(l) then
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
