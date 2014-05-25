## This script takes the dataset from

####################################################################################
## Includes

# Reshapes functions are used by the last part where we create the mean values
require( reshape )
require( reshape2 )

####################################################################################
## Variables
data.url   = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip.file   = "UCI_HAR_Dataset.zip"
zip.dir    = "UCI HAR Dataset"
# Name of the full and calculated mean tidydata file
tidydata.full = "tidy_full.txt"
tidydata.mean = "tidy_mean.txt"
# TODO: Maybe this should be a single column dataframe with named rows
data.files = data.frame( c( "activity_labels.txt",
                            "features.txt",
                            "test/subject_test.txt",
                            "test/X_test.txt",
                            "test/y_test.txt",
                            "train/subject_train.txt",
                            "train/X_train.txt",
                            "train/y_train.txt" ) )
rownames( data.files ) = c( "activitylabel",
                            "features",
                            "testsubject",
                            "testx",
                            "testy",
                            "trainsubject",
                            "trainx",
                            "trainy" )
# Let's also set the colnames, because the printout of data.files is otherwise ugly
colnames( data.files ) = c( "value" )

####################################################################################
## Functions

# missingfiles checks whether there are any critical files missing from
# the given directory

missingfiles = function( filedir, filelist ) {
    for( f in filelist )
    {
        tmpfile = paste( filedir, f, sep = "/" )
        
        if( ! sum( file.exists( tmpfile ) ) )
        {
            return( TRUE )
        }
    }

    FALSE
}

# cleansedata reads the test or train data for x, as well as y (activity) and
# subject. It also sets column names and drops any other than mean or std columns.

cleansedata = function( datatype, featurelist, datadir, datafiles ) {
    # Get the index of the real mean and std columns (as we later will
    # this indistinguishable from other columns)
    featuresindex = grep("-mean\\(\\)|-std\\(\\)", featurelist[ , "name" ] )
    x = read.table( paste( datadir, datafiles[ paste( datatype, "x",       sep = "" ), "value" ], sep = "/" ) )
    y = read.table( paste( datadir, datafiles[ paste( datatype, "y",       sep = "" ), "value" ], sep = "/" ) )
    s = read.table( paste( datadir, datafiles[ paste( datatype, "subject", sep = "" ), "value" ], sep = "/" ) )
    # Set nicer names for the columns, note that we remove the dashes,
    # parenthesis and set the name to lower case
    colnames( x ) = tolower( gsub( "-|\\(|\\)", "", featurelist[ , "name" ] ) )
    colnames( y ) = c( "activityid" )
    colnames( s ) = c( "subjectid" )
    # Drop other than the mean and std columns
    x = x[ , featuresindex ]
    # Then add the activity and subject id and return the whole thing,
    # note the order, we get first the subject ID, activity ID, and then
    # the accelerometer measurements
    cbind( s, y, x )
}

####################################################################################
## Main

# Attempt to detect what operating system we have
ostype = tolower( Sys.info()[ 1 ] )

if( ostype == "linux" ) {
    httpmethod = "curl"
} else if( ostype == "windows" ) {
    httpmethod = "internal"
} else {
    print( "WARNING: You are probably running on a Mac or other Unix which has not been tested" )
    print( "This means that the script may fail as I have not been able to verify the functionality" )
    print( "on that particular platform. If you break it, you may keep both pieces, You have been warned :-)" )
}

# Check if the zip file already exists
# Since file.exists can return a vector which in turn causes a warning to be emitted,
# we circumvent this by a kluge where we count the amount of 1's in the answer
if( ! sum( file.exists( zip.file ) ) )
{
    download.file( data.url, zip.file, method = httpmethod )
}

# Check if the data dir exists

if( ( ! sum( file.exists( zip.dir ) ) ) | missingfiles( zip.dir, data.files ) )
{
    unzip( zip.file, overwrite = TRUE )
}

# Make sure we have the required files also

if( missingfiles( zip.dir, data.files ) )
{
    stop( "ERROR: One of several of the required files are missing, unable to continue" )
}

############################ Read the data ############################

# First read in the full feature data
features = read.table( paste( zip.dir, data.files[ "features", "value" ], sep = "/" ),
                       col.names = c( "id", "name" ) )
# Read the test values
testall = cleansedata( "test", features, zip.dir, data.files )

# Ditto for train values
trainall = cleansedata( "train", features, zip.dir, data.files )

# Combine training and test data
completedata = rbind( testall, trainall )

## Replace activity IDs with labels
# Read the activity labels
activitylabels = read.table(paste( zip.dir, data.files[ "activitylabel", "value" ], sep = "/" ),
                       col.names = c( "id", "label" ) )
# Clean up the label strings, lowercase and no underscores
activitylabels[ , "label" ] = tolower(activitylabels[ , "label" ] )
activitylabels[ , "label" ] = gsub("_", "", activitylabels[ , "label" ] )

# Replace the IDs with the label, we do this in a loop as it is the easiest way
# to do a in-place replacement in the dataframe
for( idx in 1:6 )
{
    completedata[, "activityid" ][ completedata[, "activityid" ] == idx ] = activitylabels[ idx, "label" ]
}

# Then rename the activityid column as it now contains the actual type
colnames( completedata )[ 2 ] = "activitytype"

# Save this tidy data to a file
write.table( completedata,
             file      = tidydata.full,
             append    = FALSE,
             row.names = FALSE )

# Create a separate dataset which contains the mean values for each activity and subject
# First define which will be our identity variables
activitycolums = c( "subjectid", "activitytype" )
meltdata       = melt( completedata, id = activitycolums, measurevars = -activitycolums )
meandata       = dcast( meltdata, subjectid + activitytype  ~ variable, mean )

# Save this tidy data to a file
write.table( meandata,
             file      = tidydata.mean,
             append    = FALSE,
             row.names = FALSE )

# One can verify the result of this melt and dcast with the following function
#
#checkmeanvalue = function( df, si, at, cn ) {
#    mean( subset( df, ( df$subjectid == si ) & ( df$activitytype == at ) )[, cn ] )
#}
#
# By using it eg. like this:
# checkmeanvalue( completedata, 1, "walkingupstairs", "fbodybodygyrojerkmagmean" )
