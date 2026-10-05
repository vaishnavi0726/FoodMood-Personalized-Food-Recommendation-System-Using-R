source("R/preprocess.R")
source("R/recommend.R")
source("R/explain.R")

foods <- preprocess_foods()

# Test 1: normal case
top <- recommend_foods(foods, "Sad", "Veg", "Dinner", 200, 1)
print_top3_explained(top, "Sad", "Veg", "Dinner", 200, 1)

# Test 2: over-budget case (explanations should say "above your budget")
top2 <- recommend_foods(foods, "Happy", "Veg", "Lunch", 10, 3)
print_top3_explained(top2, "Happy", "Veg", "Lunch", 10, 3)