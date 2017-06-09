ReadMe for run_analysis.R

This is a description of how the R script works. It follows the 5 basic steps as set out in the assignment.
	1. Merges the training and test sets to create one data set.
	2. Extracts only the measurements on the mean and standard deviation for each measurement.
	3. uses descriptive activity names to name the activities in the dataset.
	4. Appropriately labels the dataset with descriptive variable names.
	5. From the dataset in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

This document will walk through the steps within each of those 5 steps, and largely replicates the annotations made within the script itself.

Prior to starting, 4 packages are called upon to be loaded;
	data.table
	dplyr
	stringr
	Hmisc

In addition, given the relationships set out within the calls to a particular directory, the working directory must be set to the 'UCI HAR Dataset' folder with its contents unaltered.

STEP 1
- First we handle the training datasets.
	Using read.table function we open the 'activity label', 'feature vector', and 'subject' data and store as individual data frames within R.
- Then we can combine the three data frames, by column, using the 'cbind' function. All three have columns of length 7352.
	Store this combined dataset as the training dataset.

- Secondly we move onto the test datasets.
	Also using read.table function we open 'activity label', 'feature vector', and 'subject' data sets and store them as individual data frames within R.
- Then we can again combine all three, as above, using the 'cbind' function.
	Store this combined dataset as the test dataset.

- Thirdly we can combine the training and test datasets.
	This time we use rbind given both have equal number of columns, with the same variable (and names)
	Store the resulting data frame as the merged dataset required in stage 1. Note that the first two columns refer to the activity (1-6) and the subject (1-30), after that, all columns refer to variables.

STEP 2
- In order to extract mean and standard deviation, we need to apply variable names and identify those that refer to standard deviation and mean

- Firstly, read in the features table, using read.table function again and store as a features data frame

- Secondly, we need to create a vector of all the variable names so that we can apply this to the merged dataset.
	Call the features d.f. from above and make the column stipulating the variable names a vector, using as.vector
	Define a vector to name the first two columns, being activity label, and subject. 
	Comine the features vector and the vector denoting the names of the activity and subject column using append function.
	Assign this new vector to be the variable names of the dataset using the 'colnames' function.

- Now we have named variables, we need to idenfity those that are relevant (standard deviation and mean)
	Use the grep function to identify which elements of the dataset names refer to standard deviation (std) and mean (mean)
	Store the resulting numeric vector 
	Now, using the select function in dplyr, only retain those columns identified in the numeric vector just identified.
	At this point we have a dataset which only retains the relevant variables, completing STEP 2. Call this summary_dataset_merged.

STEP 3
- Descriptive activity names had been provided as part of the dataset, namely the activity labels file.
	Read in this table, using the read.table function as before.
	The merge function can be used to combine the activity names with the activity labels set out in summary_dataset_merged.
	After this the redundant activity number column can be removed from the resulting dataset, given we now have the names. This can be done using the select function (-)
	Now we have a dataset with descriptive activity names and only the relevant variables. Call this labeled_dataset_merged.

STEP 4
- Now we need to clean up the variable names so that they can be understood by anyone non familiar with the experiment.
	We apply a pipe to the labeled_dataset_merged to substitute out certain aspects of the current variable names.
	Using a pipe, multiple substitutions can be carried out.
	Now ensure that the resulting data frame is reassigned to 'labeled_dataset_merged'
	This is the dataframe requested in step 4

STEP 5
Now we want to create a second dataset summarising the first. This can be done with the group_by and the summarize_each functions.
	First we want to group the data by the activity label and the subject number involved. This will feed into the summarize function afterwards.
	Now, we simply use the summarize_each function, stipulating the function to be taking the mean, on the labeled_dataset_merged data frame.
	Rename this data set to summary_dataset.

COMPLETE
	

