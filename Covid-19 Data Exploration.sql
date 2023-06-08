/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
Author: Halim
*/

-- Select all data where the continent is not null, sorted by the third and fourth columns
SELECT *
FROM SqlCovidProject..CovidDeaths$
WHERE continent IS NOT NULL 
ORDER BY 3, 4;


-- Select the initial data we are starting with: location, date, total cases, new cases, total deaths, and population
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM SqlCovidProject..CovidDeaths$
WHERE continent IS NOT NULL 
ORDER BY 1, 2;


-- Calculate the percentage of deaths among total cases in Egypt over time
SELECT Location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS DeathPercentage
FROM SqlCovidProject..CovidDeaths$
WHERE location LIKE '%Egypt%'
AND continent IS NOT NULL 
ORDER BY 1, 2;


-- Calculate the percentage of population infected with Covid in Egypt over time
SELECT Location, date, Population, total_cases,  (total_cases / population) * 100 AS PercentPopulationInfected
FROM SqlCovidProject..CovidDeaths$
WHERE location LIKE '%Egypt%'
ORDER BY 1, 2;


-- Identify countries with the highest infection rate compared to their population
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases / population)) * 100 AS PercentPopulationInfected
FROM SqlCovidProject..CovidDeaths$
--WHERE location LIKE '%Egypt%'	
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;
	

-- Countries with Highest Death Count per Population
SELECT Location, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM SqlCovidProject..CovidDeaths$
WHERE continent IS NOT NULL 
GROUP BY Location
ORDER BY TotalDeathCount DESC;




----														GLOBAL NUMBERS														----

-- Total cases, total deaths, and death percentage globally for each day
SELECT date, SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths, 
    (SUM(CAST(new_deaths AS INT)) / NULLIF(SUM(new_cases), 0)) * 100 AS Death_Percentage
FROM SqlCovidProject..CovidDeaths$
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY date;

-- Total cases, total deaths, and death percentage globally
SELECT  SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths, 
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS Death_Percentage
FROM SqlCovidProject..CovidDeaths$
WHERE continent IS NOT NULL;




----														Total Population vs Vaccinations														----

-- Percentage of population that received at least one Covid vaccine
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations as New_Vaccinations_Per_Day,
    SUM(CONVERT(FLOAT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS Rolling_People_Vaccinated
    --, (RollingPeopleVaccinated / population) * 100
FROM SqlCovidProject..CovidDeaths$ dea
JOIN SqlCovidProject..CovidVaccinations$ vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--AND dea.location LIKE '%Egypt%'
ORDER BY 2, 3;



-- Using CTE to perform calculation on partitioned data
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated) AS
(
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
        SUM(CONVERT(FLOAT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS Rolling_People_Vaccinated
    FROM SqlCovidProject..CovidDeaths$ dea
    JOIN SqlCovidProject..CovidVaccinations$ vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, (Rolling_People_Vaccinated / Population) * 100  AS Percentage_Of_People_Vaccinated
FROM PopvsVac
ORDER BY PopvsVac.Location ,PopvsVac.Date;



-- Using temp table to perform calculation on partitioned data
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From SqlCovidProject..CovidDeaths$ dea
Join SqlCovidProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




----														Creating a view to store data for later visualizations														----

-- View to calculate CovidSummaryStats for total cases, total deaths, and death percentage
CREATE VIEW CovidSummaryStats AS
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths, 
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS Death_Percentage
FROM SqlCovidProject..CovidDeaths$
WHERE continent IS NOT NULL;


-- View to calculate global Covid statistics
CREATE VIEW GlobalCovidStats AS
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths, 
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS Death_Percentage
FROM SqlCovidProject..CovidDeaths$
WHERE continent IS NOT NULL;


-- View to calculate the number of vaccinated people per location
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
    SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM SqlCovidProject..CovidDeaths$ dea
JOIN SqlCovidProject..CovidVaccinations$ vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;


