## Data sources

Original source and project:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Download site:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Study design

The data was collected  by downloading it from the data source mentioned above. The script will attempt to do this automatically if it does not recognize, or if the file is missing from the working directory. This means that if you do not have any internet connectivity, then the script will fail.

## Cleaning the data

The raw data is spread over a number of files, the sensory data is in one file, and the subject ID as well as the activity ID are both in their own, The implicit assumtion is here that they are all in the same order.

Furthermore the raw data is separated into two main category, test and train-data.

The data is manipulated in the following manner:

1, Read in the test and train data, create for each a combined dataset which contains both the subject and the activity ID. In the process we also beautify the column names so that they do not contain dashes or parenthesis and remove other than those that are either mean, or standard deviation columns
2. Combine the test and train data by concatenating both datasets to a new one
3. Replace the activity IDs with actual labels which are also cleaned up, setting to lowercase and removing any underscores
4. The tidy data is written to a file

For the subject-activity mean values we:

1. Melt the data by subject and activity
2. Calculate the mean for each subject and activity
3. Write the tidy mean data to a file

There is also a commented-out function at the end which can be used to test the validity of the mean values.

## Code book

There are two files generated, each containing the same columns. The two first columns are added to the sensory data and indicates the subject as a index, and activity label.

"subjectid"
"activitytype"
"tbodyaccmeanx"
"tbodyaccmeany"
"tbodyaccmeanz"
"tbodyaccstdx"
"tbodyaccstdy"
"tbodyaccstdz"
"tgravityaccmeanx"
"tgravityaccmeany"
"tgravityaccmeanz"
"tgravityaccstdx"
"tgravityaccstdy"
"tgravityaccstdz"
"tbodyaccjerkmeanx"
"tbodyaccjerkmeany"
"tbodyaccjerkmeanz"
"tbodyaccjerkstdx"
"tbodyaccjerkstdy"
"tbodyaccjerkstdz"
"tbodygyromeanx"
"tbodygyromeany"
"tbodygyromeanz"
"tbodygyrostdx"
"tbodygyrostdy"
"tbodygyrostdz"
"tbodygyrojerkmeanx"
"tbodygyrojerkmeany"
"tbodygyrojerkmeanz"
"tbodygyrojerkstdx"
"tbodygyrojerkstdy"
"tbodygyrojerkstdz"
"tbodyaccmagmean"
"tbodyaccmagstd"
"tgravityaccmagmean"
"tgravityaccmagstd"
"tbodyaccjerkmagmean"
"tbodyaccjerkmagstd"
"tbodygyromagmean"
"tbodygyromagstd"
"tbodygyrojerkmagmean"
"tbodygyrojerkmagstd"
"fbodyaccmeanx"
"fbodyaccmeany"
"fbodyaccmeanz"
"fbodyaccstdx"
"fbodyaccstdy"
"fbodyaccstdz"
"fbodyaccjerkmeanx"
"fbodyaccjerkmeany"
"fbodyaccjerkmeanz"
"fbodyaccjerkstdx"
"fbodyaccjerkstdy"
"fbodyaccjerkstdz"
"fbodygyromeanx"
"fbodygyromeany"
"fbodygyromeanz"
"fbodygyrostdx"
"fbodygyrostdy"
"fbodygyrostdz"
"fbodyaccmagmean"
"fbodyaccmagstd"
"fbodybodyaccjerkmagmean"
"fbodybodyaccjerkmagstd"
"fbodybodygyromagmean"
"fbodybodygyromagstd"
"fbodybodygyrojerkmagmean"
"fbodybodygyrojerkmagstd"

For detailed description on the accelerometer variables, see the README.txt included in the source data zip file.
