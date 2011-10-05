LoadPackage("smallsemi");


pair := function(x,y) return( [x,y] ); end;;

Zip := function(a,b)
    local res;
    if IsList(a) and IsList(b) then
        res := [];
        for i in [1..Minimum(Length(a), Length(b))] do
            Add(res, [ a[i], b[i] ]);
        od; 
        return(res);
    else
    fi;
end;


CayleyAutomatonDotString := function(S)
    local dotstring, gens, gen_colors, edges, edge, node, colors;

    colors := ["red", "green", "blue", "yellow", "lightblue", "grey", "black"];
    colors := Concatenation(colors,colors);
    gens := GeneratorsOfSemigroup(S);

    gen_colors := Zip(gens, colors);
    edges := Concatenation(List(gen_colors, y -> List(S, x->[x,y[1],x*y[1],y[2]])));

    dotstring := "digraph CayleyGraph {\n";
    
    for edge in edges do
        dotstring := Concatenation(dotstring, "\"", String(edge[1]), "\"->\"", String(edge[3]), "\" [label=\"", String(edge[2]), "\",color=\"", edge[4],"\"];\n");
    od;

    for node in S do
        dotstring := Concatenation(dotstring, "\"", String(node),"\" [shape=circle, style=filled, fillcolor=white];\n");
    od;

    dotstring := Concatenation(dotstring, "};\n");
    
    return dotstring;
end;


AllSmallCayleyGraphs := function(n, path)
    local gens, semi, semi2, Ca, id;

    for semi in AllSmallSemigroups(n) do
        gens := MinimalGeneratingSet(semi);
        semi2 := SemigroupByGenerators(gens);
        Size(semi2);
        Ca := CayleyAutomatonDotString(semi2);
        id := IdSmallSemigroup(semi2);
        Exec(Concatenation("mkdir -p ",path,"/",String(n),"/",String(id[2])));
        PrintTo(Concatenation(path, "/", String(n), "/", String(id[2]), "/cayley.dot"), Ca);
    od;
end;



