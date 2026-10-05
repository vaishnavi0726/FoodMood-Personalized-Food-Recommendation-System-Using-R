# FoodMoodO – Personalized Food Recommendation System Using R

A rule-based Personalized Food Recommender built in **R & Shiny** – No ML/DL.
**Logic:** Mood + Diet + Meal + Budget + Spice = Top 3 Foods with WHY

## 📌 Overview
FoodMood helps users get personalized food suggestions based on their current mood (Happy / Sad / Stressed / Energetic), diet preference (Veg / Non-Veg), meal time (Breakfast/Lunch/Dinner/Snack), budget (Rs 50-300) and spice level. It explains WHY each food is recommended using transparent scoring.

## 🚀 Features
- **Smart Input Panel:** Mood, Diet Type, Meal Time, Budget Slider, Spice Level (1-5)
- **Dashboard KPIs:** #1 Top Score /100, Budget & Diet Summary, Mood Selected
- **Top 3 Recommendations:** Ranked foods with WHY logic (Mood Match + Meal Match + Budget + Spice)
- **Scoring Formula (Heart of Project):** Mood=30 + Meal=25 + Spice=15 + Budget=15 + Health=15 = 100
- **Visual Analysis:** Bar Chart (Top Scores), Stacked Chart (Mood vs Category), Budget vs Health
- **Full Food Data View:** DT Table with Food Name, Best Mood, Meal, Price, Spice, Health Score
- **How Scoring Works Tab:** Complete rule documentation
- **Downloads:** Export recommendations as CSV & PDF

## 🛠️ Tech Stack
- R, Shiny, DT, ggplot2, dplyr
- Core R Concepts: `data.frame()`, `filter()`, `arrange()`, `sum()`, `mean()`, `class()`, `levels()`, `write.csv()`

## 🧠 Rule Logic
```R
Score = (Mood Match * 30) + (Meal Match * 25) + 
        ((1 - abs(food_spice - user_spice)/4) * 15) + 
        (Budget Check * 15) + (Health Score/10 * 15)
