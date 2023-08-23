numberSlice= nSlices;

startslice = 1;
endslice = numberSlice;

 for (i=1; i<=endslice; i++) { 
    showProgress(i, numberSlice);
    Roi.setPosition(i);
	roiManager("Add");
    
 } 
run("Select All");
roiManager("Draw");