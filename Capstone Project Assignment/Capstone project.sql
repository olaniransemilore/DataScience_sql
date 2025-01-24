/* Task 1: Data Overview and Exploration
• Retrieve the first 10 rows of the dataset.
• Retrieve a list of distinct job_title values.
• Count how many unique employee locations (employee_residence) are present in the dataset. */
select * from datascience_salaries_2024 limit 10;
select distinct job_title from datascience_salaries_2024;
select count( distinct employee_residence) from datascience_salaries_2024;

/* Task 2: Salary Analysis by Job Title and Country
• Retrieve the job title and average salary for each job title, ordered from highest to lowest.
• Get the top 5 highest paying job titles.
• Calculate the average salary for employees in different countries (company_location), filtering 
only countries with at least 10 employees. */
select job_title, avg(salary) as "Average Salary" from datascience_salaries_2024 group by job_title order by avg(salary) desc;
select job_title, avg(salary) as "Average Salary" from datascience_salaries_2024 group by job_title order by avg(salary) desc limit 5;
select * from datascience_salaries_2024;
select employee_residence, count(employee_residence) as "No of employees", avg(salary) as "Average Salary" from datascience_salaries_2024 
group by employee_residence having count(employee_residence) >= 10;

/* Task 3: Experience Level and Remote Work Impact
• Calculate the average salary based on the experience_level of employees.
• Find the average salary for employees who work fully remotely (remote_ratio = 100).
• Compare the average salary of employees who work fully remotely versus those who don’t 
(remote ratio less than 100). */
select * from datascience_salaries_2024;
select experience_level, avg(salary) as "Average Salary" from datascience_salaries_2024 group by experience_level;
select remote_ratio, avg(salary) as "Average Salary" from datascience_salaries_2024 group by remote_ratio having remote_ratio = 100;
select 
"Fully Remote" as "Category", avg(salary) as "Average Salary" from datascience_salaries_2024
where remote_ratio = 100
union all
select 
"Not Fully Remote" as "Category", avg(salary) as "Average Salary" from datascience_salaries_2024
where remote_ratio < 100;

select
case
when remote_ratio = 100 then "Fully Remote"
else "Not Fully Remote"
end as "Category",
avg(salary) as "Average Salary"
from datascience_salaries_2024
group by 
case
when remote_ratio = 100 then "Fully Remote"
else "Not Fully Remote"
end;

/*
Task 4: Salary Trends Over Time
• Find the number of employees hired per year, grouped by experience_level.
• Get the highest, lowest, and average salary for each year. */

select * from datascience_salaries_2024;
select work_year,count(experience_level) from datascience_salaries_2024 group by work_year;
select distinct work_year from datascience_salaries_2024;

SELECT work_year, experience_level, COUNT(experience_level) AS "employee_count"
FROM  datascience_salaries_2024
GROUP BY work_year, experience_level
ORDER BY work_year, experience_level;

SELECT experience_level,

       COUNT(CASE WHEN work_year = 2020 THEN work_year END) AS "No of Employees(2020)",
       round(avg(CASE WHEN work_year = 2020 THEN salary_in_usd END),0) AS "Average Salary(2020)",
       max(CASE WHEN work_year = 2020 THEN salary_in_usd END) AS "Highest Salary(2020)",
       min(CASE WHEN work_year = 2020 THEN salary_in_usd END) AS "Lowest Salary(2020)",
       
       COUNT(CASE WHEN work_year = 2021 THEN work_year END) AS "No of Employees(2021)",
       round(avg(CASE WHEN work_year = 2021 THEN salary_in_usd END),0) AS "Average Salary(2021)",
       max(CASE WHEN work_year = 2021 THEN salary_in_usd END) AS "Highest Salary(2021)",
       min(CASE WHEN work_year = 2021 THEN salary_in_usd END) AS "Lowest Salary(2021)",
       
       COUNT(CASE WHEN work_year = 2022 THEN work_year END) AS "No of Employees(2022)",
	   round(avg(CASE WHEN work_year = 2022 THEN salary_in_usd END),0) AS "Average Salary(2022)",
       max(CASE WHEN work_year = 2022 THEN salary_in_usd END) AS "Highest Salary(2022)",
       min(CASE WHEN work_year = 2022 THEN salary_in_usd END) AS "Lowest Salary(2022)",
       
       COUNT(CASE WHEN work_year = 2023 THEN work_year END) AS "No of Employees(2023)",
       round(avg(CASE WHEN work_year = 2023 THEN salary_in_usd END),0) AS "Average Salary(2023)",
       max(CASE WHEN work_year = 2023 THEN salary_in_usd END) AS "Highest Salary(2023)",
       min(CASE WHEN work_year = 2023 THEN salary_in_usd END) AS "Lowest Salary(2023)",
       
       COUNT(CASE WHEN work_year = 2024 THEN work_year END) AS "No of Employees(2024)",
       round(avg(CASE WHEN work_year = 2024 THEN salary_in_usd END),0) AS "Average Salary(2024)",
       max(CASE WHEN work_year = 2024 THEN salary_in_usd END) AS "Highest Salary(2024)",
       min(CASE WHEN work_year = 2024 THEN salary_in_usd END) AS "Lowest Salary(2024)"
FROM datascience_salaries_2024
GROUP BY experience_level;

/* Task 5: Filtering and Logical Operators
• Retrieve the details of employees who live in the US and earn more than $150,000.
• Find all employees who work in Germany or have a salary below $80,000.
• Retrieve employees who either work remotely or have an experience level of SE (Senior) */

select * from datascience_salaries_2024;
select * from datascience_salaries_2024 
where employee_residence = 'United States' and salary_in_usd > 150000;

select * from datascience_salaries_2024
where employee_residence = 'GE' and salary_in_usd < 80000;

select * from datascience_salaries_2024
where remote_ratio != 0 or experience_level = 'SE';

/* Task 6: Updating Records
• Increase the salary by 10% for all employees who have the job title 'Data Scientist'.
• Change the job_title to 'Senior Data Analyst' for employees with more than 10 years of 
experience (experience_level = 'SE') */

update datascience_salaries_2024
set salary = salary + (salary * 0.10)
where job_title = 'Data Scientist';

update datascience_salaries_2024
set job_title = 'Senior Data Analyst'
where job_title ='Data Analyst' and experience_level = 'SE';