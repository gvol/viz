#############################################################################
##
## draw.gi           VIZ package  
##

# JDM move to utils.gi

InstallGlobalFunction(VizMakeDoc, 
function()
  MakeGAPDocDoc(Concatenation(PackageInfo("viz")[1]!.
   InstallationPath, "/doc"), "viz.xml", ["draw.xml", "config.xml"], "viz", "MathJax");;
end);

InstallGlobalFunction(VizLoadExtensions,
function()
  Read(Concatenation(PackageInfo("viz")[1]!.InstallationPath,"/extensions.g")); end);
        
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
  if "filename" in RecNames(params) then 
    Print("#W Parameter 'filename' is ignored for splashing.\n");
  fi;
  #if title is not given then simply "splash" is used
  if not "title" in RecNames(params) then 
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

