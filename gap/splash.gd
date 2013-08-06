#########################################################################
# The input is one or two lists of colors (strings representing colors)
# When the second list is not present, ColorsForViz is taken
# The output is the duplicates free concatenation of both lists.
# (Frequently the output is just a reordering of ColorsForViz.)
DeclareGlobalFunction("ReorderColorsForViz");
  
#########################################################################
# The input is a list of colors and an integer <n>
# The output is a list of length <n> where the list of colors is repeated 
DeclareGlobalFunction("ReuseVizColors");
  
#takes a string, tries to figure out whether it is Tikz or Dot
#and processes accordingly and display
#DeclareGlobalFunction("Splash");

# the input is 
# * a record of options (may not be present) and
# * a string (dot) or a function that applied to the ramaining argument produces a dot string
# processes and displays
DeclareGlobalFunction("Splash");

#########################################################################
# To draw a graph we need to specify:
# * the label, the shape and the color to fill each node
# * the label and the color of an edge.
##
# In the next functions (designed to be of general use) the labels are assumed
# to be the ranges of the first positive integers. Different labels may have to
# be treated for each particular case.
#########################################################################
# The input is an integer, the number of nodes, and a list <list> giving 
#partial information on the shape and/or color of some nodes.
#
#Each sublist in <list> is a triple of the form [[nodes],shape,color] 
#
# Note that this function is mainly used when the option "highlight" occurs   
DeclareGlobalFunction("TreatNodeData");


############GLOBAL VARIABLES #####################
##TODO(?): It should be given the user the chance of changing permanently the order
#of the colors and the default shape
#
#The variables ColorsForViz and NodeShapesForViz can be used to pick admissible
#colors, fill color, shapes and alphabet
#########################################################################
# the colors below have been chosen to be used without restrictions with the 
#LaTeX xcolor package (It is convenient when producing tikz code by using dot2tex)
#they are used as default colors
##
BindGlobal( "ColorsForViz", ["red", "green", "blue", "cyan", "magenta", 
          "yellow", "black", "gray", "white", "darkgray", "lightgray", "brown", 
          "lime", "olive", "orange", "pink", "purple", "teal", "violet"] );
#########################################################################
# the admissible edge labels 
# Note: other edge labels can be given through a list
BindGlobal("EdgeLabelsForViz", ["none","numbers","letters"]);
#########################################################################
# an extended list of admissible edge labels (useful for Cayley graphs)
BindGlobal("EdgeLabelsForVizExtended", Concatenation(EdgeLabelsForViz,
        ["generators"]));
#########################################################################
# the admissible node labels
# Note: other edge labels can be given through a list
BindGlobal("NodeLabelsForViz", ["none","numbers"]);
#########################################################################
# an extended list of admissible node labels (useful for Cayley graphs)
BindGlobal("NodeLabelsForVizExtended", Concatenation(NodeLabelsForViz,
        ["elements"]));

#########################################################################
# the edge shapes below are pre-defined (graphviz)
BindGlobal("EdgeShapesForViz",["vee", "normal", "box", "lbox", "rbox", "obox",
        "olbox", "orbox", "crow", "lcrow", "rcrow", "diamond", "ldiamond", 
        "rdiamond", "odiamond", "oldiamond", "ordiamond", "dot", "odot","inv", 
        "linv", "rinv", "oinv", "olinv", "orinv", "none", "lnormal", "rnormal", 
        "onormal", "olnormal", "ornormal", "tee", "ltee", "rtee2", "lvee", "rvee"]); 
#########################################################################
# the node polygon-based shapes below are pre-defined (graphviz)
# the "less natural" ones have been placed at the end
BindGlobal("NodeShapesForViz",["circle", "oval", "ellipse", "box", "polygon",
        "egg", "triangle", "diamond", "trapezium", "rect", "rectangle", "square", 
        "parallelogram", "house", "pentagon", "hexagon", "septagon", "octagon",
        "invtriangle", "invtrapezium", "invhouse", "Mdiamond", "Msquare", 
        "Mcircle", "note", "tab", "folder", "box3d", "component", "doublecircle", 
        "doubleoctagon", "tripleoctagon", "plaintext"]);

