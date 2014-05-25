#run_analysis.R
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive activity names.
#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(reshape2)  # for melt()

# Load the main body of data

F <- c('UCI HAR Dataset/train/X_train.txt', 'UCI HAR Dataset/test/X_test.txt')
df <- data.frame()
for (f in F) df <- rbind(df, read.table(f))

# Load the names of variables we are keeping in the main body of data,
# but discard the rest of the columns.
# Keep the statistical mean standard deviation variables.
# The variable numbers in keep_varnums represent the ordinal position in original files.

l <- readLines('UCI HAR Dataset/features.txt')
keep <- grep(pattern='mean|std', x=l, ignore.case=T, value=T)
keepspl <- strsplit(keep, " ")
keep_varnums <- as.integer(unlist(lapply(X=keepspl, FUN=function(s) s[1])))
keep_varnames <- tolower(make.names(unlist(lapply(X=keepspl, FUN=function(s) s[2]))))

# Discard the old dataframe with its extraneous variables,
# and only keep the new dataframe with its useful variable subset.

newdf <- df[, keep_varnums]  # Use the variable numbers to identify columns to keep.
names(newdf) <- keep_varnames # Assign them the variable names which are R compatible.
df <- newdf

# Now the dataframe looks like this. Same number of rows as originally
# but there are only 53 columns now.
#> df[1:3,c(1,2,3)]
#tbodyacc_mean___x tbodyacc_mean___y tbodyacc_mean___z
#1         0.2885845       -0.02029417        -0.1329051
#2         0.2784188       -0.01641057        -0.1235202
#3         0.2796531       -0.01946716        -0.1134617
#> ncol(df)
#[1] 53
#> nrow(df)
#[1] 10299


# 'Subject' column will now be added to the dataframe.

F <- c('UCI HAR Dataset/train/subject_train.txt', 'UCI HAR Dataset/test/subject_test.txt')
dfs <- data.frame()
for (f in F) dfs <- rbind(dfs, read.table(f))
names(dfs) <- c('subject')
df$subject <- dfs$subject # Appends the new column 'subject' to df

# Activity is the label, that is, the prediction for an observation.
# Activity column will now be added to the dataframe.
# It is an integer column which we read from the file.
# But, it is a factor column, using descriptive names, which we
# prefer to have added to our dataframe.
# Therefore I will first need to do a translation from integer to descriptive name.
#1 WALKING
#2 WALKING_UPSTAIRS
#3 WALKING_DOWNSTAIRS
#4 SITTING
#5 STANDING
#6 LAYING

F <- c('UCI HAR Dataset/train/y_train.txt', 'UCI HAR Dataset/test/y_test.txt')
dfa <- data.frame()
for (f in F) dfa <- rbind(dfa, read.table(f))
names(dfa) <- c('activity_int')
breaks=c(0,1,2,3,4,5,6)  # There is no 0 code. Luckily, (0,1] means that 0 is excluded, 1 is included. Weird but good!
labels <- c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING')
dfa$activity <- cut(dfa$activity_int, breaks=breaks, labels=labels)
df$activity <- dfa$activity # Appends the new column 'activity' to df

# Finally, create a second, independent tidy data set
# with the average of each variable for each activity and each subject.
# The subject (int) will be implicitly changed to a factor. (See: aggregate())
# The na columns will be implicitly omitted. (See: aggregate())

variable_means <- aggregate(df[,1:53], by=list(df$subject, df$activity), mean)

# Now, the 2 new column names created from the by clause,
# need to be changed from ‘Group.1’ to meaningful name like ‘Subject’.
# Also, one observation per row would be preferred instead of 53 per row.

names(variable_means)[1:2] <- c('subject','activity')
variable_means_one_observation <- melt(variable_means, id.vars=c('subject','activity'))

# Good, now data looks like this, which is a TIDY one value per row:
#> head(variable_means_one_observation, 40)
#subject         activity          variable     value
#1        1          WALKING tbodyacc_mean___x 0.2773308
#2        2          WALKING tbodyacc_mean___x 0.2764266
#3        3          WALKING tbodyacc_mean___x 0.2755675
#4        4          WALKING tbodyacc_mean___x 0.2785820
#5        5          WALKING tbodyacc_mean___x 0.2778423
#...
#31       1 WALKING_UPSTAIRS tbodyacc_mean___x 0.2554617
#32       2 WALKING_UPSTAIRS tbodyacc_mean___x 0.2471648
#tail(variable_means_one_observation, 40)
# ...
#9538      28   LAYING angle_z,gravitymean_  0.0503114269
#9539      29   LAYING angle_z,gravitymean_ -0.4234732791
#9540      30   LAYING angle_z,gravitymean_ -0.5070199383

# Run a write.table on the tidy data set, to output a single txt file per requirement.
write.table(x=variable_means_one_observation, file='means.txt', row.names=FALSE, quote=FALSE)

