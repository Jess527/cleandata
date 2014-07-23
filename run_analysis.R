temp <- tempfile() ##open temporary file to hold downloaded zip file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
dateDownloaded <- date() ##mark date
data <- unzip(temp) ##unzip data file
unlink(temp) ##close link to data url
test <- read.table(data[15]) ##read in test data
test_sub <- read.table(data[14]) ##subject labels for test data
test_act <- read.table(data[16]) ##read activity labels for test data
test_full <- cbind(test_sub,test_act,test) ##add subject & activity labels to test data in 1st & 2nd columns
train <- read.table(data[27]) ##read in train data
train_sub <- read.table(data[26]) ##read subject labels for train data
train_act <- read.table(data[28]) ##read activity labels for train data
train_full <- cbind(train_sub,train_act,train) ##add subject & activity labels to train data in 1st & 2nd columns
full_DF <- rbind(test_full,train_full) ##all data together
sub_order <- full_DF[order(full_DF[,1]),] ##order by subject number
col <- read.table(data[2]) ##column descriptions
meanstd <- grep("mean|std",col[,2]) ##pull out all from col with mean or std in description
meanstd_final <- c(1,2,meanstd+2) ## column numbers to subset out
final_DF <- sub_order[,meanstd_final] ##subset sub_order by columns in colNames
##change column names
colNames <- as.character(col[meanstd,2])
colNames <- gsub("[()]","",colNames) ##removes () from names
colNames <- gsub("(-)","",colNames) ##remove - from names
colNames <- gsub("(m)","M",colNames) ##change to uppercase all M
colNames <- gsub("(s)","S",colNames) ##change to uppercase all S
colnames(final_DF) <- c("subjectID","activityLabel",colNames) ##adds names from colNames vector
##calculate averages for each column by subject & activity
melt_final <- melt(final_DF,id.vars=1:2)
avg_DF <- dcast(melt_final, subjectID + activityLabel ~ variable,mean)
write.table(avg_DF, file="cleandata.txt") ##write resulting dataframe to a text file
