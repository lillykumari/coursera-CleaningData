# Getting and Cleaning Data - Course Project

This is the course project for Coursera-Getting and Cleaning Data course.
The R script 'run_analysis.R' performs the following tasks :-

1. Download the compressed file
2. Uncompresses the file
3. Loads activity & features file and gets feature labels corresponding to mean & std
4. Loads train & test data keeping only mean & std values
5. Merges train & test data
6. Converts subject and activity to factors
7. Creates a tidy dataset 'tidy.txt' consisting average value of each variable for each subject & activity pair