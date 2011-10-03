#############################################################################
##
## draw.gi           SgpDec package  
##
## (C)  Attila Egri-Nagy, Chrystopher L. Nehaniv
##
## Current drawing implementation using GraphViz.  
##

# returning true in case the name denotes a valid member of the record
VIZ_ExistsFieldInRecord :=function(record, name)
    return name in RecNames(record);
end;


# splash - immediate display
InstallOtherMethod(Splash,
"with no parameters",
[IsObject],
function(object)
    Splash(object, rec()); #just include an empty parameter record    
end
);


# splash - immediate display
InstallMethod(Splash,
"with parameters",
[IsObject,IsRecord],
function(object, params)
local dotname, pdfname;
  #if the filename is  not given we generate a random when 
  if not VIZ_ExistsFieldInRecord(params,"filename") then 
      params.filename := Filename(DirectoryTemporary(), "splash");
  fi;
  #if title is not given then simply "splash" is used
  if not VIZ_ExistsFieldInRecord(params,"title") then 
      params.title := "splash";
  fi;

  # the actual work is done by calling a Draw method
  Draw(object,params);
  dotname := Concatenation(params.filename, ".dot");
  pdfname := Concatenation(params.filename, ".pdf");
  Exec("dot -Tpdf ",dotname, " > ", pdfname); #calling graphviz, this works only on UNIX machines
  Exec(PDF_VIEWER, pdfname, " & ");                   
end
);

#graphvizing a directed graph i.e. a list of pairs
# TODO this must go into the Draw framework - after the graph representation is fixed
drawDirectedGraph := function(filename, graph)
local vertex;

  filename := Concatenation(filename,".dot");  
  PrintTo(filename,"digraph hgn{\n");
  AppendTo(filename,"node [shape=circle]\n");

  #nodenames are created like n_#1_#2_...._#n  
  for vertex in graph do
    AppendTo(filename,Concatenation(StringPrint(vertex[1]), " -> " , StringPrint(vertex[2]) , "\n"));
  od; 
  
  AppendTo(filename,"}\n");
end;

####TRANSFORMATIONS##################################################################
InstallMethod(Draw,
"for transformations",
[IsTransformation, IsRecord],
function(t,params)
local dgraph,i;
  dgraph := [];
  for i in [1..DegreeOfTransformation(t)] do
    Add(dgraph, [i,i^t]);
  od; 
  drawDirectedGraph(params.filename,dgraph);
end
);

###THE RECORD DISPATCHER#############################################################
#the idea is the match the record names as a footprint of a data structure
InstallMethod(Draw,
"for things represented as records",
[IsRecord, IsRecord],
function(record,params)
local recnames;
  recnames := RecNames(record);
  if AsSet(recnames) = AsSet([ "depth", "elems", "height", "rep" ]) then
    
    #_skeletonDrawClassAction(params.skeleton, record, params);
  else
    Print("Nothing drawable here!\n");
  fi;
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
end
);
