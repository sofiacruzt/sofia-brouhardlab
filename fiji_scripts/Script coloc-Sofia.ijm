pathGFP = File.openDialog("Select a GFP File");
pathRFP = File.openDialog("Select a RFP File");
pathMT = File.openDialog("Select a Microtubule File");
dir = File.getDirectory(pathGFP)

setBatchMode(true); 

run("TIFF Virtual Stack...", "open=["+pathGFP+"]");
GFP = getTitle();
run("TIFF Virtual Stack...", "open=["+pathRFP+"]");
RFP = getTitle();
run("TIFF Virtual Stack...", "open=["+pathMT+"]");
MT = getTitle();

Split = split(GFP, "g")
CompNumb = Split[0]

var DiaBlur = 10;
var DiaMedian = 0.5;

// Image procesing

run("Merge Channels...", "c2="+GFP+" c3="+MT+" c6="+RFP+" create");
run("Median...", "radius="+DiaMedian+" stack");

run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma="+DiaBlur+" stack");

imageCalculator("Subtract create stack", "Composite","Composite-1");
selectWindow("Result of Composite");
save(dir+CompNumb+"_Composite.tif");
close("\\Others");

// MT mask

run("Duplicate...", "title=[MT_mask] duplicate channels=2");
setAutoThreshold("Otsu dark");
run("Convert to Mask");
imageCalculator("AND create stack", "Result of Composite","MT_mask");
rename("Masked_Composite");
save(dir+CompNumb+"_Masked-Composite.tif");


// Make channels binary

run("Make Binary", "method=Otsu background=Dark calculate black");

run("Split Channels");
run("Merge Channels...", "c2=C1-Masked_Composite c3=MT_mask c6=C3-Masked_Composite create");
save(dir+CompNumb+"_Binary-Composite.tif");
close("\\Others");

// Measure Colocalization Correlation

run("Split Channels");
selectWindow("C1-Masked_Composite");
run("Measure");
imageCalculator("Multiply create", "C1-Masked_Composite","C3-Masked_Composite");
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


