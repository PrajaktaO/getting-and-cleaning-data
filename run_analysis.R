#set the directory
setwd("C:/Users/HP/getting-and-cleaning-data")
getwd()
#read the data
test.labels <- read.table("C:/Users/HP/Desktop/coursera_project/getting and cleaning data/UCI HAR Dataset/test/y_test.txt", col.names="label")
test.subjects <- read.table("C:/Users/HP/Desktop/coursera_project/getting and cleaning data/UCI HAR Dataset/test/subject_test.txt", col.names="subject")
test.dataset <- read.table("C:/Users/HP/Desktop/coursera_project/getting and cleaning data/UCI HAR Dataset/test/X_test.txt")
train.labels <- read.table("C:/Users/HP/Desktop/coursera_project/getting and cleaning data/UCI HAR Dataset/train/y_train.txt", col.names="label")
train.subjects <- read.table("C:/Users/HP/Desktop/coursera_project/getting and cleaning data/UCI HAR Dataset/train/subject_train.txt", col.names="subject")
train.dataset <- read.table("C:/Users/HP/Desktop/coursera_project/getting and cleaning data/UCI HAR Dataset/train/X_train.txt")
#merge training and test data
merge.data <- rbind(cbind(test.subjects, test.labels, test.dataset),
              cbind(train.subjects, train.labels, train.dataset))
#read features data and selecting only data with mean and std
features <- read.table("C:/Users/HP/Desktop/coursera_project/getting and cleaning data/UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
features.meanstd <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]
merge.data.meanstd <- merge.data[, c(1, 2, features.meanstd$V1+2)]
#read lables from activity_lables 
labels <- read.table("C:/Users/HP/Desktop/coursera_project/getting and cleaning data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)
# replace labels in data with label names
merge.data.meanstd$label <- labels[merge.data.meanstd$label, 2]
# make a list of the current column names and feature names
good.colnames <- c("subject", "label", features.meanstd$V2)
# then tidy that list by removing every non-alphabetic character and converting to lowercase
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))
# then use the list as column names for data
colnames(merge.data.meanstd) <- good.colnames
#sorting data by subject id
merge.data.meanstd <-merge.data.meanstd[order(merge.data.meanstd$subject),]
write.table(format(merge.data.meanstd, scientific=T), "tidy1.txt",
            row.names=F, col.names=F, quote=2)

# find the mean for each combination of subject and label
aggr.data <- aggregate(merge.data.meanstd[, 3:ncol(merge.data.meanstd)], by=list(subject = merge.data.meanstd$subject, 
                       label = merge.data.meanstd$label), mean)
#sorting data by subject id
aggr.data <-aggr.data[order(aggr.data$subject),]
write.table(format(aggr.data, scientific=T), "tidy2.txt",
            row.names=F, col.names=F, quote=2)

