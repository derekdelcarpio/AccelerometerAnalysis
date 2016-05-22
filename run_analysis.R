
# Merge the training and the test sets to create one data set
features <- read.delim("features.txt", sep="", header=FALSE, col.names=c("id", "feature"), row.names=1)

trainingData <- read.delim("train/X_train.txt", sep="", header=FALSE, col.names=features[,1])
trainingActivity <- read.delim("train/y_train.txt", sep="", header=FALSE, col.names=c("Activity"))
trainingSubject <- read.delim("train/subject_train.txt", sep="", header=FALSE, col.names=c("Subject"))
training <- cbind(trainingData, trainingActivity, trainingSubject)

testingData <- read.delim("test/X_test.txt", sep="", header=FALSE, col.names=features[,1])
testingActivity <- read.delim("test/y_test.txt", sep="", header=FALSE, col.names=c("Activity"))
testingSubject <- read.delim("test/subject_test.txt", sep="", header=FALSE, col.names=c("Subject"))
testing <- cbind(testingData, testingActivity, testingSubject)

full <- rbind(training, testing)


# Extract measurements on the mean and standard deviation for each measurement.
selectColumns <- grepl('-mean\\(\\)$', features[,1]) | grepl('-std\\(\\)$', features[,1])
# Manually add Activity and Subject to selectColumn
selectColumns[562:563] <- TRUE
selectData <- full[, selectColumns]


# Convert Activity to factor and set levels
activities <- read.delim("activity_labels.txt", sep="", header=FALSE, col.names=c("id", "activity"), row.names=1)
selectData$Activity <-as.factor(selectData$Activity)
levels(selectData$Activity) <- activities[,]


# Create independent tidy data set with average of each variable for each activity and each subject.
library(dplyr)
groupSelectData <- group_by(selectData, Activity, Subject)
meanSelectData <- summarise_each(groupSelectData, funs(mean))
