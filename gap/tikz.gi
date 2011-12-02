# this file contains methods for producing strings that contain tikz format
# descriptions of various types of objects. 

# please keep the file alphabetized.

InstallGlobalFunction(TikzTransformation, 
function(f)
  local img, str, i;
  
  img := f![1];
  str:=""; 
  Append(str,"\\documentclass{minimal}\n\\usepackage{tikz}\n");
  Append(str, "\\usetikzlibrary{automata,arrows, matrix, positioning}\n");
  Append(str, "\\begin{document}\n\\tikzset{auto}\n");
  Append(str, "\\begin{tikzpicture}\n");
  Append(str, "\\tikzstyle{every state}=[minimum size=1pt,fill=black]\n");
  Append(str,"\\node[state] (t1) {};\n");

  for i in [2..Length(img)] do
    Append(str, Concatenation("\\node[state] (t",String(i),") [right of=t",
     String(i-1),"] {};\n"));

  od;

  Append(str,"\\node[state] (d1) [below of=t1]{};\n");
  
  for i in [2..Length(img)] do
    Append(str, Concatenation("\\node[state] (d", String(i), ") [right of=d",
     String(i-1), "] {};\n"));
  od;
  
  for i in [1..Length(img)] do
    Append(str, Concatenation("\\path (t", String(i), ") edge (d",
     String(i^f),");\n"));
  od;

  Append(str,"\\end{tikzpicture}\n\\end{document}");
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
  "\\usepackage{tikz, tikz-qtree}\n", "\\begin{document}\n"));

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
