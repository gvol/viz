#############################################################################
##
## drawts.g           VIZ package  
##
## Basic drawing for transformations and transformation semigroups
##

#graphvizing a directed graph i.e. a list of pairs (needed for drawing transformations)
VIZ_drawDirectedGraph := function(filename, graph)
local vertex;

  filename := Concatenation(filename,".dot");  
  PrintTo(filename,"digraph hgn{\n");
  AppendTo(filename,"node [shape=circle]\n");

  #nodenames are created like n_#1_#2_...._#n  
  for vertex in graph do
    AppendTo(filename,Concatenation(StringPrint(vertex[1]), " -> " , StringPrint(vertex[2]) , "\n"));
  od; 
  
  AppendTo(filename,"}\n");
  return filename;
end;

VIZ_drawFunctionalDigraph := function(t,params)
local dgraph,i;
  #just creating a simple directed graph representation
  dgraph := [];
  for i in [1..DegreeOfTransformation(t)] do
    Add(dgraph, [i,i^t]);
  od; 
  return VIZ_drawDirectedGraph(params.filename,dgraph);  
end;

VIZ_drawMatrixDiagramForTransformations := function(t,params)
local filename, l,i;
  l := t![1];
  filename := Concatenation(params.filename,".tex");
  PrintTo(filename,"\\documentclass{minimal}\n\\usepackage{tikz}\n\\usetikzlibrary{automata,arrows,matrix,positioning}\n\\thispagestyle{empty}\n\\begin{document}\n\\tikzset{auto}\n\\begin{tikzpicture}\n\\tikzstyle{every state}=[minimum size=1pt,fill=black]\n");
  AppendTo(filename,"\\node[state] (t1) {};\n");
  for i in [2..Length(l)] do
    AppendTo(filename,"\\node[state] (t",StringPrint(i),") [right of=t",StringPrint(i-1),"] {}\n;");
  od;
  AppendTo(filename,"\\node[state] (d1) [below of=t1]{};\n");
  for i in [2..Length(l)] do
    AppendTo(filename,"\\node[state] (d",StringPrint(i),") [right of=d",StringPrint(i-1),"] {}\n;");
  od;
  for i in [1..Length(l)] do
    AppendTo(filename,"\\path (t",StringPrint(i),") edge (d",StringPrint(i^t),")\n;");
  od;

  AppendTo(filename,"\\end{tikzpicture}\n\\end{document}");  
  return filename;
end;

####TRANSFORMATION####################################################################
InstallMethod(Draw,
"for transformations",
[IsTransformation, IsRecord],
function(t,params)
  if VIZ_ExistsFieldInRecord(params, "mode") and params.mode="matrix" then
    return VIZ_drawMatrixDiagramForTransformations(t,params);
  else 
    return VIZ_drawFunctionalDigraph(t,params);
  fi;
end
);


####TRANSFORMATION SEMIGROUP##########################################################
# simple Cayley graph for a transformation semigroup
#accepted parameters "symbols" "states" 
InstallMethod(Draw,
"for transformation semigroups",
[IsTransformationSemigroup, IsRecord],
function(ts,params)
local t, n, i,label,filename,gens,edge,ht,currentlabel,entries, inputsymbols, states;

  if VIZ_ExistsFieldInRecord(params, "symbols") then
    inputsymbols := params.symbols;
  else
    inputsymbols := INPUTSYMBOLS;
  fi;

  if VIZ_ExistsFieldInRecord(params, "states") then
    states := params.states;
  else
    states := STATES;
  fi;

  gens := GeneratorsOfSemigroup(ts);
  n := DegreeOfTransformation(Representative(gens));
  filename := Concatenation(params.filename,".dot");  
  PrintTo(filename,"digraph aut{\n");
  AppendTo(filename,"node [shape=circle]");
  AppendTo(filename,"edge [len=1.2]");

  ht := HTCreate("1 -> 2");
  entries := [];
  for t in [1..Size(gens)] do    
    label := Concatenation("", inputsymbols[t]);
    for i in [1..n] do
      if i <> i^(gens[t]) then
        edge := Concatenation(StringPrint(states[i]), " -> " , StringPrint(states[i^(gens[t])]));
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
        AppendTo(filename,Concatenation(edge , "[label=\"", HTValue(ht,edge) , "\"]\n"));
  od; 
  AppendTo(filename,"}\n");
  return filename;
end
);

