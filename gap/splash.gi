#############################################################################
##
## draw.gi           VIZ package  
##

InstallOtherMethod(Splash, "for an object",
[IsObject],
function(object)
    Splash(object, rec()); 
end);

# splash - immediate display

InstallMethod(Splash, "with parameters",
[IsObject, IsRecord],
function(object, params)
local pdfname, extension, physicalfilename, strings,log;
  
  #due to LaTeX's security feature it can only work in the current directory
  filename := Filename(DirectoryCurrent(), "_tmp_viz_splash");
  log := OutputTextFile(Concatenation(params.filename, ".gaplog"),true);
  # the actual work is done by calling a Draw method, and the filename is 
  # returned with the proper extension suffixed
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

