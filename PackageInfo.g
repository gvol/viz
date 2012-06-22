#############################################################################
##
#W  PackageInfo.g
#Y  Copyright (C) 2011-12                          The viz package authors
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

SetPackageInfo( rec(

PackageName := "viz",

Subtitle := "viz",

Version := "0.2.5",

Date := "26/04/2012",

ArchiveURL := "http://bitbucket.org/zen154115/viz",

ArchiveFormats := ".tar.gz",

Persons := [
 rec( 
    LastName      := "Delgado",
    FirstNames    := "Manuel",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "mdelgado@fc.up.pt",
    WWWHome       := "http://www.fc.up.pt/cmup/mdelgado",
    PostalAddress := Concatenation( [
                       "University of Porto\n",
                       "Portugal" ] ),
    Place         := "Porto, Portugal",
    Institution   := "University of Porto"
  ),
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
  ),
  rec( 
    LastName      := "Pfeiffer",
    FirstNames    := "Markus",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "markusp@mcs.st-and.ac.uk",
    WWWHome       := "http://www-groups.mcs.st-and.ac.uk/~markusp/",
    PostalAddress := Concatenation( [
                       "Mathematical Institute,",
                       " North Haugh,", " St Andrews,", " Fife,", " KY16 9SS,", 
                       " Scotland"] ),
    Place         := "St Andrews",
    Institution   := "University of St Andrews"
    )
],

Status := "dev",

README_URL := "nowhere yet",

PackageInfoURL := "nowhere yet",

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
 NeededOtherPackages := [["GAPDoc", ">=1.4"]],
 SuggestedOtherPackages := [["citrus", ">=0.9"] ],
 ExternalConditions := [], 
),

AvailabilityTest := ReturnTrue,

Autoload := false,

TestFile := "test/test.g",

Keywords := ["visualisation"]
));

