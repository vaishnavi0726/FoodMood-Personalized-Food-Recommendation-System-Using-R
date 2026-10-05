# FoodMood: A Personalized Food Recommendation and Analysis System

A mini project in R that recommends the top 3 foods based on the user's
mood, diet, meal time, budget, and spice preference.

## Features
- Cleans and normalizes the food dataset (20 foods)
- Scores every food out of 100 with weighted formula 30/25/15/15/15
- Shows top 3 foods with plain-English explanation
- Four ggplot2 charts
- Interactive Shiny web app with 3 tabs
- 39 Automatic tests - All Passed!

## Requirements
- R 4.0+, RStudio
- Packages: ggplot2, shiny

Install once:
install.packages(c("ggplot2", "shiny"))

## Folder Structure
FoodMood/
├── data/ foods.csv
├── R/ preprocess.R, recommend.R, explain.R, plots.R
├── tests/ run_tests.R
├── output/ 4 PNG charts
├── app.R Shiny app
└── README.md

## How to Run
1. Set working directory to FoodMood folder
2. Run tests: source("tests/run_tests.R")
   Expected: Passed: 39 | Failed: 0
3. Start app: Click Run App button in app.R or shiny::runApp()

## Scoring Formula
final_score = 30 x mood_pts + 25 x meal_pts + 15 x spice_pts + 15 x budget_pts + 15 x health_pts

## Test Evidence
Screenshot: wa_image_5231481088663465635 - 39 PASS, Top 3: Pasta Alfredo 87.1, Paneer 81.8, Hot Chocolate 60

## Author
[Your Name], [Roll No], [College] - Oct 2026