// Select files
pathR = File.openDialog("Select a Raw File");
pathB = File.openDialog("Select a Background File");
dir = File.getDirectory(pathR);

// Faster processing (does not open file for visualization)
setBatchMode(true); 

// Open Raw image stack
	run("TIFF Virtual Stack...", "open=["+pathR+"]"); 
    RawID = getImageID;
    
    // Get file name
	stack = getTitle();
	Split = split(stack, ".")
	name = Split[0]

    
// Open backgrouond image
    run("TIFF Virtual Stack...", "open=["+pathB+"]");
	BkgrdID = getImageID; 

// Flat-field with background image
    imageCalculator("Divide create 32-bit stack", RawID, BkgrdID);
    RdivID = getImageID; 

// Duplicate and gaussian filter stack
	run("Duplicate...", "duplicate");
	run("Gaussian Blur...", "sigma=10 stack");
	RblurID = getImageID;
	
// Pseudo flat-field with filtered stack
    imageCalculator("Divide create 32-bit stack", RdivID, RblurID);

// Save stack
	save(dir+name+"_processed.tif");
	close("*");


 setBatchMode(false); 
 
run("TIFF Virtual Stack...", "open=["+dir+name+"_processed.tif"+"]");

