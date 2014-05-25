## This script takes the dataset from

####################################################################################
## Includes

# Reshape is used by the last part where we create the mean values
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
        
        if( ! file.exists( tmpfile ) )
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
    # Then add the activity and subject id and return the whole thing
    cbind( x, y, s )
}

####################################################################################
## Main

# Check if the zip file already exists

if( ! file.exists( zip.file ) )
{
    download.file( data.url, zip.file, method = "curl" )
}

# Check if the data dir exists

if( ( ! file.exists( zip.dir ) ) | missingfiles( zip.dir, data.files ) )
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
                       col.names = c( "id", "activitytype" ) )
# Clean up the label strings, lowercase and no underscores
activitylabels[ , "activitytype" ] = tolower(activitylabels[ , "activitytype" ] )
activitylabels[ , "activitytype" ] = gsub("_", "", activitylabels[ , "activitytype" ] )

# Replace the IDs with the label, we do this in two steps, first we merge the
# activity labels to the complete data based on IDs, then drop the id column
completedata = merge( x    = completedata,
                      y    = activitylabels,
                      by.x = "activityid",
                      by.y = "id",
                      all.x  = TRUE,
                      all.y  = FALSE )

completedata = subset( completedata, select = -activityid )

# Save this tidy data to a file
write.table( completedata,
             file = tidydata.full,
             append = FALSE,
             row.names = FALSE)

# Create a separate dataset which contains the mean values for each activity and subject
# First define which will be our identity variables
activitycolums = c( "subjectid", "activitytype" )
meltdata       = melt( completedata, id = activitycolums, measurevars = -activitycolums )
meandata       = dcast( meltdata, activitytype + subjectid ~ variable, mean )

# Save this tidy data to a file
write.table( meandata,
             file = tidydata.mean,
             append = FALSE,
             row.names = FALSE)

# One can verify the result of this melt and dcast with the following function
#
#checkmeanvalue = function( df, si, at, cn ) {
#    mean( subset( df, ( df$subjectid == si ) & ( df$activitytype == at ) )[, cn ] )
#}
#
# By using it eg. like this:
# checkmeanvalue( completedata, 1, "walkingupstairs", "fbodybodygyrojerkmagmean" )
