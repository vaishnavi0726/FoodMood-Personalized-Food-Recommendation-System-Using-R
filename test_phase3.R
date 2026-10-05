source("R/preprocess.R")
source("R/recommend.R")

foods <- preprocess_foods()

scored <- calculate_scores(foods,
                           mood = "Sad", diet = "Veg", meal = "Dinner",
                           budget = 200, spice_pref = 1)

head(scored[, c("food_name", "final_score")], 5)

# Second test
scored2 <- calculate_scores(foods, "Happy", "Veg", "Lunch", 150, 3)
any(scored2$diet_type == "Non-Veg")   # must be FALSE