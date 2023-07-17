path = File.openDialog("Select a Stack File");
dir = File.getDirectory(path)

n=15

setBatchMode(true); 
 run("TIFF Virtual Stack...", "open=["+path+"]");
 stack = getTitle();
 Split = split(stack, ".")
 name = Split[0]


 ResultID = getImageID;

 for (i=0; i<=n; i++) { 
    showProgress(i, n);
    imageCalculator("Add create stack", ResultID,stack);
	ResultID = getImageID; 
    
  } 
  
 run("Enhance Contrast", "saturated=0.35");
 run("Next Slice [>]");
 run("Enhance Contrast", "saturated=0.35"); 

  rename(name+"_amplified");

  save(dir+name+"_amplified.tif");

setBatchMode(false); 
