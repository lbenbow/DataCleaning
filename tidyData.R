



### Load dplyr package
library(dplyr);


### Read Data

x_test <- read.table("X_test.txt");
y_test <- read.table("y_test.txt");
subj_test <- read.table("subject_test.txt");
x_train <- read.table("X_train.txt");
y_train <- read.table("y_train.txt");
subj_train <- read.table("subject_train.txt");
activity <- read.table("activity_labels.txt");
features <- read.table("features.txt");

### Merge test & train data
# data_test <- cbind(subj_test, y_test, x_test);
# data_train <- cbind(subj_train, y_train, x_train);
data_test <- cbind(y_test, subj_test, x_test);
data_train <- cbind(y_train, subj_train, x_train);
data_combined <- rbind(data_test, data_train);


### Apply features as column names to data_combined
#colnames <- c("subject", "activity", as.character(features$V2));
colnames <- c("activity", "subject", as.character(features$V2));
colnames(data_combined) <- colnames;


### Filter Mean & Std
data_mean_std <- data_combined[, grep("subject|activity|mean|std", colnames(data_combined))];


### Merge/join data on "activity id"
activity_names <- c("id", "activity");
colnames(activity) <- activity_names;
data_merged <- merge(activity, data_mean_std, by.x="id", by.y="activity");


### Drop extra id col
data_merged <- data_merged[,2:ncol(data_merged)];


### Sort data by activity, subject
data_merged <- arrange(data_merged, activity, subject);


### Calculate & Generate Independent meam of data by activity & subject
data_indep_means <- data_merged %>% group_by(activity, subject) %>% summarise_each(funs(mean));

### Write means tidy data file
write.table(data_indep_means, "independent_means.txt", row.name=FALSE)

