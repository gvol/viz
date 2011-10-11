#############################################################################
##
## draw.gd           VIZ package  
##
## Drawing GAP objects graphically. 
##

#############################################################################
## <#GAPDoc Label="Draw">
##  <ManSection><Heading>Drawing Objects</Heading>
##  <Func Name="Draw" Arg="object,params"/>
##  <Description>
## Generic method for visualising the mathematical objects within <C>GAP</C>.
## Currently drawing means that a textfile is produced which is then can postprocessed by another application
## (e.g. <URL Text="GraphViz">http://graphviz.org</URL>, LaTeX).  
## <P/>
## <C>object</C> is the object to be drawn, and method selection decides what actual drawing method is chosen.
## <C>params</C> is a record containing additional parameters for drawing. 
## The  parameter  <C>filename</C> is compulsory.
## Other parameters may encode information on how to draw the graph for an object. These are specific to particular types and
## even for the same type there could be different drawing methods requiring extra parameters (e.g. giving symbols for states instead of integers).
## It is recommended to return the the name of the physical file (i.e. filename + extension) so <Ref Func="Splash"/> can 
## start to corresponding external application.
##  </Description>
## </ManSection>
## <#/GAPDoc>
DeclareOperation("Draw",[IsObject,IsRecord]);

#############################################################################
## <#GAPDoc Label="Splash">
##  <ManSection><Heading>Online Drawing</Heading>
##  <Func Name="Splash" Arg="object"/>
##  <Func Name="Splash" Arg="object, params"/>
##  <Description>
## For immediate drawing, i.e. generating a PDF from the GraphViz source and
## starting an external application for viewing the PDF file.  
## An external PDF viewer should be configured properly by setting the <Ref Var="PDF_VIEWER"/> global variable.
## Optional parameters in a record can be passed to the drawing function (for details see <Ref Func="Draw"/>).
##  </Description>
## </ManSection>
## <#/GAPDoc>
DeclareOperation("Splash",[IsObject,IsRecord]);

# this is handy for automata (and similar) drawings
INPUTSYMBOLS := ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
	     "A","B","C","D","E","F","G","H","I","J","K","L","M","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
#just the integers as a fallback
STATES := [1..999];
