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
//save(dir+CompNumb+"_Composite.tif");
close("\\Others");

// MT mask

run("Duplicate...", "title=[MT_mask] duplicate channels=3");
setAutoThreshold("Otsu dark");
run("Convert to Mask");
imageCalculator("AND create stack", "Result of Composite","MT_mask");
rename("Masked_Composite");
//save(dir+CompNumb+"_Masked-Composite.tif");


// Make channels binary

run("Make Binary", "method=Otsu background=Dark calculate black");

run("Split Channels");
run("Merge Channels...", "c1=MT_mask c2=C2-Masked_Composite c3=C1-Masked_Composite create");
save(dir+CompNumb+"_Binary-Composite.tif");
close("\\Others");

// Measure Colocalization Correlation


run("Split Channels");
selectWindow("C2-Composite");
run("Measure");
imageCalculator("Multiply create", "C2-Composite","C3-Composite");
save(dir+CompNumb+"_Binary-GFPxRFP.tif");
run("Measure");
saveAs("Results", dir+CompNumb+"_Results.csv"); // 1 is CH-GFP, 2 is CH-GFPxCH-RFP
close("*");

setBatchMode(false);

// Open final images

open(dir+CompNumb+"_Binary-Composite.tif");
open(dir+CompNumb+"_Binary-GFPxRFP.tif");
open(dir+CompNumb+"_Composite.tif");
run("Make Composite");