#########################################################################
# options that can be used for graphs
BindGlobal("VizOptionsForGraphs",["edge_colors","edge_labels","nodes_fillcolors",
        "node_labels", "caption"]);
#########################################################################
# extended list of options that can be used for graphs
BindGlobal("VizOptionsForGraphsExtended",Concatenation(VizOptionsForGraphs, 
        ["highlight"]));
#########################################################################
######## Default Values #############
#########################################################################
# the default alphabet
BindGlobal("VizDefaultAlphabet",["a","b","c","d","e","f","g","h","i","j", 
        "k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
        "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P",
        "Q","R","S","T","U","V","W","X","Y","Z"]); 
#########################################################################
# the default edge label
BindGlobal("VizDefaultEdgeLabels","numbers");
#########################################################################
# the default node label
BindGlobal("VizDefaultNodeLabels","numbers");
#########################################################################
# the default node label
BindGlobal("VizDefaultNodesShape","circle");

#########################################################################
#### Default values for individual edges or nodes #####
#########################################################################
# the default shapes for nodes and arrows
BindGlobal("VizDefaultEdgeShape","normal");
BindGlobal("VizDefaultNodeShape","circle");
#########################################################################
# the default fill color
BindGlobal("VizDefaultNodeFillColor","white");
##########################################################################

#########################################################################
# This function is used next...
InstallGlobalFunction(ReorderColorsForViz, 
function(arg)
  if Length(arg) = 1 then
    return DuplicateFreeList(Concatenation(arg[1],ColorsForViz));
  else
    return DuplicateFreeList(Concatenation(arg[1],arg[2]));
  fi;
end);

########################################################################
# a record containing the default values
BindGlobal("VizDefaultOptionsRecordForGraphs",rec(
        edge_colors := ColorsForViz,
        edge_labels := VizDefaultEdgeLabels,
        nodes_fillcolors := ReorderColorsForViz([VizDefaultNodeFillColor], 
                Reversed(ColorsForViz)),
        node_labels := VizDefaultNodeLabels,
        nodes_shape := VizDefaultNodesShape,
        rankdir := "LR",           
        caption := false,
        highlight := false));
########################################################################
# a record containing the default values
BindGlobal("VizDefaultOptionsRecordForDisplayingWithLatex",rec(
        latexpoints := "11pt",
        orientation := "landscape",
        papersize := "a4paper"));

##########################################################################

########################################################################
# the list of admissible options for splash (more precisely: the options 
#that have some efect)
BindGlobal("VizOptionsForSplash",["path","directory","file","viewer","tikz","filetype","latexpoints","latexorientation","latexpapersize"]);


######## The treatment of the viewers must be done in another way... 
## In particular, when the help viwer is capable of reading pdfs, is should be used 
## as default.
#VizViewers := ["xpdf","evince", "okular", "gv"];
    if ARCH_IS_MAC_OS_X( ) then
      BindGlobal("VizViewers", ["xpdf","open","evince", "okular", "gv"]);
    elif ARCH_IS_UNIX( ) then
      BindGlobal("VizViewers", ["xpdf","xdg-open","evince", "okular", "gv"]);
    elif ARCH_IS_WINDOWS( ) then
      BindGlobal("VizViewers", ["xpdf","evince", "okular", "gv"]);
    fi;

if First(VizViewers, v -> Filename(DirectoriesSystemPrograms(),v) <> fail)= fail then
    Info(InfoWarning,1,"No pdf viewer from the list ", VizViewers, " is installed, thus there will be no output of any image\n");
  fi;
  if Filename(DirectoriesSystemPrograms(),"dot") = fail and Filename(DirectoriesSystemPrograms(),"dot2tex") = fail then
    Info(InfoWarning,1,"As neither GraphViz ( www.graphviz.org ) nor dot2tex ( www.fauskes.net/code/dot2tex ) is installed, no image will be produced");
  elif Filename(DirectoriesSystemPrograms(),"dot") = fail then
    Info(InfoWarning,1,"GraphViz ( http://www.graphviz.org ) is not installed. Latex will be used to produce images\n");
  fi;
#  if Filename(DirectoriesSystemPrograms(),"dot2tex") = fail then
#    Info(InfoWarning,1,"dot2tex is not installed; graphviz will be used to produce images\n");
#  fi;
