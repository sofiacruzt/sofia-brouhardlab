path = File.openDialog("Select a Stack File");
dir = File.getDirectory(path)

setBatchMode(true); 
open(path);
stack = getTitle();
rename("Composite");

Split = split(stack, "_s")
CompNumb = Split[0]

var DiaBlur = 10;
var DiaMedian = 0.5;

// Image procesing


run("Median...", "radius="+DiaMedian+" stack");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma="+DiaBlur+" stack");

imageCalculator("Subtract create stack", "Composite","Composite-1");
selectWindow("Result of Composite");
save(dir+CompNumb+"_Composite.tif");
close("*");

setBatchMode(false);

open(dir+CompNumb+"_Composite.tif");