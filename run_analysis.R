url_file<- 
  'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

download.file(url_file,'data.zip')


unzip('data.zip')

#unloading all the features that are in the X-train dataset (the column names to be)
features<- read.table("UCI HAR Dataset/features.txt",col.names=c('number','feature'))

#Reading all the training data and formatting their column headers
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",col.names=features$feature)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

#getting the training data together
training_data<-x_train
training_data<-cbind(y_train,training_data)
training_data<-cbind(subject_train,training_data)
training_data$f<-'training' # to keep track after the merger

#Reading all the test data and formatting their column headers (fully anologous to training)

x_test <- read.table("UCI HAR Dataset/test/X_test.txt",col.names=features$feature)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

#getting the test data together
test_data<-x_test
test_data<-cbind(y_test,test_data)
test_data<-cbind(subject_test,test_data)
test_data$f<-'test' # to keep track after the merger


#Question 1: Merges the training and the test sets to create one data set.
data<-rbind(test_data,training_data)

table(data$f) #sanity check to see whether n_test and n_training are consistent 

library(dplyr)

#?select to grab the right columns/variables 
#features$feature --> to see what mean and standard error is defined as 
#Question 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
data_mean_std<-select(data,contains(c('mean','std')))


colnames(data)<-gsub('^t','Time.',colnames(data))
colnames(data)<-gsub('^f','.Freq',colnames(data))
colnames(data)<-gsub('Acc','acceleration',colnames(data))
colnames(data)<-gsub('Gyro','.gyroscope',colnames(data))
colnames(data)<-gsub('Mag','.magnitude',colnames(data))
colnames(data)<-gsub('Jerk','.jerking',colnames(data))
colnames(data)[564]<-'f'

tidy_data<-data

#question 3 : descriptive activity labels

library(stringi)
activities<- read.table("UCI HAR Dataset/activity_labels.txt",col.names=c('number','activity'))

tidy_data$activity<-gsub(activities$number[1],activities$activity[1],tidy_data$activity)
tidy_data$activity<-gsub(activities$number[2],activities$activity[2],tidy_data$activity)
tidy_data$activity<-gsub(activities$number[3],activities$activity[3],tidy_data$activity)
tidy_data$activity<-gsub(activities$number[4],activities$activity[4],tidy_data$activity)
tidy_data$activity<-gsub(activities$number[5],activities$activity[5],tidy_data$activity)
tidy_data$activity<-gsub(activities$number[6],activities$activity[6],tidy_data$activity)


tidy_data_summary<-tidy_data %>%
  group_by(activity,subject) %>%
  summarise_all(mean)


write.table(tidy_data,'tidy_data.txt')
write.table(tidy_data_summary,'tidy_data_summary.txt',row.names = F)
