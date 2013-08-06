
#########################################################################
# The input is one or two lists of colors (strings representing colors)
# When the second list is not present, ColorsForViz is taken
# The output is the duplicates free concatenation of both lists.
# (Frequently the output is just a reordering of ColorsForViz.)
####
#### has been placed in th .gd file, since it is used there
####
#InstallGlobalFunction(ReorderColorsForViz,
#function(arg)
#  if Length(arg) = 1 then
#    return DuplicateFreeList(Concatenation(arg[1],ColorsForViz));
#  else
#    return DuplicateFreeList(Concatenation(arg[1],arg[2]));
#  fi;
#end);
##########################################################################
# The input is a list of colors and an integer <n>
# The output is a list of length <n> where the list of colors is repeated

InstallGlobalFunction(ReuseVizColors,
function(arg)
  local   n,  colors,  nc;
  n := First(arg, k->IsInt(k));
  colors := First(arg, k->not IsInt(k));
  nc := Length(colors);
  return List([1 .. n], i -> colors[(i mod nc) + 1]);
end);

#############################################################################
# Splash ... to be merged with Splash ... (the old version has been removed)
# the input is
# * a record of options (may not be present) and
# * a string (dot) or a function that applied to the ramaining argument produces a dot string

InstallGlobalFunction(Splash,
function(arg)
  local opt, dotstring, f, s, path, dir, tdir, file, viewer, tikz, filetype, i, 
        latexstring, command;

  ##########
  # there are global warnings concerning the avaiability of software
  # there is no need to put them here
  ###############
  opt := First(arg, k -> IsRecord(k));
  if opt = fail then
    opt := rec();
  else
    if not IsSubset(VizOptionsForSplash,RecNames( opt)) then
      Info(InfoViz,1,"The options ", Difference(RecNames(opt),
       VizOptionsForSplash)," have no effect.");
    fi;
  fi;
  dotstring := First(arg, k -> IsString(k));
  if dotstring = fail then
    f := First(arg, k -> IsFunction(k));
    s := First(arg, k -> IsSemigroup(k));
    dotstring := f(s);
  fi;

  # begin options
  #path
  if IsBound(opt.path) then
    path := opt.path;
  else
    path := "~/";
  fi;

  #directory
  if IsBound(opt.directory) then
    if not opt.directory in DirectoryContents(path) then
      Exec(Concatenation("mkdir ",path,opt.directory));
      Info(InfoViz, 1, "The temporary directory ",path,opt.directory, 
       " has been created");
    fi;
    dir := Concatenation(path,opt.directory,"/");
  elif IsBound(opt.path) then
    if not "tmp.viz" in DirectoryContents(path) then
      tdir := Directory(Concatenation(path,"/","tmp.viz"));
      dir := Filename(tdir, "");
    fi;
  else
    tdir := DirectoryTemporary();
    dir := Filename(tdir, "");
  fi;
  #
  Info(InfoViz,1,"The temporary directory used is: ", dir,"\n");

  #file
  if IsBound(opt.file) then
    file := opt.file;
  else
    file := "vizpicture";
  fi;

  #viewer
  if IsBound(opt.viewer) then
    viewer := opt.viewer;
  else
    viewer := First(VizViewers, x ->
     Filename(DirectoriesSystemPrograms(),x)<>fail);
  fi;

  # latex
  if IsBound(opt.tikz) then
    tikz := opt.tikz;
  else
    tikz := false;
  fi;
  if IsBound(opt.filetype) then
    filetype := opt.filetype;
  else
     if ARCH_IS_UNIX( ) then
      filetype := "pdf";
    elif ARCH_IS_WINDOWS( ) then
     filetype := "pdf";
    elif ARCH_IS_MAC_OS_X( ) then
      filetype := "svg";
    fi;
  fi;  
  ######################
  if tikz or dotstring{[1..5]}="%tikz" then
    if dotstring{[1..5]}="%tikz" then #the string is a latex string
      #process specific options
      #for i in RecNames(VizDefaultOptionsRecordForDisplayingWithLatex) do
      #  if not IsBound(opt.(i)) then
      #    opt.(i) := VizDefaultOptionsRecordForDisplayingWithLatex.(i);
      #  fi;
      #od;
    #  latexstring := "\\documentclass[";
    #  for i in RecNames(VizDefaultOptionsRecordForDisplayingWithLatex) do
    #    Append(latexstring,Concatenation(opt.(i),","));
    #  od;
    #  Append(latexstring,"]{article}\n");
    #  Append(latexstring,"\\usepackage[vmargin=2cm,hmargin=2cm]{geometry}\n");
    #  Append(latexstring,"\\usepackage[x11names, rgb]{xcolor}\n");
 #  #   Append(latexstring,"\\usepackage[utf8]{inputenc}\n");
    #  Append(latexstring,"\\usepackage{pgf}\n");
    #  Append(latexstring,"\\usepackage{tikz}\n");
    #  Append(latexstring,"\\usepgfmodule{plot}\n");
    #  Append(latexstring,"\\usepgflibrary{plothandlers}\n");
    #  Append(latexstring,"\\usetikzlibrary{shapes.geometric}\n");
    #  Append(latexstring,"\\usetikzlibrary{shadings}\n");
    #  Append(latexstring,"\\usepackage{amsmath}\n");
    #  Append(latexstring,"\%\n");
    #  Append(latexstring,"\\begin{document}\n");
    #  Append(latexstring,"\\pagestyle{empty}\n");
    #  Append(latexstring,"\\begin{center}\n");
    #  Append(latexstring,Concatenation("\\input{",file,"1}\n"));
    #  Append(latexstring,"\\end{center}\n");
    #  Append(latexstring,"\\end{document}\n");
      FileString(Concatenation(dir, file, ".tex"), dotstring);

      #FileString(Concatenation(dir,file,"1.tex"),dotstring);
    else

      FileString(Concatenation(dir,file,".dot"),dotstring);

      command := Concatenation("dot2tex -ftikz ",dir,file,".dot"," > ",
       dir,file,".tex");
      Exec(command);
    fi;

    command := Concatenation("cd ",dir,"; ","pdflatex ",dir,file, 
    " 2>/dev/null 1>/dev/null");
    Exec(command);

    Exec (Concatenation(viewer, " ",dir,file,".pdf 2>/dev/null 1>/dev/null &"));
    return;
  fi;

  FileString(Concatenation(dir,file,".dot"),dotstring);
  command := Concatenation("dot -T",filetype," ",dir,file,".dot"," -o ", dir,file,".",filetype);
  Exec(command);
  Exec (Concatenation(viewer, " ",dir,file,".",filetype," 2>/dev/null 1>/dev/null &"));
  return;

end);
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
InstallGlobalFunction(TreatNodeData,
function(n,list)
  local   nodes,  i,  node,  triple;
  nodes := [];
  for i in [1..n] do
    node := [i,"",""];
    for triple in list do
      if i in triple[1] then
        if node[2] = "" then
          node[2] := triple[2];
        else #this (usually) leads to a different shapes when various different
#shapes are to be assigned to the same node
          node[2] := NodeShapesForViz[
                             (Position(NodeShapesForViz,node[2]) +
                              Position(NodeShapesForViz,triple[2]) mod
                              Length(NodeShapesForViz)) +1];
        fi;
        if node[3] = "" then
          node[3] := triple[3];
          else #this (usually) leads to a different colors when various different
#colors are to be assigned to the same node
          node[3] := ColorsForViz[
                             (Position(ColorsForViz,node[3]) +
                              Position(ColorsForViz,triple[3]) mod
                              Length(ColorsForViz)) +1];
        fi;
      fi;
    od;
    if node[2] = "" then
      node[2] := VizDefaultNodeShape;
    fi;
    if node[3] = "" then
      node[3] := VizDefaultNodeFillColor;
    fi;
    Append(nodes,[node]);
  od;
  return nodes;
end);
