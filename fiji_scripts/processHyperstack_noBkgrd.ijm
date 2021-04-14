pathR = File.openDialog("Select a Raw File");
dirR = getDirectory("Select Raw Images Output Directory");
pathB = File.openDialog("Select a Background File");
dirS = getDirectory("Select Processed Images Output Directory"); 

run("TIFF Virtual Stack...", "open=["+pathR+"]");
run("Image Sequence... ", "format=TIFF name=[] use save=["+dirR+"]");
run("Close All");

fileList = getFileList(dirR); 
numberSlice=fileList.length;
setBatchMode(true); 
 for (i=0; i<=numberSlice-1; i++) { 
    showProgress(i, numberSlice-1);
    run("TIFF Virtual Stack...", "open=["+pathB+"]");
	BkgrdID = getImageID; 
    open(dirR+fileList[i]);
    RawID = getImageID;
    imageCalculator("Divide create 32-bit", RawID, BkgrdID);
    RdivID = getImageID; 
	run("Duplicate...", "use");
	run("Gaussian Blur...", "sigma=10 stack");
	RblurID = getImageID;
    imageCalculator("Divide create 32-bit", RdivID, RblurID);
    save(dirS+IJ.pad(i, 5)+".tif"); 
    run("Close All");
 } 
 setBatchMode(false); 
 
 run("Close All");
 run("Image Sequence...", "open=["+dirS+"] sort use");
