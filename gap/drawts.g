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

####TRANSFORMATION####################################################################
InstallMethod(Draw,
"for transformations",
[IsTransformation, IsRecord],
function(t,params)
local dgraph,i;
  #just creating a simple directed graph representation
  dgraph := [];
  for i in [1..DegreeOfTransformation(t)] do
    Add(dgraph, [i,i^t]);
  od; 
  return VIZ_drawDirectedGraph(params.filename,dgraph);  
end
);


####TRANSFORMATION SEMIGROUP##########################################################
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
