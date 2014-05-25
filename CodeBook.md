CodeBook.md - This file is a code book that describes the variables, the data,
and any transformations or work that was performed to clean up the data.

The script run_analysis.R creates and loads a working data frame.
The script then computes a second data frame, which is the tidy data frame,
containing the mean value for every combination of (variable, activity, subject).
The name of the output file containing the tidy data set is means.txt.
Thus there are exactly 4 columns in the tidy data set.
There are exactly 9540 rows in the tidy data set, as explained below.
The file is space delimited.
In the first line there is one header row identifying the 4 column names.
Columns 1 to 3 are considered factors. Column 4 is numeric (a statistical mean).

## Here are the script's main steps, summarizations, and transformations:

* Select the features of interest and create a data frame, one column per selected feature (variable).
* The raw data files are X_train.txt and X_test.txt. The code unions these rows together so they are both in the same columns.
* The R built-in functions read.table() and rbind() are used to do all the unioning of rows from the test and train files for X, Y, subject, and activity.
* Append exactly one subject column to the data frame, by unioning the data from files subject_train.txt and subject_test.txt.
* Append exactly one activity column to the data frame, by unioning the data from files y_test.txt and y_train.txt.
* Compute the mean by (variable, subject, activity).  The built-in aggregate() function is used here.
* Reshape into final tidy data format.  The melt() function from the reshape2 library is used here.
* The tidy data frame is written to disk using the built-in write.table() function.

## The 3 index variables and the 1 summary variable in tidy data set:

The tidy data file which is produced, has exactly one row for the mean of each included accelerometer variable.

There are 4 variables in the rows of the tidy data: (subject, activity, variable, value).

* subject, an integer in range 1 to 30. Each subject is a human being who was monitored using an accelerometer and gyroscope.

The subject variable in the tidy data set is UNCHANGED from the raw data.

* activity, a descriptive English string indicating the subject's activity during monitoring.

The activity variable in the tidy data set has been CHANGED versus the raw data.
The activity was an integer in the range 1 to 6 in the raw data.
The activity is an easily understood activity description in the tidy data, simply substituted as follows:

Raw data:  1,2,3,4,5,6
Tidy data: 'WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'

* variable, which is the name of an included accelerometer variable, slightly modified from original as follows.

Exactly 53 variables from the original raw data met the selection criteria and
therefore were selected by the script for inclusion in the tidy data set.

The criteria for the choice for variable inclusion in the tidy data set was:
Does this candidate variable represent a statistic for a mean or a standard deviation?
This criteria was mandated in the project requirements.
In the script, rather than doing the selected by human inspection and decision-making one variable at a time,
an automated technique was used instead, to improve reproducibility.

Accordingly, the technique that the script uses to select variables from the
candidate variables, is a simple substring search for "mean" or "std" in all the variables of the raw data.

Many of the selected variable names found in the raw data, were not directly compatible with
variable names in the R language being used for this analysis.
For maximum reproducibility, a straightforward automated technique for translating
from potentially incompatible variable names into compatible variable names was applied in producing this tidy data set.

Accordingly, the built-in R function "make.names()" was executed on every selected variable name from the raw data.
This step created guaranteed R-compatible variable names from the raw data variable names, in a straightforward and reproducible manner.

The tolower() function is used to lower-case all alphabetic characters in the variable name.

* value, which is the arithmetic mean computed on some selected statistic from the raw data, grouped by activity and subject.

The units of the original statistic are preserved. That is, whatever is the units of the selected statistic,
is likewise the units of the value of the computed mean in this tidy data set.
Accordingly, the original documentation provided with the raw data is authoritative on the variables
contained therein and so may be consulted for information on the units contained in the raw data.
For example, if g-force is in units of newtons in the raw data, then the value of the computed mean of g-force, is also in newtons.

In the tidy data set, each row represents exactly one observation or output value
associated with the given (variable, activity, subject).
The first 3 columns of the tidy data set, uniquely identify the statistic of interest.
The fourth column, value, is the arithmetic mean of the statistic of interest.
There are 53 * 6 * 30 = 9540 rows in the tidy data set.
This is because there are 9540 combinations of 53 variables, 6 activities, and 30 subjects.

It is anticipated that any follow-on analyses will be most conveniently computed using
the variable name in the data rows rather than in column headings, such that searches for variables will be conducted
with maximal simplicity.  With variable names as data, all the power of dynamic row selection becomes possible
on the variable names of interest. When there are a large number variables such as in the body of raw data
provided, it is important to be able to quickly locate variables of interest,
for example you might want to see only the "x", "y" or "z" coordinate, "mean" or "std" statistic, "gravity" or "jerk" variable.
The rows associated with the variables of interest are then most easily queried using the row-selection syntax of the built-in R data.frame.
By contrast, it would be more unnatural and inconvenient with the built-in R data.frame
to have to query a data frame by dynamically choosing columns of interest.
For the stated reasons of query simplicity, it was decided to be better to avoid putting the selected variable names as a list of 53 columns in a data.frame.



