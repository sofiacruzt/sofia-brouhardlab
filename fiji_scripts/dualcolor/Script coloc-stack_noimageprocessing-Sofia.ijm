//A hyperstack with three channels named 'something_Composite' must already be open

dir = getDirectory("Select Saving Directory");

stack = getTitle();
rename("Result of Composite");

Split = split(stack, "_C")
CompNumb = Split[0]

//var DiaBlur = 10;
//var DiaMedian = 0.5;

// Image procesing
//run("Median...", "radius="+DiaMedian+" stack");

//run("Duplicate...", "duplicate");
//run("Gaussian Blur...", "sigma="+DiaBlur+" stack");

//imageCalculator("Subtract create stack", "Composite","Composite-1");
//selectWindow("Result of Composite");
//save(dir+CompNumb+"_Composite.tif");
//close("\\Others");
setBatchMode(true); 

// make MT mask

run("Duplicate...", "title=[MT_mask] duplicate channels=3");
setAutoThreshold("Otsu dark");
run("Median...", "radius=2");
run("Convert to Mask");
run("Invert");

selectWindow("Result of Composite");
run("8-bit");

imageCalculator("Subtract create stack", "Result of Composite","MT_mask");
rename("Masked_Composite");
save(dir+CompNumb+"_Masked-Composite.tif");

// Make channels binary 

run("Make Binary", "method=Otsu background=Dark calculate black");
run("Split Channels");
selectWindow("MT_mask");
run("Invert");
run("Merge Channels...", "c1=C1-Masked_Composite c2=C2-Masked_Composite c3=MT_mask create");

save(dir+CompNumb+"_Masked-Binary-Composite.tif");


// Measure Colocalization Correlation
run("Split Channels");
selectWindow("C1-Masked_Composite");
run("Measure");
selectWindow("C2-Masked_Composite");
run("Measure");
selectWindow("C3-Masked_Composite");
run("Measure");
imageCalculator("Multiply create", "C1-Masked_Composite","C2-Masked_Composite");
save(dir+CompNumb+"_Binary-GFPxRFP.tif");
run("Measure");
saveAs("Results", dir+CompNumb+"_Results.csv"); // 1 is CH-GFP, 2 is CH-RFP, 3 is CH-GFPxCH-RFP
close("*");
setBatchMode(false);

// Open final images
open(dir+CompNumb+"_Masked-Binary-Composite.tif");
open(dir+CompNumb+"_Binary-GFPxRFP.tif");
open(dir+CompNumb+"_Masked-Composite.tif");


