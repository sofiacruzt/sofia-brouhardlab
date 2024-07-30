USE EJCB VERSIONS
FOR ALL SCRIPTS RUN IMPORT, DATE, NAMES and COLORS

GROWTH_NUCLETAION_LIFETIMES
## Only To Analyze ROIs FROM KYMOGRAPHS##

FIT_MASTER_SHEET
## To compile csv ##
Start from 'Join Data'
## To open Master Sheet and make Fit##
Start from 'Open data if already saved' and select file '2022-08-17_dynamics_MasterSheet_ThesisCH2-paper'
## To Re-plot Fits##
Start from 'Open saved fit parameters' and select file 'ResultFit_2023-08-08'
## Histogram##
Needs both Master Sheet and Fit parameters open but NO NEED to run fitting again
# Analyze Rescues#
Needs Master Sheet open use Rescue script to plot
# Plot Lifetime Parameter#
Have Fit parameters open and run from 'Lifetime Parameters'

RESCUES
## To Plot ##
Select file 'Rescues_2024-02-26'

RELATIVE_SLOPE
# To Plot #
Select file 'ResultFit_2023-08-08'

INTENSITY-BKGRDSUBS
## To compile csv ##
Start from 'Join Data'
## To open Master Sheet and make Fit##
Start from 'Open prev sevad data' and select file 'joint-data_Intensity_analysed-on_2023-10-14'

CHI2
# To Run fit #
Select file 'Sigmoidal_Data_Fit_2024-07-05'

FILES ARE LOCATED IN "Datasheets-and-plots" IN THE CORRESPONDING FOLDER