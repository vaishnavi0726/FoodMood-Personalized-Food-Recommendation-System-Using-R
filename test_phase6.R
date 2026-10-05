source("R/preprocess.R")
source("R/recommend.R")
source("R/explain.R")
source("R/plots.R")

foods <- preprocess_foods()
top <- recommend_foods(foods, "Sad", "Veg", "Dinner", 200, 1)

# Show each chart in the RStudio Plots pane
print(plot_top3_scores(top))
print(plot_score_breakdown(top))
print(plot_price_vs_health(foods, top$food_name))
print(plot_mood_counts(foods))

# Save all four as PNG files
save_all_plots(foods, top)
list.files("output")   # should show 4 PNG files