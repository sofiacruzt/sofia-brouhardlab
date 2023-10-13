path = File.openDialog("Select a Stack File");
dir = File.getDirectory(path)


setBatchMode(true); 


run("TIFF Virtual Stack...", "open=["+path+"]");
stack = getTitle();
rename("Composite");

Split = split(stack, ".")
name = Split[0]

run("Duplicate...", " ");

open(dir+"background.roi");
setBackgroundColor(0, 0, 0);
run("Clear Outside");
run("Select None");
run("Median...", "radius=25");

imageCalculator("Subtract create", "Composite","Composite-1");

save(dir+name+"_processed.tif");
close("*");


setBatchMode(false);

run("TIFF Virtual Stack...", "open=["+dir+name+"_processed.tif"+"]");

open(dir+"mtlines.zip");

roiManager("Measure");
saveAs("Results", dir+"Results_processed.csv");