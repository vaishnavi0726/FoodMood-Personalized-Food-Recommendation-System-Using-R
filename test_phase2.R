source("R/preprocess.R")

foods <- preprocess_foods()

str(foods) # check column types
dim(foods) # should be 20 rows, 18 columns
sum(is.na(foods)) # should be 0
summary(foods$calories_norm) # min should be 0, max should be 1
table(foods$diet_type) # count of Veg and Non-Veg