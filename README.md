# Introduction
This repository contains an analysis in R, of global trends in life expectancy and GDP using the Gapminder dataset. The analysis explores data across different continents and over time, providing insights into worldwide metrics.

## Tools Used
- R
- R Packages: `gapminder`, `dplyr`, `ggplot2`, `shiny`, `ggcorrplot`
-RMarkdown

## Instructions
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/AudreyNeoh/Gapminder-Analysis-in-R.git
   ```
2. **Install Required Packages:**
   Open R and run the following commands to install necessary packages:
   ```r
   install.packages("gapminder")
   install.packages("dplyr")
   install.packages("ggplot2")
   install.packages("ggcorrplot")
   ```
3. **Run the Analysis:**
   - Use `gapminder_markdown.Rmd` for a detailed R Markdown report.
   - Use `analysis_code.R` for direct analysis scripts.

## Conclusions
- Life expectancy and GDP per Capita has generally increased over time across all continents.
- There is a positive correlation between GDP per Capita and life expectancy.
- Europe and Oceania tend to have higher GDP per Capita, while Europe also shows higher life expectancy.

## Sources
- The Gapminder dataset: https://www.gapminder.org/data/
