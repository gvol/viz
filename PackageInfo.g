SetPackageInfo( rec(

PackageName := "viz",

Subtitle := "viz",

Version := "0.1",

Date := "03/10/2011",

ArchiveURL := "http://sgpdec.sf.net",

ArchiveFormats := ".tar.gz",

Persons := [
  rec( 
    LastName      := "Egri-Nagy",
    FirstNames    := "Attila",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "attila@egri-nagy.hu",
    WWWHome       := "http://www.egri-nagy.hu",
    PostalAddress := Concatenation( [
                       "University of Western Sydney\n",
                       "Australia" ] ),
    Place         := "Sydney, NSW, Australia",
    Institution   := "UWS"
  ),
  rec( 
    LastName      := "Mitchell",
    FirstNames    := "J. D.",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "jdm3@st-and.ac.uk",
    WWWHome       := "http://tinyurl.com/jdmitchell",
    PostalAddress := Concatenation( [
                       "Mathematical Institute,",
                       " North Haugh,", " St Andrews,", " Fife,", " KY16 9SS,", 
                       " Scotland"] ),
    Place         := "St Andrews",
    Institution   := "University of St Andrews"
  )
],

Status := "dev",

README_URL := "http://sgpdec.sf.net",

PackageInfoURL := "http://sgpdec.sf.net",


AbstractHTML := 
  "<span class=\"pkgname\">Viz</span> is  a <span class=\"pkgname\">GAP</span> package \
   just splashing for vizzing.",

PackageWWWHome := "http://sgpdec.sf.net",

PackageDoc := rec(
  BookName  := "Viz",
  Archive :=  "http://sgpdec.sf.net",

  ArchiveURLSubset := ["htm"],
  HTMLStart := "doc/manual.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Splashing vizzing",
  Autoload  := true
),


Dependencies := rec(
 GAP := ">=4.5",
 NeededOtherPackages := [["GAPDoc", ">= 1.2"],  #StringPrint
                         ["orb", ">= 3.7"] #hashtable functionalities
                         ],
 SuggestedOtherPackages := [ ],
 ExternalConditions := [["Graphviz","http://www.graphviz.org/"]] #for creating PDF figures                      
),

AvailabilityTest := ReturnTrue,

Autoload := false,

TestFile := "test/test.g",

Keywords := ["visualisation"]

));


