 install.packages("gapminder")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("shiny")
install.packages("ggcorrplot")

library(gapminder)
library(dplyr)
library(ggplot2)
library(shiny)
library(ggcorrplot)

data <- gapminder
summary(data)

#check for missing values
sum(is.na(data))

#check for duplicate values
duplicates <- data %>%
  group_by(country, year) %>%
  filter(n() > 1)
nrow(duplicates)

str(data)

#checking range of years 
year_range <- range(data$year)
year_range

#calculating worldwide metrics by year 
data_stats <- data %>%
  group_by(year) %>%
  summarise(
    mean_lifeExp = mean(lifeExp),
    sd_lifeExp = sd(lifeExp),
    median_lifeExp = median(lifeExp),
    mean_pop = mean(pop),
    sd_pop = sd(pop),
    median_pop = median(pop),
    mean_gdpPercap = mean(gdpPercap),
    sd_gdpPercap = sd(gdpPercap),
    median_gdpPercap = median(gdpPercap)
  )

#calculate the 1st and 3rd quartiles for gdpPercap and lifeExp
quantiles <- data %>%
  summarise(
    q1_gdpPercap = quantile(gdpPercap, 0.25),
    q3_gdpPercap = quantile(gdpPercap, 0.75),
    q1_lifeExp = quantile(lifeExp, 0.25),
    q3_lifeExp = quantile(lifeExp, 0.75)
  )
quantiles

#comparing life expectancy changes across continents 
continent_lifeExp <- data %>%
  group_by(continent, year) %>%
  summarise(mean_lifeExp = mean(lifeExp))
continent_lifeExp

#comparing GDP per Capita changes across continents
continent_gdpPercap <- data %>%
  group_by(continent, year) %>%
  summarise(mean_gdpPercap = mean(gdpPercap))
continent_gdpPercap

#finding the highest life expectancy and GDP per Capita for each year
highest_lifeExp <- data %>%
  group_by(year) %>%
  filter(gdpPercap == max(gdpPercap)) %>%
  select(year, country, continent, gdpPercap, lifeExp) %>%
  arrange(year)

highest_gdpPercap <- data %>%
  group_by(year) %>%
  filter(lifeExp == max(lifeExp)) %>%
  select(year, country, continent, gdpPercap, lifeExp) %>%
  arrange(year)

#calculating correlation between life expectation and GDP per Capita
correlation <- cor(data$lifeExp, data$gdpPercap, method = 'pearson')
cat("Pearson correlation coefficient between life expectation and GDP per Capita is", correlation)

#ANOVA test to compare GDP per Capita across continents
anova_gdpPercap <- aov(gdpPercap ~ continent, data = data)
summary(anova_gdpPercap)

#filter data for Asia and Europe
asia_gdp <- data %>% filter(continent == "Asia") %>% pull(gdpPercap)
europe_gdp <- data %>% filter(continent == "Europe") %>% pull(gdpPercap)

#perform t-test
t_test_result <- t.test(asia_gdp, europe_gdp)
t_test_result

#1. Trend Analysis 
#Life Expectancy Over Time
ggplot(data, aes(x = year, y = lifeExp, color = continent))+
  geom_line(stat = "summary", fun = mean) +
  labs(title = "Life Expectancy Over Time by Continent", x = "Year", y = "Life Expectancy")

#GDP per Capita Over Time
ggplot(data, aes(x = year, y = gdpPercap, color = continent)) +
  geom_line(stat = "summary", fun = mean) +
  labs(title = "GDP per Capita Over Time", x = "Year", y = "GDP per Capita")

# 2. Correlation Matrix
numeric_data <- data %>% select(lifeExp, gdpPercap, pop)
correlation_matrix <- cor(numeric_data)
print(correlation_matrix)

# Visualize Correlation Matrix
ggcorrplot(correlation_matrix, lab = TRUE)

# 3. Descriptive Statistics
desc_stats <- sapply(data %>% select(lifeExp, gdpPercap, pop), function(x) c(mean=mean(x), sd=sd(x), median=median(x)))
print(desc_stats)

#Data Visualizations

#Boxplot of GDP per Capita by Continent
ggplot(data, aes(x = continent, y = gdpPercap, fill = continent)) +
  geom_boxplot() +
  labs(title = "GDP per Capita by Continent", y = "GDP per Capita", x = "Continent")

#Boxplot of Life Expectancy by Continent
ggplot(data, aes(x = continent, y = lifeExp, fill = continent)) +
  geom_boxplot() +
  labs(title = "Life Expectancy by Continent", y = "Life Expectancy", x = "Continent")

#Scatterplot of Life Expectancy vs GDP per Capita
ggplot(data, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point() +
  labs(title = "Life Expectancy vs GDP per Capita", x = "GDP per Capita", y = "Life Expectancy")


#Filtering and removing outliers
# Calculate IQR for GDP per Capita and Life Expectancy
gdp_iqr <- IQR(data$gdpPercap)
gdp_q1 <- quantile(data$gdpPercap, 0.25)
gdp_q3 <- quantile(data$gdpPercap, 0.75)

lifeExp_iqr <- IQR(data$lifeExp)
lifeExp_q1 <- quantile(data$lifeExp, 0.25)
lifeExp_q3 <- quantile(data$lifeExp, 0.75)

# Filter outliers
filtered_data <- data %>%
  filter(
    gdpPercap > (gdp_q1 - 1.5 * gdp_iqr) & gdpPercap < (gdp_q3 + 1.5 * gdp_iqr),
    lifeExp > (lifeExp_q1 - 1.5 * lifeExp_iqr) & lifeExp < (lifeExp_q3 + 1.5 * lifeExp_iqr)
  )

# Boxplot of GDP per Capita by Continent without outliers
ggplot(filtered_data, aes(x = continent, y = gdpPercap, fill = continent)) +
  geom_boxplot() +
  labs(title = "GDP per Capita by Continent (Without Outliers)", y = "GDP per Capita", x = "Continent")

# Boxplot of Life Expectancy by Continent without outliers
ggplot(filtered_data, aes(x = continent, y = lifeExp, fill = continent)) +
  geom_boxplot() +
  labs(title = "Life Expectancy by Continent (Without Outliers)", y = "Life Expectancy", x = "Continent")

# Scatterplot of Life Expectancy vs GDP per Capita without outliers
ggplot(filtered_data, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point() +
  labs(title = "Life Expectancy vs GDP per Capita (Without Outliers)", x = "GDP per Capita", y = "Life Expectancy")
