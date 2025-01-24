create database global;
use global;

-- Dataset containing 100000 rows and 26 columns
-- Import empty table
-- Fill empty table using load infile to ensure speedy importing

LOAD DATA INFILE 'global_warming_dataset.csv'
IGNORE 
INTO TABLE `glob_warming_dataset`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select * from glob_warming_dataset;

-- Tracking urbanization and industrial activities effects on Air pollution
select country, urbanization, industrial_activity, Air_pollution_Index
from glob_warming_dataset
order by Air_Pollution_index desc;

select country, corr(Industrial_Activity, Air_Pollution_Index) from glob_warming_dataset;

-- Tracking how global temperature anomalies have change over the decades
select floor(year / 10) * 10 as decade, avg(Temperature_Anomaly) as Temperature_anomaly
from glob_warming_dataset
group by decade
order by Temperature_anomaly;

-- Tracking industrial activities and its impact 
-- on CO2 and methane emissions over the decades
select floor(year / 10) * 10 as decade, avg(Industrial_Activity) as Industrial_Activity,
avg(CO2_emissions) as CO2_emissions,avg(Methane_Emissions) as Methane_Emissions
from glob_warming_dataset
group by decade
order by 1,2;

-- Tracking the impact of CO2 and methane emissions on sea level rise, rainfall, and extreme weather events over the decades
select floor(year / 10) * 10 as decade,
avg(CO2_emissions) as CO2_emissions,avg(Methane_Emissions) as Methane_Emissions,
max(sea_level_rise) as 'Sea level Rise', max(extreme_weather_events) as 'Extreme Weather Events',avg(Average_Rainfall) as Rainfall
from glob_warming_dataset
group by decade
order by 1,2;

-- Tracking the countries with the highest CO2_ Emissions and analyzing its effects on Sea level rising and extreme weather events
select country, CO2_Emissions,Sea_Level_Rise, Extreme_Weather_Events
from glob_warming_dataset
order by CO2_Emissions desc
limit 5;

-- Tracking countries with the lowest CO2_ Emissions
select country, CO2_Emissions,Sea_Level_Rise, Extreme_Weather_Events
from glob_warming_dataset
order by CO2_Emissions
limit 5;

-- Analyzing the correlation between urbanization and Deforestation
SELECT 
SUM((`Urbanization` - Mean1) * (`Deforestation_Rate` - Mean2))
/ (COUNT(*) * SQRT(SUM(POWER(`Urbanization` - Mean1, 2))) * SQRT(SUM(POWER(`Deforestation_Rate` - Mean2, 2)))) AS CorrelationCoefficient
FROM glob_warming_dataset,
(SELECT AVG(`Urbanization`) AS Mean1, AVG(`Deforestation_Rate`) AS Mean2 
FROM glob_warming_dataset ) AS MeanValues;

-- Analyzing the correlation between Deforestation and CO2_Emissions
SELECT 
SUM((`Deforestation_Rate` - Mean1) * (`CO2_Emissions` - Mean2))
/ (COUNT(*) * SQRT(SUM(POWER(`Deforestation_Rate` - Mean1, 2))) * SQRT(SUM(POWER(`CO2_Emissions` - Mean2, 2)))) AS CorrelationCoefficient
FROM glob_warming_dataset,
(SELECT AVG(`Deforestation_Rate`) AS Mean1, AVG(`CO2_Emissions`) AS Mean2 
FROM glob_warming_dataset ) AS MeanValues;

-- Calculating the correlation between renewable energy usage and Air pollution
SELECT 
SUM((`Renewable_Energy_Usage` - Mean1) * (`Air_Pollution_Index` - Mean2))
/ (COUNT(*) * SQRT(SUM(POWER(`Renewable_Energy_USage` - Mean1, 2))) * SQRT(SUM(POWER(`Air_Pollution_Index` - Mean2, 2)))) AS CorrelationCoefficient
FROM glob_warming_dataset,
(SELECT AVG(`Renewable_Energy_Usage`) AS Mean1, AVG(`Air_Pollution_Index`) AS Mean2 
FROM glob_warming_dataset ) AS MeanValues;

-- Calculating the correlation between methane emissions and Air_pollution
SELECT 
SUM((`Methane_Emissions` - Mean1) * (`Air_Pollution_Index` - Mean2))
/ (COUNT(*) * SQRT(SUM(POWER(`Methane_Emissions` - Mean1, 2))) * SQRT(SUM(POWER(`Air_Pollution_Index` - Mean2, 2)))) AS CorrelationCoefficient
FROM glob_warming_dataset,
(SELECT AVG(`Methane_Emissions`) AS Mean1, AVG(`Air_Pollution_Index`) AS Mean2 
FROM glob_warming_dataset ) AS MeanValues;

-- Analyzing the correlation between fossil fuel usages and CO2_Emission
SELECT 
SUM((`Fossil_Fuel_Usage` - Mean1) * (`CO2_Emissions` - Mean2))
/ (COUNT(*) * SQRT(SUM(POWER(`Fossil_Fuel_Usage` - Mean1, 2))) * SQRT(SUM(POWER(`CO2_Emissions` - Mean2, 2)))) AS CorrelationCoefficient
FROM glob_warming_dataset,
(SELECT AVG(`Fossil_Fuel_Usage`) AS Mean1, AVG(`CO2_Emissions`) AS Mean2 
FROM glob_warming_dataset ) AS MeanValues;