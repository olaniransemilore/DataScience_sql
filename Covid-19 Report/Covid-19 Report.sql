create database new_project;

# imported an empty table 'revised_covid_deaths' using Table data import wizard'
# loaded the dataset from the CovidDeath.csv using load data infile to the empty table
# This was to make the dataset import faster
LOAD DATA INFILE 'CovidDeath.csv'
IGNORE 
INTO TABLE `revised_covid_deaths`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select * from revised_covid_deaths;

# Performing the same process for the second dataset revised_covid_vaccinations
LOAD DATA INFILE 'CovidVaccinations.csv'
IGNORE 
INTO TABLE `revised_covid_vaccinations`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select * from revised_covid_vaccinations;

select location, date, total_cases, new_cases, total_deaths, population
from revised_covid_deaths
order by 1,2;

-- Looking at the total cases vs the total death rates
-- Checking the probability of people dying from covid in Nigeria
create view DeathRate as
select date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as "Death Rate"
from revised_covid_deaths
where location = 'Nigeria'
order by 1,2;

-- Looking at the total cases vs the population 
-- To get the Infection rate of covid in Nigeria
create view InfectionRate as
select date, total_cases, population, (total_cases/population) as "Infection Rate"
from revised_covid_deaths
where location = "Nigeria"
order by date;

-- Showing the total no of cases and the infection rate in 2020 and 2021 in Nigeria
create view NigeriaStats as
select year(date) as Year, max(total_cases) as 'Total Cases', max(population) as Population,
max(total_cases) / max(population) as 'Infection Rate'
from revised_covid_deaths
group by year(date);

-- looking at countries with the Highest infection rate compared to population
create view `InfectionRate to Population` as
select location, population, max(total_cases) as "Highest Infection Count", sum(total_cases) as "Total Recorded cases",
max(total_cases) / max( population) * 100 as "Infection Rate"
from revised_covid_deaths
group by location, population
order by population desc;

-- Showing countries with the Highest Deaths
create view `Deaths per country` as
select location, max(total_deaths) as 'Total Deaths'
from revised_covid_deaths
where continent != ''
group by location
order by max(total_deaths) desc;

-- Global Numbers
create view GlobalReport as
select date, sum(new_cases) as 'Total Cases', sum(new_deaths) as 'Total Deaths', sum(new_deaths)/ sum(new_cases) * 100 as DeathPercentage
from revised_covid_deaths
where continent != ''
group by date
order by 1,2;

select sum(new_cases) as 'Total Cases', sum(new_deaths) as 'Total Deaths', sum(new_deaths)/ sum(new_cases) * 100 as DeathPercentage
from revised_covid_deaths
where continent != ''
order by 1,2;

/* select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations)
 over (Partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
from revised_covid_deaths as dea
inner join revised_covid_vaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent != ''
order by 2,3; */

-- Using a Common Table Expression (CTE)
create view RollingPeopleVaccinated as
with Popsvac ( Continent, Location, Date, Population,New_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations)
over (Partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
from revised_covid_deaths as dea
inner join revised_covid_vaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent != ''
)

select *, (RollingPeopleVaccinated/population) * 100 as PercentPopulationVaccinated
 from Popsvac;
 
 -- TEMP TABLE
 create table PercentPopulationVaccinated
 (
 continent varchar(255),
 location varchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 );
 
insert into PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations)
over (Partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
from revised_covid_deaths as dea
inner join revised_covid_vaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent != '';

select *, (RollingPeopleVaccinated/population) * 100 as PercentPopulationVaccinated
 from PercentPopulationVaccinated;

-- change date datatype
UPDATE revised_covid_deaths
SET date = STR_TO_DATE(date, '%m/%d/%Y');

UPDATE revised_covid_vaccinations
SET date = STR_TO_DATE(date, '%m/%d/%Y');

-- edit negative values in new_cases column

UPDATE revised_covid_deaths
SET new_cases = ABS(new_cases);

UPDATE revised_covid_deaths
SET new_deaths = ABS(new_deaths);

UPDATE revised_covid_vaccinations
SET new_tests = ABS(new_tests);

UPDATE revised_covid_vaccinations
SET new_tests_per_thousand = ABS(new_tests_per_thousand);

 




