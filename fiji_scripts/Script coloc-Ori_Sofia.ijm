path = File.openDialog("Select a nd2 File");
dir = File.getDirectory(path)

setBatchMode(true); 

run("Bio-Formats Importer", "open=["+path+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
stack = getTitle();

CompNumb = substring(stack, 15, 16)

var DiaBlur = 10;
var DiaMedian = 0.5;

// Image procesing

run("Median...", "radius="+DiaMedian+" stack");

run("Duplicate...", "duplicate");
stack1 = getTitle();
run("Gaussian Blur...", "sigma="+DiaBlur+" stack");

imageCalculator("Subtract create stack", stack , stack1);
rename("Result of Composite");
save(dir+CompNumb+"_Composite.tif");
//close("\\Others");

// Make channels binary

run("Make Binary", "method=Otsu background=Dark calculate black");

//run("Split Channels");
save(dir+CompNumb+"_Binary-Composite.tif");
//close("\\Others");

// MT mask - mask after binary instead of before

run("Duplicate...", "title=[MT_mask] duplicate channels=3");

imageCalculator("AND create stack", "Result of Composite","MT_mask");
rename("Masked_Composite");
//run("Channels Tool...");
run("Blue");
Stack.setChannel(2);
run("Green");
Stack.setChannel(3);
run("Red");
Stack.setDisplayMode("composite");
save(dir+CompNumb+"_Masked-Composite.tif");

// Measure Colocalization Correlation

run("Split Channels");
selectWindow("C2-Masked_Composite");
run("Measure");
imageCalculator("Multiply create", "C1-Masked_Composite","C2-Masked_Composite");
save(dir+CompNumb+"_Binary-GFPxRFP.tif");
run("Measure");
saveAs("Results", dir+CompNumb+"_Results.csv"); // 1 is CH-GFP, 2 is CH-GFPxCH-RFP
close("*");

setBatchMode(false);

// Open final images

open(dir+CompNumb+"_Masked-Composite.tif");
open(dir+CompNumb+"_Binary-GFPxRFP.tif");
open(dir+CompNumb+"_Composite.tif");
run("Make Composite");

