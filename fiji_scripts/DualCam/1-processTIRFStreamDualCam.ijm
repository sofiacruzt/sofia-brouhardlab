path = File.openDialog("Select a Stack File");
dir = File.getDirectory(path)

setBatchMode(true); 
run("TIFF Virtual Stack...", "open=["+path+"]");

stack = getTitle();
rename("Composite");

Split = split(stack, ".")
name = Split[0]

var DiaBlur = 10;
var DiaMedian = 0.5;

// Image procesing
run("Specify...", "width=600 height=600 x=1 y=1 slice=1");
run("Duplicate...", "duplicate");
rename("Composite_GFP");

selectWindow("Composite");
run("Specify...", "width=600 height=600 x=600 y=1 slice=1");
run("Duplicate...", "duplicate");
rename("Composite_RFP");
save(dir+name+"_Composite_RFP.tif");
close();

selectWindow("Composite");
close();

selectWindow("Composite_GFP");
rename("Composite");
run("Median...", "radius="+DiaMedian+" stack");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma="+DiaBlur+" stack");

imageCalculator("Subtract create stack", "Composite","Composite-1");
selectWindow("Result of Composite");

run("Median...", "radius="+DiaMedian+" stack");


save(dir+name+"_Composite_GFP.tif");
close("*");

setBatchMode(false);

run("TIFF Virtual Stack...", "open=["+dir+name+"_Composite_GFP.tif"+"]");

