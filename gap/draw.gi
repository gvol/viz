#############################################################################
##
## draw.gi           VIZ package  
##
## General framework for drawing.  
##

# returning true in case the name denotes a valid member of the record
VIZ_ExistsFieldInRecord :=function(record, name)
    return name in RecNames(record);
end;

InstallGlobalFunction(VizMakeDoc, 
function()
  MakeGAPDocDoc(Concatenation(PackageInfo("viz")[1]!.
   InstallationPath, "/doc"), "viz.xml", 
   [], "viz", "MathJax");;
end);


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
local pdfname, extension, physicalfilename, strings,log;
  #if the filename is given we need to give a warning that it is ignored
  if VIZ_ExistsFieldInRecord(params,"filename") then 
    Print("#W Parameter 'filename' is ignored for splashing.\n");
  fi;
  #if title is not given then simply "splash" is used
  if not VIZ_ExistsFieldInRecord(params,"title") then 
      params.title := "splash";
  fi;
  #due to LaTeX's security feature it can only work in the current directory
  params.filename := Filename(DirectoryCurrent(), "_tmp_viz_splash");
  log := OutputTextFile(Concatenation(params.filename, ".gaplog"),true);
  # the actual work is done by calling a Draw method, and the filename is returned with the proper extension suffixed
  physicalfilename := Draw(object,params);
  # figuring out the extension
  strings := SplitString(physicalfilename,".");
  extension := strings[Length(strings)]; #getting the last one
  pdfname := Concatenation(params.filename, ".pdf");
  #remove any previous splash
  if IsExistingFile(pdfname) then RemoveFile(pdfname);fi;
  #based on the extension we do different things
  if extension = "dot" then
    Exec(GRAPHVIZ ,physicalfilename, " > ", pdfname); #calling graphviz, this works only on UNIX machines
  elif extension = "tex" then
    Process(DirectoryCurrent(),Filename(DirectoriesSystemPrograms(),LATEX),InputTextNone(),log,[physicalfilename ]);
  fi;
  if IsExistingFile(pdfname) then
    Exec(PDF_VIEWER, pdfname, " & ");                   
  else
    Print("#E PDF file is not produced!\n");
  fi;
  CloseStream(log);
end
);

