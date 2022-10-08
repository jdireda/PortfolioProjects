--Total Covid Cases, Total Covid Deaths, Percentage of Covid Cases that were Covid Deaths in the US by Date

SELECT	Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location = 'United States'
ORDER BY 1,2

-- Looking at total cases compared to location

SELECT Location, date, total_cases, population, (total_cases/population)*100 as PopulationPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location = 'United States'
ORDER BY 1,2

-- Looking at highest infection rates compared to population
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)*100) as PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentagePopulationInfected desc 

--Looking at highest death rates
SELECT Location, MAX(Population) as HighestPopulation, MAX(total_cases) as TotalInfectionCount, MAX(cast(total_deaths as int)) as TotalDeathCount, (MAX(cast(total_deaths as int))/MAX(total_cases)) *100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY Location, Population
ORDER BY DeathPercentage desc 

--Death rates per continent
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc 

--Global Numbers
SELECT SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases)) *100 as TotalDeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
Order by 1,2


--Looking at total population vs vaccinations

	-- USE CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.people_vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccines vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (New_Vaccinations/Population)*100 as PercentVaccinated
From PopvsVac
Order by 2,3