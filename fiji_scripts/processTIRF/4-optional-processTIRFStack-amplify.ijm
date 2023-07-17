path = File.openDialog("Select a Stack File");
dir = File.getDirectory(path)

n=15

setBatchMode(true); 
run("TIFF Virtual Stack...", "open=["+path+"]");

stack = getTitle();
rename("Composite");

Split = split(stack, ".")
name = Split[0]

var DiaBlur = 10;
var DiaMedian = 0.5;

// Image procesing


run("Median...", "radius="+DiaMedian+" stack");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma="+DiaBlur+" stack");

imageCalculator("Subtract create stack", "Composite","Composite-1");
selectWindow("Result of Composite");

run("Median...", "radius="+DiaMedian+" stack");
processedstack = getTitle();
ResultID = getImageID;

for (i=0; i<=n; i++) { 
    showProgress(i, n);
    imageCalculator("Add create stack", ResultID,processedstack);
	ResultID = getImageID; 
    
  } 

savename = dir+name+"_Composite-amplified.tif"

save(savename);
close("*");

setBatchMode(false);

run("TIFF Virtual Stack...", "open=["+savename+"]");

