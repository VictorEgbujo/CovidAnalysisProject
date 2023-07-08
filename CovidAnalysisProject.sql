/* CovidDeaths Breakdowns */

select *
from MyPortfolioProject..CovidDeaths
where continent is not null
order by 3,4


select location, date, total_cases, total_deaths, new_cases, population
from MyPortfolioProject..CovidDeaths
where continent is not null
order by 1,2

/* Searching for Total cases vs total death
showing percentage of people that are likely to die after contacting covid */

select *
from MyPortfolioProject..CovidDeaths
order by 3,4


select location, date, total_cases, total_deaths, (cast (total_deaths as numeric))/ (cast (total_cases as numeric)) *100 DeathPercentage
from MyPortfolioProject..CovidDeaths
where location like '%state%'
and continent is not null
order by 1,2


select location, date, total_cases, total_deaths, (cast (total_deaths as numeric))/ (cast (total_cases as numeric))*100 DeathPercentage
from MyPortfolioProject..CovidDeaths
where location like '%Nigeria%'
and continent is not null
order by 1,2


/* Searching for Total cases vs population
showing percentage of people that contacted covid */

select location, date, total_cases, population, (total_cases/population)*100 DeathPercentage
from MyPortfolioProject..CovidDeaths
where location like '%Nigeria%'
and continent is not null
order by 1,2


select location, date, total_cases, population, (total_cases/population)*100 DeathPercentage
from MyPortfolioProject..CovidDeaths
where location like '%South%'
and continent is not null
order by 1,2


/* Showing countries with highest covid cases compared to population */

select location, population, max(total_cases) as HighestinfectedCounts,  max(total_cases/population)*100 PercentagePopulationinfected
from MyPortfolioProject..CovidDeaths
where continent is not null
Group by location, population
order by PercentagePopulationinfected desc

/* Showing countries with highest death covid cases per population */

select location,  max(cast(total_deaths as int)) AS TotalDeathCount
from MyPortfolioProject..CovidDeaths
where continent is not null
Group by location
order by TotalDeathCount desc


/* Breaking things down by continent */

select continent,  max(cast(total_deaths as int)) AS TotalDeathCount
from MyPortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

/* Global Numbers */

select sum(new_cases) as Total_cases, sum(cast (new_deaths as int)) as total_deaths
, sum(cast (new_deaths as int))/ sum(new_cases) *100 DeathPercentage
from MyPortfolioProject..CovidDeaths
--where location like '%state%'
where continent is not null
order by 1,2


/* Covidvaccinations Breakdowns */

select *
from  MyPortfolioProject..CovidVaccinations
order by 1,2

/* Looking for total vaccinations vs population */

select *
from  MyPortfolioProject..CovidDeaths Dea
JOIN  MyPortfolioProject..CovidVaccinations Vac
ON Dea.location=vac.location
and dea.date=vac.date


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from  MyPortfolioProject..CovidDeaths Dea
JOIN  MyPortfolioProject..CovidVaccinations Vac
ON Dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 1,2


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, 
dea.date) as RollingpeopleVaccinated
from  MyPortfolioProject..CovidDeaths Dea
JOIN  MyPortfolioProject..CovidVaccinations Vac
ON Dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3



/* USING CTE */

WITH PopvsVac (Continent, location, Date, Population, new_vaccinations, RollingpeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, 
dea.date) as RollingpeopleVaccinated
from  MyPortfolioProject..CovidDeaths Dea
JOIN  MyPortfolioProject..CovidVaccinations Vac
ON Dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
)

select*, (RollingpeopleVaccinated/Population)*100
from PopvsVac


/* Temp Table */

Create table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingpeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, 
dea.date) as RollingpeopleVaccinated
from  MyPortfolioProject..CovidDeaths Dea
JOIN  MyPortfolioProject..CovidVaccinations Vac
ON Dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

select*, (RollingpeopleVaccinated/Population)*100
from #PercentPopulationVaccinated




Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingpeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, 
dea.date) as RollingpeopleVaccinated
from  MyPortfolioProject..CovidDeaths Dea
JOIN  MyPortfolioProject..CovidVaccinations Vac
ON Dea.location=vac.location
and dea.date=vac.date

select*, (RollingpeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


/*  Creating views to store data for visualization */

Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, 
dea.date) as RollingpeopleVaccinated
from  MyPortfolioProject..CovidDeaths Dea
JOIN  MyPortfolioProject..CovidVaccinations Vac
ON Dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null


select *
from  PercentPopulationVaccinated