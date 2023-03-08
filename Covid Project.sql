select *
from PortfolioProject..CovidDeaths
order by 3,4


select *
from PortfolioProject..CovidVaccinations
order by 3,4
 
-- Data to initiate my project

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2


-- This shows likelihood(Percentage Rate) of dying if you contract covid in my native country, Ghana on a particular date

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%Ghana%'
and continent is not null 

-- Percentage Death rate in my country of residence, United States
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where Location like '%United States%'
and continent is not null

-- Shows total cases against the population and percentage population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc



--Contintents with the highest death count per population

Select Continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc



-- NUMBERS AROUND THE GLOBE CONCERNING NEW DEATHS AND NEW CASES

Select SUM(new_cases) as newtotal_cases, SUM(cast(new_deaths as int)) as newtotal_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


select *
from CovidVaccinations

-- Using CTE to perform Calculation(PercentagePopulationVaccinated) on Partition By in previous query

With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentagePopulationVaccinated
From PopVsVac