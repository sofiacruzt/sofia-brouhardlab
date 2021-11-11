//must have a selected area to crop
dir = getDirectory("Select Saving Directory");

stack = getTitle();
rename("Binary Composite");

Split = split(stack, "_M")
CompNumb = Split[0]

setBatchMode(true); 


Roi.setPosition(1);
roiManager("Add");
roiManager("Save", dir+CompNumb+"_Area-Crop.roi");

run("Crop");
save(dir+CompNumb+"_Masked-Binary-Composite-Area.tif");

run("Split Channels");

imageCalculator("Multiply create", "C1-Binary Composite","C2-Binary Composite");
save(dir+CompNumb+"_Binary-GFPxRFP-Area.tif");

selectWindow("C1-Binary Composite");
run("Measure");
selectWindow("C2-Binary Composite");
run("Measure");
selectWindow("C3-Binary Composite");
run("Measure");
selectWindow("Result of C1-Binary Composite");
run("Measure");
saveAs("Results", dir+CompNumb+"_Results-Area.csv");

