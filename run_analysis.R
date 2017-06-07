
#You should create one R script called run_analysis.R that does the following.

## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement.
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names.
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Notes from ReadMe
        ## 6 activities 
        ## 30 participants
        ## Dataset was partitioned into 2 sets (train @ 70%, and test @ 30%)
        ## The Features were derived from the raw signals, the features are
                ##tBodyAcc-XYZ
                ##tGravityAcc-XYZ
                ##tBodyAccJerk-XYZ
                ##tBodyGyro-XYZ
                ##tBodyGyroJerk-XYZ
                ##tBodyAccMag
                ##tGravityAccMag
                ##tBodyAccJerkMag
                ##tBodyGyroMag
                ##tBodyGyroJerkMag
                ##fBodyAcc-XYZ
                ##fBodyAccJerk-XYZ
                ##fBodyGyro-XYZ
                ##fBodyAccMag
                ##fBodyAccJerkMag
                ##fBodyGyroMag
                ##fBodyGyroJerkMag
        ## For each observation we have 
                ## Triaxial acc'n from accelerometer (total acc'n)
                ## Estimated body acc'n
                ## Triaxial angular velocity from gyroscope
                ## feature vector, as derived above, time and frequency domain variables
                ## activity label (of the six monitored)
                ## an identifier for the subject

# Packages Required
        library(data.table)
        library(dplyr)
        library(stringr)
        library(Hmisc)

# Step 1 - Merge Training and Test data sets to create one data set
## Piece together training data
        ## Training Set - activity label
        activity_data_train <- read.table("./train/y_train.txt")

        class(activity_data_train)                      # data frame
        dim(activity_data_train)                        # 7352 records of one variable (activity number)

        colnames(activity_data_train)[1] <- "activity"  # renaming the column to 'activity'

        ## Training set - feature vector
        feature_data_train <- read.table("./train/X_train.txt")

        class(feature_data_train)                       # data frame
        dim(feature_data_train)                         # 7352 records of 561 variables ("v1" - "v561")

        ## Training set - subject
        subject_train <- read.table("./train/subject_train.txt")

        class(subject_train)                            # data frame
        dim(subject_train)                              # 7352 records (subject number 1-30) of 1 variable
  
        colnames(subject_train)[1] <- "subject number"  # rename variable to 'subject number'


        
        ## Bind columns of activity, subject, feature vector to create Train Data set

        training_data <- cbind(subject_train, activity_data_train, feature_data_train)
        dim(training_data)                              # 7352 rows with 563 columns
        

## Piece together Test Data
        ## Test set - activity label
        activity_data_test <- read.table("./test/y_test.txt")

        class(activity_data_test)                      # data frame
        dim(activity_data_test)                        # 2947 records of one variable (activity number)

        colnames(activity_data_test)[1] <- "activity"  # renaming the column to 'activity'

        ## Test set - feature vector
        feature_data_test <- read.table("./test/X_test.txt")

        class(feature_data_test)                       # data frame
        dim(feature_data_test)                         # 2947 records of 561 variables ("v1" - "v561")

        ## Test set - subject
        subject_test <- read.table("./test/subject_test.txt")

        class(subject_test)                            # data frame
        dim(subject_test)                              # 7352 records (subject number 1-30) of 1 variable

        colnames(subject_test)[1] <- "subject number"  # rename variable to 'subject number'



        ## Bind columns of activity, subject, feature vector to create Test Data set

        test_data <- cbind(subject_test, activity_data_test, feature_data_test)
        dim(test_data)                                  # 2947 rows and 563 columns


## Bind Train and Test Data
        dataset_merged <- rbind(training_data, test_data)
        dim(dataset_merged)                             # 10299 rows and 563 columns
        names(dataset_merged)
        
# Step 2 - Extract only the mean and standard deviation for each measurement
        ## Read in Features
        features <- read.table("./features.txt")
        dim(features)                                   # 561 rows with 2 columns ("v1" and "v2")
        
        ## Define as column names for Dataset
        feature_names <- as.vector(features$V2)                                 # create feature names as a vector
        identifier_names <- c("subject number", "activity")                     # create identifiers (subject number and activity number) as a vector
        all_colnames <- append(feature_names, identifier_names, after = 0)      # append identifiers and feature names 
        colnames(dataset_merged) <- all_colnames                                # set column names in dataset
        valid_column_names <- make.names(names=names(dataset_merged), unique=TRUE, allow_ = TRUE)       # Validate column names
        names(dataset_merged) <- valid_column_names
        
        ## Search and retain Mean and Standard deviation columns
        relevant_features <- grep("mean()|std()", names(dataset_merged))                ## Define the values which contain Mean and Std. Searching for mean or std
        relevant_columns <- as.vector(append(relevant_features, c(1, 2), after = 0))    ## Preserve the identifier columns
        summary_dataset_merged <- select(dataset_merged, relevant_columns)              ## Subset the data set using dplyr (select)
        dim(summary_dataset_merged)
        
# Step 3 - Use descriptive activity names to name the activities in the dataset (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
        activity_labels <- read.table("./activity_labels.txt")                                                          ## Load the activity labels
        labeled_dataset_merged <- merge(activity_labels, summary_dataset_merged, by.x = "V1", by.y = "activity")        ## merge tables by activity/factor level
        colnames(labeled_dataset_merged)[2] <- "activity"                                                               ## reinstate activity as column name
        labeled_dataset_merged <- select(labeled_dataset_merged, -V1)                                                   ## remove V1 key column 
        
# Step 4 - appropriately label the dataset with descriptive variable names
        # Variables already named in Step 2 
        names(labeled_dataset_merged)
        
# Step 5 - create a second, independent tidy data set with the average of each variable for each activity and each subjecy
        # Group data first
        grouped_labeled_dataset <- group_by(labeled_dataset_merged, activity, subject.number)
        
        # use summarize_each function?
        summary_dataset <- summarize_each(grouped_labeled_dataset, funs(mean))
        tail(summary_dataset)

