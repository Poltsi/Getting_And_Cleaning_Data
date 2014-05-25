# Getting And Cleaning Data

This repo is created as a part of the Getting and cleaning data-course project at Coursera (https://class.coursera.org/getdata-003/).

## Execution

To run the script you can either execute the following command on command line:

$ R --no-save < run_analysis.R

Or you can source the file in R-studio like so:

source( "run_analysis.R" )

Both requires that you are either located in the directory where the run_analysis.R exists, or you have changed the working directory in your R shell/R-Studio

If you already have downloaded the zip-file which is given in the project description (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), then make sure that it is named 'UCI_HAR_Dataset.zip', or alternatively, edit the zip.file-variable at the top of run_analysis.R to contain the proper filename.

The script will make some basic checks regarding the integrity of the files and directories, and if they fail, the script will then attempt to download a fresh copy from the web, so BEWARE if you have a slow internet connection and the zip-file is missing or different from what the script expects.

Once the script is finished, two new files should be available in the working directory, tidy_full.txt and tidy_mean.txt. The tidy_full.txt does not seem to be but a intermediate product, but since the description of the task is a bit vague (it does not exactly tell what files need to be created), both are created.

## Environments

The R script has been developed on Linux, and also tested on Windows, Mac may work as it is somewhat similar to Linux.