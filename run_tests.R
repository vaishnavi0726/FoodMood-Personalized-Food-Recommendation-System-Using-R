source("R/preprocess.R")
source("R/recommend.R")
source("R/explain.R")
source("R/plots.R")

# ---------- A tiny test helper ----------
passed <- 0
failed <- 0

check <- function(name, condition) {
  ok <- isTRUE(condition)
  if (ok) passed <<- passed + 1 else failed <<- failed + 1
  cat(if (ok) "PASS" else "FAIL", "-", name, "\n")
}

# Returns TRUE if the code gives an error (this is what we want for bad input)
gives_error <- function(code) inherits(try(code, silent = TRUE), "try-error")

foods  <- preprocess_foods()
scored <- calculate_scores(foods, "Sad", "Veg", "Dinner", 200, 1)
top    <- get_top_n(scored, 3)

# ================= A. DATA TESTS =================
cat("\n--- A. Data tests ---\n")
check("A1 dataset has 20 rows",             nrow(foods) == 20)
check("A2 no missing values",               sum(is.na(foods)) == 0)
check("A3 normalized columns are 0 to 1",
      all(foods$calories_norm >= 0 & foods$calories_norm <= 1 &
            foods$price_norm >= 0 & foods$price_norm <= 1 &
            foods$health_score_norm >= 0 & foods$health_score_norm <= 1))
check("A4 min_max gives 0, 0.5, 1",
      isTRUE(all.equal(min_max(c(40, 130, 220)), c(0, 0.5, 1))))
check("A5 min_max of equal numbers gives 0.5",
      all(min_max(c(7, 7, 7)) == 0.5))

# Messy data test
messy <- load_foods()
messy$calories[3]    <- NA
messy$food_name[5]   <- "  Idli Sambar "
messy$spice_level[2] <- 9
cleaned <- clean_foods(messy)
check("A6 missing value is filled",         sum(is.na(cleaned$calories)) == 0)
check("A7 duplicate food is removed",       nrow(cleaned) == 19)
check("A8 invalid spice is fixed to max 5", max(cleaned$spice_level) == 5)

# ================= B. RECOMMENDATION TESTS =================
cat("\n--- B. Recommendation tests ---\n")
check("B1 top 3 for Sad/Veg/Dinner is correct",
      identical(top$food_name,
                c("Pasta Alfredo", "Paneer Butter Masala", "Hot Chocolate")))
check("B2 top score is 87.1",
      isTRUE(all.equal(top$final_score[1], 87.1)))
check("B3 Veg user sees no Non-Veg food",
      !any(scored$diet_type == "Non-Veg"))

nv <- recommend_foods(foods, "Happy", "Non-Veg", "Lunch", 200, 4)
check("B4 Non-Veg user can get Non-Veg food (Fish Curry Meal, 93.6)",
      nv$food_name[1] == "Fish Curry Meal" &&
        isTRUE(all.equal(nv$final_score[1], 93.6)))

check("B5 all scores are between 0 and 100",
      all(scored$final_score >= 0 & scored$final_score <= 100))
check("B6 scores are sorted high to low",
      !is.unsorted(rev(scored$final_score)))
check("B7 tie-break: cheaper Hot Chocolate before Chocolate Brownie",
      which(scored$food_name == "Hot Chocolate") <
        which(scored$food_name == "Chocolate Brownie"))
check("B8 ranks are 1, 2, 3",               identical(top$rank, 1:3))

low <- recommend_foods(foods, "Happy", "Veg", "Lunch", 10, 3)
check("B9 very low budget still gives 3 foods", nrow(low) == 3)

check("B10 fewer than 3 foods returns what is available",
      nrow(get_top_n(scored[1:2, ], 3)) == 2)
check("B11 empty result returns 0 rows",
      nrow(get_top_n(scored[0, ], 3)) == 0)

# ================= C. EDGE-CASE TESTS (bad input) =================
cat("\n--- C. Edge-case tests ---\n")
check("C1 unknown mood gives an error",
      gives_error(calculate_scores(foods, "Angry", "Veg", "Lunch", 100, 2)))
check("C2 unknown diet gives an error",
      gives_error(calculate_scores(foods, "Happy", "Vegan", "Lunch", 100, 2)))
check("C3 unknown meal gives an error",
      gives_error(calculate_scores(foods, "Happy", "Veg", "Brunch", 100, 2)))
check("C4 negative budget gives an error",
      gives_error(calculate_scores(foods, "Happy", "Veg", "Lunch", -50, 2)))
check("C5 spice above 5 gives an error",
      gives_error(calculate_scores(foods, "Happy", "Veg", "Lunch", 100, 9)))
check("C6 budget given as text gives an error",
      gives_error(calculate_scores(foods, "Happy", "Veg", "Lunch", "cheap", 2)))

# ================= D. EXPLANATION TESTS =================
cat("\n--- D. Explanation tests ---\n")
ex <- explain_top3(top, "Sad", "Dinner", 200, 1)
check("D1 one explanation per food",         length(ex) == 3)
check("D2 explanation mentions the mood",    grepl("Sad mood", ex[1]))
check("D3 says 'within your budget' when affordable",
      grepl("within your budget", ex[1]))

ex_low <- explain_top3(low, "Happy", "Lunch", 10, 3)
check("D4 says 'above your budget' when too expensive",
      grepl("above your budget", ex_low[1]))
check("D5 empty input gives empty explanation",
      length(explain_top3(scored[0, ], "Sad", "Dinner", 200, 1)) == 0)

# ================= E. PLOT TESTS =================
cat("\n--- E. Plot tests ---\n")
check("E1 top 3 chart is a ggplot",          inherits(plot_top3_scores(top), "ggplot"))
check("E2 breakdown chart is a ggplot",      inherits(plot_score_breakdown(top), "ggplot"))
check("E3 price vs health chart is a ggplot",
      inherits(plot_price_vs_health(foods, top$food_name), "ggplot"))
check("E4 mood count chart is a ggplot",     inherits(plot_mood_counts(foods), "ggplot"))

tmp <- tempfile()
save_all_plots(foods, top, tmp)
check("E5 four PNG files are saved",         length(list.files(tmp, pattern = "png$")) == 4)

# ================= F. MORE FULL-PIPELINE CASES =================
cat("\n--- F. Full pipeline cases ---\n")
cases <- list(
  list(mood = "Tired",     diet = "Veg",     meal = "Breakfast", budget = 100, spice = 1,
       first = "Oats Porridge", score = 97.9),
  list(mood = "Stressed",  diet = "Veg",     meal = "Snack",     budget = 100, spice = 1,
       first = "Tomato Soup",   score = 95.7),
  list(mood = "Energetic", diet = "Non-Veg", meal = "Breakfast", budget = 100, spice = 2,
       first = "Egg Omelette",  score = 93.6),
  list(mood = "Happy",     diet = "Veg",     meal = "Lunch",     budget = 10,  spice = 3,
       first = "Chole Bhature", score = 66.2)
)

for (cs in cases) {
  r <- recommend_foods(foods, cs$mood, cs$diet, cs$meal, cs$budget, cs$spice)
  check(paste("F:", cs$mood, "/", cs$diet, "/", cs$meal, "->", cs$first),
        r$food_name[1] == cs$first &&
          isTRUE(all.equal(r$final_score[1], cs$score)))
}

# ================= SUMMARY =================
cat("\n=============================\n")
cat(sprintf("Passed: %d | Failed: %d | Total: %d\n", passed, failed, passed + failed))
if (failed == 0) cat("All tests passed!\n") else cat("Some tests failed. Check the FAIL lines above.\n")