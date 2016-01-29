
# download the compressed file
filename <- "dataset.zip"
if(!file.exists(filename)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(URL, filename, method="curl")
}
# unzip the file
if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}
# Load activity_labels.txt & features.txt
Activity_Labels <- read.table("../UCI HAR Dataset/activity_labels.txt")
Activity_Labels[,2] <- as.character(Activity_Labels[,2])
Features <- read.table("../UCI HAR Dataset/features.txt")
Features[,2] <- as.character(Features[,2])

# extract data corresponding to only mean & std
Features_reqd <- grep(".*mean.*|.*std.*", Features[,2])
Features_reqd.labels <- Features[Features_reqd,2]
Features_reqd.labels <- gsub("-mean", "_Mean", Features_reqd.labels)
Features_reqd.labels <- gsub("-std", "_STD", Features_reqd.labels)
Features_reqd.labels <- gsub("[-()]", "", Features_reqd.labels)

# loading training data
Train_data <- read.table("../UCI HAR Dataset/train/X_train.txt")[Features_reqd]
train_activities <- read.table("../UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("../UCI HAR Dataset/train/subject_train.txt")
Train <- cbind(train_subjects, train_activities, Train_data)

# loading testing data
Test_data <- read.table("../UCI HAR Dataset/test/X_test.txt")[Features_reqd]
test_activities <- read.table("../UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("../UCI HAR Dataset/test/subject_test.txt")
Test <- cbind(test_subjects, test_activities, Test_data)

# merge train & test data
Data <- rbind(Train, Test)
colnames(Data) <- c("subject", "activity", Features_reqd.labels)

# changing to factor levels
Data$subject <- as.factor(Data$subject)
Data$activity <- factor(Data$activity, levels=Activity_Labels[,1], labels=Activity_Labels[,2])

# reshaping data
library(reshape2)
Data.melted <- melt(Data, id.vars=c("subject", "activity"))
Data.average <- dcast(Data.melted, subject + activity ~ variable, mean)

# writing the tidy data-set
write.table(Data.average, "tidy.txt", row.names=FALSE, quote=FALSE)