//This script takes as input a stack with both channels that needs to be compared: ch1 and ch2

rename("Origin");
run("Duplicate...", "duplicate");
run("Z Project...", "start=1 stop=1 projection=[Max Intensity]");
rename("MTs");
selectWindow("Origin-1");
run("Z Project...", "start=2 stop=2 projection=[Max Intensity]");
rename("Actin");
close("Origin");
close("Origin-1");

// median filter channel 1

selectWindow("MTs");

var DiaBlur = 10;
var DiaMedian = 0.5;
var Nbre = 5;


Title=getTitle();
nbreSlices=nSlices;
run("Duplicate...", "  title=[Blur "+DiaBlur+"] duplicate ");
Blur=getTitle();
run("Duplicate...", "title=["+Title+" Median "+DiaMedian+"] duplicate "); 
Median=getTitle;

run("Median...", "radius="+DiaMedian+" stack");
selectWindow(Blur); run("Gaussian Blur...", "sigma="+DiaBlur+" stack");

imageCalculator("Subtract stack", Median,Blur);

if (nbreSlices>1){
run("Z Project...", " projection=[Max Intensity]");
}

selectWindow("Blur 10"); close();
selectWindow("MTs"); close();

// Threshold channel 1

selectWindow("MTs Median 0.5");
setAutoThreshold("Otsu dark");
run("Convert to Mask");
rename("MTs-mask");
run("Measure");

// Median filter channel 2

selectWindow("Actin");

var DiaBlur = 10;
var DiaMedian = 0.5;
var Nbre = 5;

Title=getTitle();
nbreSlices=nSlices;
run("Duplicate...", "  title=[Blur "+DiaBlur+"] duplicate ");
Blur=getTitle();
run("Duplicate...", "title=["+Title+" Median "+DiaMedian+"] duplicate "); 
Median=getTitle;

run("Median...", "radius="+DiaMedian+" stack");
selectWindow(Blur); run("Gaussian Blur...", "sigma="+DiaBlur+" stack");

imageCalculator("Subtract stack", Median,Blur);

if (nbreSlices>1){
run("Z Project...", " projection=[Max Intensity]");
}

selectWindow("Blur 10"); close();
selectWindow("Actin"); close();

//threshold channel 2

selectWindow("Actin Median 0.5");
setAutoThreshold("Otsu dark");
run("Convert to Mask");
rename("Actin-mask");
run("Measure");

// multiplication channel 1 and channel 2

imageCalculator("Multiply create", "MTs-mask","Actin-mask");
selectWindow("Result of MTs-mask");
rename("MTsXActin-mask");
run("Measure");

// output gives measures in that order: ch1, ch2 and ch1 x ch2
// to get % colocalization of ch1 with ch2 calculate ch1xch2 / ch1