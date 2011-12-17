SetPackageInfo( rec(

PackageName := "viz",

Subtitle := "viz",

Version := "0.2.2",

Date := "17/12/2011",

ArchiveURL := "http://bitbucket.org/zen154115/viz",

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

README_URL := "http://bitbucket.org/zen154115/viz",

PackageInfoURL := "http://bitbucket.org/zen154115/viz/downloads",


AbstractHTML := 
  "<span class=\"pkgname\">Viz</span> is  a <span class=\"pkgname\">GAP</span> package \
   package for drawing GAP objects.",

PackageWWWHome := "http://bitbucket.org/zen154115/viz/",

PackageDoc := rec(
  BookName  := "Viz",
  Archive :=  "http://bitbucket.org/zen154115/viz",

  ArchiveURLSubset := ["htm"],
  HTMLStart := "doc/manual.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Drawing GAP objects",
  Autoload  := true
),

Dependencies := rec(
 GAP := ">=4.5",
 NeededOtherPackages := [["GAPDoc", ">= 1.4"], ["Grape", ">=4.3"], 
 ["Smallsemi", ">=0.6.4"], ["orb", "3.7"], ["citrus", "0.4"] ],
 SuggestedOtherPackages := [ ],
 ExternalConditions := [], 
),

AvailabilityTest := ReturnTrue,

Autoload := false,

TestFile := "test/test.g",

Keywords := ["visualisation"]
));

