# Covid-19 Data Exploration

This repository contains SQL code for exploring and analyzing Covid-19 data. The code utilizes various SQL techniques and functions to extract insights from the dataset. The project focuses on the "COVID-19 dataset" database.

## Features

The project includes the following SQL queries and views:

1. **Query 1: Selecting Non-Null Data, Sorted by Columns**
   - Retrieves all non-null data from the "CovidDeaths$" table, sorted by specific columns.

2. **Query 2: Initial Data Selection**
   - Selects key data points from the "CovidDeaths$" table, providing an overview of location, date, cases, deaths, and population.

3. **Query 3: Percentage of Deaths among Total Cases in Egypt**
   - Calculates the percentage of deaths among total cases in Egypt over time.

4. **Query 4: Percentage of Population Infected with Covid in Egypt**
   - Calculates the percentage of the population infected with Covid in Egypt over time.

5. **Query 5: Countries with the Highest Infection Rate**
   - Identifies countries with the highest infection rate compared to their population.

6. **Query 6: Countries with Highest Death Count per Population**
   - Selects countries with the highest death count per population.

7. **Query 7: Global Covid Statistics by Day**
   - Calculates global Covid statistics, including total cases, total deaths, and death percentage, on a daily basis.

8. **Query 8: Global Covid Statistics**
   - Provides an overall summary of global Covid statistics, including total cases, total deaths, and death percentage.

9. **Query 9: Total Population vs Vaccinations**
   - Analyzes the percentage of the population that received at least one Covid vaccine over time.

10. **Query 10: Using CTE to Perform Calculation on Partitioned Data**
    - Utilizes a Common Table Expression (CTE) to perform calculations on partitioned data.

11. **Query 11: Using Temp Table to Perform Calculation on Partitioned Data**
    - Utilizes a temporary table to perform calculations on partitioned data.

12. **View 1: CovidSummaryStats**
    - View that calculates Covid summary statistics, including total cases, total deaths, and death percentage.

13. **View 2: GlobalCovidStats**
    - View that calculates global Covid statistics, including total cases, total deaths, and death percentage.

14. **View 3: PercentPopulationVaccinated**
    - View that calculates the number of vaccinated people per location over time.

## Usage

The SQL code provided in this repository can be executed against the "SqlCovidProject" database. You may run the queries individually or create and use the views for easier data exploration. Modify the code as needed to fit your specific database environment.

## Requirements

To execute the SQL code, you need access to the "COVID-19 dataset" from https://ourworldindata.org/covid-deaths

## Author

This project was created by Halim.

Feel free to explore and analyze the Covid-19 data using the provided SQL queries and views. If you have any questions or suggestions, please feel free to reach out.
