dirR = getDirectory("Select Raw Images Directory");
pathB = File.openDialog("Select a Background File");
dirS = getDirectory("Select Processed Images Output Directory"); 

setBatchMode(true); 
fileList = getFileList(dirR); 
numberSlice= fileList.length;
 for (i=0; i<=numberSlice-1; i++) { 
    showProgress(i, numberSlice-1);
    run("TIFF Virtual Stack...", "open=["+pathB+"]");
	BkgrdID = getImageID; 
    run("TIFF Virtual Stack...", "open=["+dirR+fileList[i]+"]");
    RawID = getImageID;
    imageCalculator("Divide create 32-bit", RawID, BkgrdID);
    RdivID = getImageID; 
	run("Duplicate...", "use");
	run("Gaussian Blur...", "sigma=10 stack");
	RblurID = getImageID;
    imageCalculator("Divide create 32-bit", RdivID, RblurID); 
    save(dirS+IJ.pad(i, 3)+".tif"); 
    run("Close All");
 } 
setBatchMode(false); 
 
run("Image Sequence...", "open=["+dirS+"] sort use");
