# Course Project for Getting and Cleaning Data

This is the final project for the Getting and Cleaning Data Course offered by Johns Hopkins University on Coursera. The purpose of this project was to take an untidy data set contained in multiple files and merge the files together to make one clean, readable, and tidy datasets based on the four tidy principles.


## About the data
The flat files provide data from the accelerometers contained in the Samsung Galaxy S Smartphone. Expirements were carried out with 30 volunteers in a an age range of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II)

## Steps involved in the run_analysis.R Script
1. Download and extract the data set if it doesn't already exist in the workspace
2. Read the features file to a data table and filter features that include mean() and std()
3. Merge the y_test and y_train files with activity labels to give associate activity ids with a activity name
4. Merge the X_test and X_train files with the data tables from the previous step
5. Merge the two data tables from the previous step together to obtain one merged data table
6. Replace the column names for the merged set with the relevant features from step 2
7. Make the column names more descriptive to obtain a tidy data set
8. Summarize the tidy data set to display the mean of every variable grouped by subject and activity
9. Write the summarized set from the previous step to a text file

