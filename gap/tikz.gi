# this file contains methods for producing strings that contain tikz format
# descriptions of various types of objects. 

# please keep the file alphabetized.

# Drawing braid-like crossing diagrams for transformations.
# In order to avoid coincidences of crossing points the threads
# remain straight for different lengths.
# ARGUMENTS
# images - contains the list of images
# e.g. the output of ImageListOfTransformation or ListPerm
# height - the height of the diagram
# width - the width of the diagram
# minmid - minimum middle are for crossings
# EXAMPLE
# Splash(TikzImageList(ImageListOfTransformation(RandomTransformation(8)),
#        rec(width:=8,height:=6,nemtom:=3)));
InstallGlobalFunction(TikzImageList,
function(arg)
  local str,i,h,d,n,dist,w,minmid,images;
  #the first argument is compulsory, the list of images
  images := arg[1];
  n := Size(images);
  #setting the parameters
  if IsBound(arg[2]) and "width" in RecNames(arg[2]) then
    w := arg[2].width;
  else
    w := n; # default: the number of points
  fi;
  if IsBound(arg[2]) and "height" in RecNames(arg[2]) then
    h := arg[2].height;
  else
    h := w/2; # default: half the width
  fi;
  if IsBound(arg[2]) and "minmid" in RecNames(arg[2]) then
    minmid := arg[2].minmid;
  else
    minmid := 2*h/3; # default: two thirds of height
  fi;
  #calculating derived values
  dist := w/n; #distance between the nodes
  d := ((h-minmid)/2)/n; #the unit delay before curving to destination
  #building the string
  str:="";
  Append(str, "%tikz\n");#tagging the source to indicate tikz code
  Append(str,"\\begin{tikzpicture}\n");
  #NODES
  for i in [1..Length(images)] do
    #drawing the top nodes
    Append(str, Concatenation("\\node (t",String(i),
            ") at (", String(i*dist),",",String(h),") {$\\bullet$};\n"));
    #drawing the bottom nodes
    Append(str, Concatenation("\\node (b",String(i),
            ") at (", String(i*dist),",0) {$\\bullet$};\n"));
    #drawing the top middle nodes
    Append(str, Concatenation("\\node (mt",String(i),
            ") at (", String(i*dist),",",String(h-i*d),") {};\n"));
    #drawing the bottom mid nodes
    Append(str, Concatenation("\\node (mb",String(i),
            ") at (", String(i*dist),",",String(i*d),") {};\n"));
  od;
  #drawing the edges' straight initial segments
  for i in [1..Length(images)] do
    Append(str, Concatenation("\\path ",
            "(t", String(i),".center) edge",
            "(mt", String(i),".center);\n"));

    Append(str, Concatenation("\\draw ",
            "(mt", String(i),".center) to [out=-90,in=90] ",
            "(mb", String(images[i]),".center);\n"));
  od;
  #drawing the actual crossings
  for i in DuplicateFreeList(images) do
    Append(str, Concatenation("\\path ",
            "(mb", String(i),".center) edge",
            "(b", String(i),".center);\n"));
  od;
  Append(str,"\\end{tikzpicture}\n");
  return str;
end);
########

# Usage: child list and labels (optional)

# Returns: a string. 

InstallGlobalFunction(TikzTrees, 
function(arg)
  local child_list, labels, include_labels, roots, tex_str, labels_str, subtree, i;

  child_list:=arg[1];
  if Length(arg)>1 then 
    labels:=arg[2];
    include_labels:=true;
  else 
    labels:=[];
    include_labels:=false;
  fi;

  roots:=PositionsProperty(child_list, x-> x=fail);
  
  tex_str:=""; labels_str:="";
  Append(tex_str, Concatenation("\\documentclass{minimal}\n", 
  "\\usepackage{tikz-qtree}\n", "\\begin{document}\n"));
  Append(tex_str, "\\tikzset{edge from parent/.style=\n");
  Append(tex_str, Concatenation("\t{draw, edge from parent ",
  "path={(\\tikzparentnode) -- (\\tikzchildnode)}}}\n"));

  for i in roots do 
    
    Append(tex_str, "\\begin{tikzpicture}[every node/.style={draw,circle}]\n");
    Append(tex_str, "\\tikzstyle{every node}=[circle, draw]\n");
    Append(tex_str, "\\Tree\n");
    
    subtree:=TikzSubTree(i, child_list, labels, 0, include_labels);
  
    Append(tex_str, subtree[1]); 
    
    if include_labels then 
      Append(labels_str, subtree[2]);
    fi;
    
    Append(tex_str, " ];\n");
    Append(tex_str, labels_str);
    Append(tex_str, "\\end{tikzpicture}\n");
  od;

  Append(tex_str, "\\end{document}");

  return tex_str; 
end);

###

# Usage: not user function!

InstallGlobalFunction(TikzSubTree,
function(i, child_list, labels, tab_level, include_labels)
  local tabs, labels_str, tex_str, str_i, str_j, subtree, j;

  tabs:= x-> ListWithIdenticalEntries(x, ' ');
  labels_str:=""; tex_str:="";
  
  str_i:=String(i);
  
  Append(tex_str, Concatenation(tabs(tab_level), "[.\\node (", 
   str_i, ") {", str_i, "};\n"));

  for j in [1..Length(child_list)] do  
    if child_list[j]=i then
      
      str_j:=String(j); 

      if include_labels then 
        Append(labels_str, Concatenation("\\path (", str_i, ") -- (", 
        str_j, ") node [draw=none,fill=none, midway, auto] {",
        String(labels[j]),"};\n"));
      fi;

      subtree:=TikzSubTree(j, child_list, labels, tab_level+1, include_labels);

      Append(tex_str, subtree[1]);
      
      if include_labels then
        Append(labels_str, subtree[2]);
      fi;

      Append(tex_str, Concatenation(tabs(tab_level+1), "]\n"));
    fi;
  od;

  return [tex_str, labels_str];
end);

#EOF
