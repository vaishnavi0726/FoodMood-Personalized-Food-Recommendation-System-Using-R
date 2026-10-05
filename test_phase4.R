source("R/preprocess.R")
source("R/recommend.R")

foods <- preprocess_foods()

# Test 1: a normal case
top <- recommend_foods(foods, "Sad", "Veg", "Dinner", 200, 1)
print_top3(top, "Sad", "Veg", "Dinner", 200, 1)

# Test 2: a very low budget (should still give 3 results, with lower scores)
top2 <- recommend_foods(foods, "Happy", "Veg", "Lunch", 10, 3)
print_top3(top2, "Happy", "Veg", "Lunch", 10, 3)
nrow(top2)   # should be 3

# Test 3: the table you will use in Shiny later
top[, c("rank", "food_name", "final_score")]