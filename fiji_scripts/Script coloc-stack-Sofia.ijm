path = File.openDialog("Select a nd2 File");
dir = File.getDirectory(path)

//setBatchMode(true); 

run("TIFF Virtual Stack...", "open=["+path+"]");
stack = getTitle();
rename("Composite");

Split = split(stack, "_s")
CompNumb = Split[0]

var DiaBlur = 10;
var DiaMedian = 0.5;

// Image procesing

run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames=1 display=Composite");
run("Median...", "radius="+DiaMedian+" stack");

run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma="+DiaBlur+" stack");

imageCalculator("Subtract create stack", "Composite","Composite-1");
selectWindow("Result of Composite");
save(dir+CompNumb+"_Composite.tif");
close("\\Others");

// make MT mask

run("Duplicate...", "title=[MT_mask] duplicate channels=3");
setAutoThreshold("Li dark");
run("Median...", "radius=2");
run("Convert to Mask");

// Make channels binary 

selectWindow("Result of Composite");
run("Make Binary", "method=Otsu background=Dark calculate black");
save(dir+CompNumb+"_Binary-Composite.tif");

// Mask stack
imageCalculator("AND create stack", "Result of Composite","MT_mask");
rename("Masked_Composite");



