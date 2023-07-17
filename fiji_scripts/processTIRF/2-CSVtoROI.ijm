
// Import it into a results table. 
run("Results... "); 
 for (i = 3; i < nResults; i++) 
   { 
      // You may need to change the "frame", etc strings to match your csv file. 
      slice = getResult("FRAME", i);
      slice = slice + 1 ;
      x = getResult("POSITION_X", i); 
      y = getResult("POSITION_Y", i); 

      // Using square ROI of size 10x10 pixels centered around your coordinate. 
      run("Specify...", "width=2 height=2 x=&x y=&y slice=&slice centered"); 

      // Add to the ROI manager. 
      roiManager("Add"); 
   } 