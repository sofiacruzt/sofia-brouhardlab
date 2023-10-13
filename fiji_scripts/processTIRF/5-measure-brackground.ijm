path = File.openDialog("Select a Stack File");
dir = File.getDirectory(path)

run("TIFF Virtual Stack...", "open=["+path+"]");
setAutoThreshold("Default");
////setAutoThreshold("Otsu");
//run("Threshold...");

run("Create Selection");
run("Measure");
saveAs("Results", dir+"background.csv");
roiManager("Add");
roiManager("Save", dir+"background.roi");
