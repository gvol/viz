
InstallGlobalFunction(Splash,
function(string)
local pdfname, extension, filename,log;
  
  #due to LaTeX's security feature it can only work in the current directory
  filename := "_tmp_viz_splash";
  log := OutputTextFile(Concatenation(filename, ".gaplog"),true);
  if PositionSublist(string, "tikz") <> fail then
      extension := "tex";
  else
      extension := "dot";
  fi;

  pdfname := Concatenation(filename, ".pdf");
  filename := Concatenation(filename,".",extension);
  #writing the string out to an actual file
  FileString(filename, string);
  #remove any previous splash
  if IsExistingFile(pdfname) then RemoveFile(pdfname);fi;
  #based on the extension we do different things
  if extension = "dot" then
    Exec(GRAPHVIZ ,filename, " > ", pdfname); #calling graphviz, this works only on UNIX machines
  elif extension = "tex" then
    Process(DirectoryCurrent(),Filename(DirectoriesSystemPrograms(),LATEX),InputTextNone(),log,[ filename ]);
  fi;
  if IsExistingFile(pdfname) then
    Exec(PDF_VIEWER, pdfname, " & ");                   
  else
    Print("#E PDF file is not produced!\n");
  fi;
  CloseStream(log);
end
);

