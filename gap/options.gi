#########################################################################
#has as input a record corresponding to the options
#edge_colors, nodes_fillcolors, edges_labels, nodes_labels, caption 
#The output is a new record where the defaults are introduced

InstallGlobalFunction(ProcessVizOptionsForGraphs,
function(opt)
  local   processed_opt;
  processed_opt := StructuralCopy(opt);
  #
  #### edge_colors 
  #
  # The user is allowed to specify colors to be used (these are taken as the
  # first colors) 
  #This may just correspond to a reordering of the default colors
  if IsBound(opt.edge_colors) then
    processed_opt.edge_colors := ReorderColorsForViz(opt.edge_colors);
  else # the default
    processed_opt.edge_colors := VizDefaultOptionsRecordForGraphs.edge_colors;
  fi;
  #
  ## nodes_fillcolors
  #
  # The user is allowed to specify colors to be used (these are taken as the
  # first colors) 
  # This may just correspond to reversing and reordering of the default colors by
  # putting the "white" as the first color to be used
  if IsBound(opt.nodes_fillcolors) then
    processed_opt.nodes_fillcolors := ReorderColorsForViz(opt.nodes_fillcolors,
                                             Reversed(ColorsForViz)); 
  else
    processed_opt.node_fillcolors := VizDefaultOptionsRecordForGraphs.nodes_fillcolors;
  fi;
  #
  ####edge_labels
  # possible labels: "none", "numbers", "letters" ...
  if not IsBound(opt.edge_labels) then
    processed_opt.edge_labels :=  VizDefaultOptionsRecordForGraphs.edge_labels;
  else 
    processed_opt.edge_labels := opt.edge_labels;        
  fi;
  #
  ####node_labels
  if not IsBound(opt.node_labels) then 
    processed_opt.node_labels := VizDefaultOptionsRecordForGraphs.node_labels;
  else
    processed_opt.node_labels := opt.node_labels;
  fi;
  ####nodes_shape
  if not IsBound(opt.nodes_shape) then 
    processed_opt.nodes_shape := VizDefaultOptionsRecordForGraphs.nodes_shape;
  else
    processed_opt.nodes_shape := opt.nodes_shape;
  fi;
  
  #
  #### caption
  # the possible values are: 
  # * false (no caption is introduced)
  # * edges (in the case of a Cayley Graph: displays the correspondence between
  #the labels of the edges and the generators)
  if not IsBound(opt.caption) then
    processed_opt.caption := VizDefaultOptionsRecordForGraphs.caption;
  fi;
      
  return processed_opt;
end);
