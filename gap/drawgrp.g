#############################################################################
##
## drawts.g           VIZ package  
##
## Basic drawing for permutations and permutation groups
## (just converting permutations to transformations)

# figuring out the set on which permutation group generators act on (i.e. looking for the maximal moved point) ??? Could it return smaller state set, when it is the identity on the largest point???
SetOfPermutationGroupToActOn := function(G)
local max,i;
  max := 0;
  for i in GeneratorsOfGroup(G) do
    if LargestMovedPoint(i) > max then max := LargestMovedPoint(i); fi;
  od;
  return [1..max];
end; 




####TRANSFORMATION####################################################################
InstallMethod(Draw,"for permutations",[IsPerm, IsRecord],
function(p,params)
    return Draw(Transformation(ListPerm(p)), params);    
end
);


####PERMUTATION GROUP##########################################################
# simple Cayley graph for a transformation semigroup
#accepted parameters "symbols" "states" 
InstallMethod(Draw,
"for permutation groups",
[IsPermGroup, IsRecord],
        function(G,params)
    local n;
    n := Size(SetOfPermutationGroupToActOn(G));    
    return Draw(Semigroup(List(GeneratorsOfGroup(G) ,x->Transformation(ListPerm(x, n)))), params);    
end    
);

