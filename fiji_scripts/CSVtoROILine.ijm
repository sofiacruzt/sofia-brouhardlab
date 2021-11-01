
// Import it into a results table. 
run("Results... "); 
 for (i = 0; i < nResults; i++) 
   { 
      // You may need to change the "frame", etc strings to match your csv file. 
      //slice = getResult("POSITION_T", i);
      //slice = slice + 1 ;
      x1 = getResult("x1", i); 
      y1 = getResult("y1", i); 
      x2 = getResult("x2", i); 
      y2 = getResult("y2", i);

      // Using square ROI of size 10x10 pixels centered around your coordinate. 
      makeLine(x1, y1, x2, y2); 

      // Add to the ROI manager. 
      roiManager("Add"); 
   } 