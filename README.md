README.md
This README explains how all of the scripts work and how they are connected.

## What are the scripts:

The file run_analysis.R is the entire script. There are no other script files.
To run this script in R, do this: source('run_analysis.R')

## Prerequisites:

The optional library reshape2 is used by this script, and needs to be installed in R before running this script.

The raw data files need be uncompressed and installed on the local host, and extracted into the
directories which are included in the compressed archive, before running this script.
The raw data file was downloaded from this URL:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

When it is executed, the script needs to reside in the directory above the top directory containing all the raw data files.

## Purpose of the script:

This script inputs from the local file system, the raw data files which recorded the motions of 30 human subjects during daily activities.
This script outputs exactly one tidy data file "means.txt", as according to the project requirements.
The tidy data file is designed to present the computed means of 53 motion variables,
which were selected the from the larger body of motion variables provided in the raw data.
One mean statistic is computed for the combination of every included variable, unique activity identifier, and subject identifier.

## How the script works, in overview:

The complete script itself, included, provides full details.
Here is an overview of that script.

The script loads a working data frame, and then it computes a tidy data frame.
Here are the main steps in the script:

* Select the features of interest and create a data frame, one column per selected feature (variable).
* The raw data files are X_train.txt and X_test.txt. The code unions these rows together so they are both in the same columns.
* The R built-in functions read.table() and rbind() are used to do all the unioning of rows from the test and train files for X, Y, subject, and activity.
* Append exactly one subject column to the data frame, by unioning the data from files subject_train.txt and subject_test.txt.
* Append exactly one activity column to the data frame, by unioning the data from files y_test.txt and y_train.txt.
* Compute the mean by (variable, subject, activity).  The built-in aggregate() function is used here.
* Reshape into final tidy data format.  The melt() function from the reshape2 library is used here.
* The tidy data frame is written to disk using the built-in write.table() function.
