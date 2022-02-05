
select *
from PortfolioProject..vacc4
order by 1,4

-- Looking at total cases vs total deaths in Sweden

select location, date, total_cases, total_deaths, (total_deaths/total_cases) as Death_Ratio
from PortfolioProject..death3
where location like '%sweden%'
order by 1,2

-- Looking at total cases vs population
-- Shows percentage of population who has been infected by covid

select location, date, total_cases, population, (total_cases/population)*100 as Percentage_infected
from PortfolioProject..death3
where location like '%sweden%'
order by 1,2

-- Looking at total cases vs population
-- Shows percentage of population who has been infected by covid

select location, date, total_cases, population, (total_cases/population)*100 as Percentage_infected
from PortfolioProject..death3
where location like '%sweden%'
order by 1,2

-- Looking at coubtries with highest infection rates compared to population

select location, population,  MAX(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as Percentage_infected
from PortfolioProject..death3
Where continent is not null
group by location, population
order by 4 desc

-- Looking at countries with highest death rates compared to population

select location, population,  MAX(total_deaths) as total_death_count, max(total_cases/population)*100 as Percentage_infected
from PortfolioProject..death3
Where continent is not null
group by location, population
order by 3 desc

-- Looking at continents with highest death rates compared to population

select location,  MAX(total_deaths) as total_death_count
from PortfolioProject..death3
Where continent is null
group by location

-- GLOBAL

select SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 as DeathPercentage
From PortfolioProject..death3
where continent is not null
order by 1,2

-- Looking at total population vs percentage vaccinated

with popvsvacc (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
from PortfolioProject..death3 dea
JOIN PortfolioProject..vacc4 vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select *, (RollingPeopleVaccinated/population)*100
from popvsvacc

-- Temp Tables

create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

drop table if exists #PercentPopulationVaccinated
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
from PortfolioProject..death3 dea
JOIN PortfolioProject..vacc4 vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

-- Creating views to store data for later visualizations

create view PercentPopulationVaccinatedView as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
from PortfolioProject..death3 dea
JOIN PortfolioProject..vacc4 vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3