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
local dotname, pdfname, extension, physicalfilename, strings;
  #if the filename is  not given we generate a random when 
  if not VIZ_ExistsFieldInRecord(params,"filename") then 
      params.filename := Filename(DirectoryTemporary(), "splash");
  fi;
  #if title is not given then simply "splash" is used
  if not VIZ_ExistsFieldInRecord(params,"title") then 
      params.title := "splash";
  fi;

  # the actual work is done by calling a Draw method, and the filename is returned
  physicalfilename := Draw(object,params);
  strings := SplitString(physicalfilename,".");
  extension := strings[Length(strings)]; #getting the last one
  pdfname := Concatenation(params.filename, ".pdf");
  #based on the extension we do different things
  if extension = "dot" then
    Exec(GRAPHVIZ ,physicalfilename, " > ", pdfname); #calling graphviz, this works only on UNIX machines
  elif extension = "tex" then
    Exec(LATEX ,physicalfilename); #calling latex
  fi;
  Exec(PDF_VIEWER, pdfname, " & ");                   
end
);

