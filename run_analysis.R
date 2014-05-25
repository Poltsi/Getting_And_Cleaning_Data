## This script takes the dataset from
####################################################################################
## Variables
data.url   = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip.file   = "UCI_HAR_Dataset.zip"
zip.dir    = "UCI HAR Dataset"
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

# First read in the feature data so that we know the headers, clean
# it up

# Read the 
