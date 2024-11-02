-- Creating database
create database data_project;

-- import table
select * from uni_rankings2024;

-- Top ten Universities based on Overall ratings
select University, country, overall
from 
uni_rankings2024
order by Overall 
desc
limit 10;
-- There is a concentration of top-performing universities in the United States and the United Kingdom, 
-- nreflecting their significant investment in higher education and research infrastructure.

-- Top 10 countries based on average overall ratinngs and the number of universities they have 
select country,
count(University) as 'No. of Universities',
round(avg(Overall),2) as 'Overall Rating'
from uni_rankings2024 
group by country
order by avg(Overall)
desc
limit 10 ;

-- Top 10 countries with the most universities
select country, count(University) as 'No. of Universities',
round(avg(Overall),2) as 'Overall Rating' 
from uni_rankings2024
group by country 
order by count(University)
desc
limit 10;

-- We see from the data here that the countries with the most universities do not have the best overall ratings
-- Half of the top ten have below average in the overall ratings
-- Therefore it is not about the number of universities a country has
-- It is about ensuring that each university that is being built in the country has proper quality
-- Therefore countries should prioritize quality over quality in building universities
-- However if there are not enough universities in the country the competition will be too high 
-- and some students would miss out on gaining admission due to high competition
-- So there has to be a balance both in the number of universities a country has and the quality they can offer


-- Top Countries by Research Performance
select country, avg(Research) as "Research Performance", 
rank() over ( order by avg(Research) desc) as "Research Rank"
from uni_rankings2024 
group by country
order by avg(Research) desc 
limit 10;
-- Singapore has an outstanding performance in research with a significant gap over every other countries
-- Countries need to do better in ensuring quality reseach performance in their universities as only three countries
-- have a better than average performance in research
-- Shockingly United kingdom is not in the top 20 countries according to research rank,
-- having a research rank of 22 and a performance of 30.16

-- Looking at the Impact of International Outlook on rankings
select `rank`, University,`International Outlook` from uni_rankings2024 order by `international Outlook` desc ;
select `rank`, University,`International Outlook` from uni_rankings2024 order by `international Outlook`;
-- Having a strong international outlook seems to boost the rank of the university
-- However it is not a determining factor to the rank of the university

-- Calculating the Correlation Coefficient of Industry Income and Rank
SELECT 
SUM((`Industry Income` - Mean1) * (`rank` - Mean2))
/ (COUNT(*) * SQRT(SUM(POWER(`Industry Income` - Mean1, 2))) * SQRT(SUM(POWER(`rank` - Mean2, 2)))) AS CorrelationCoefficient
FROM uni_rankings2024,
(SELECT AVG(`Industry Income`) AS Mean1, AVG(`rank`) AS Mean2 FROM uni_rankings2024) AS MeanValues;
-- From the results of the correlation coefficient there is little to no correlation betwwen the industry income and the rank

select * from uni_rankings2024 order by `Industry Income` desc;
-- The table shows us the same thing, that Industry income is not a major deciding factor to the overall rankings of the university