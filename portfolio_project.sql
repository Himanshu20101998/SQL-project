use portfolio_project;

select location,date,total_cases,new_cases,total_deaths,population from covid_death;
 -- looking at total cases VS total deaths
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage from covid_death where location like "%in%";
-- now looking at total cases VS population\
select location,date,total_cases,population,(total_cases/population)*100 as positive_population from covid_death;
-- looking at countries with highest infection rate compared to population
select location,population,MAX(total_cases) as highest_inf_count,MAX((total_cases/population)*100) as max_positive_population from covid_death group by 
location,population order by max_positive_population desc ;
-- now showing countries with their highest death count per poulation
select* from covid_death;
ALTER TABLE covid_death
MODIFY COLUMN total_deaths INT;
select location,max(total_deaths) as total_death_count from covid_death group by location order by total_death_count desc ;
-- now we will be looking the data of new deaths, new cases based on dates
ALTER TABLE covid_death
MODIFY COLUMN new_cases INT;
ALTER TABLE covid_death
MODIFY COLUMN new_deaths INT;
select date, sum(new_cases) as total_cases,sum(new_deaths) as total_death, (sum(new_deaths)/sum(new_cases)*100) as new_death_precentage
from covid_death group by date;

-- joining two tables based on location and date
select* from covid_death join covidvaccination on covid_death.location=covidvaccination.location and covid_death.date=covidvaccination.date;
-- now we will be looking on total population VS vaccinations
select covid_death.location,covid_death.date,covid_death.population,covidvaccination.new_vaccinations from 
 covid_death join covidvaccination on covid_death.location=covidvaccination.location and covid_death.date=covidvaccination.date;
 -- if i want to sum up the new vaccination data on rolling basis
 select covid_death.location,covid_death.date,covid_death.population,covidvaccination.new_vaccinations,sum(covidvaccination.new_vaccinations)
 over(partition by covid_death.location order by covid_death.location ,covid_death.date) as rolling_people_vaccinated 
 from covid_death join covidvaccination on covid_death.location=covidvaccination.location and covid_death.date=covidvaccination.date;
 -- i want to know percentage of pouplation vaccinated
 -- using CTE
 with popvsvac(location,date,population,new_vaccinations,rolling_people_vaccinated)
 as
	 ( select covid_death.location,covid_death.date,covid_death.population,covidvaccination.new_vaccinations,sum(covidvaccination.new_vaccinations)
	 over(partition by covid_death.location order by covid_death.location ,covid_death.date) as rolling_people_vaccinated 
 
 from covid_death join covidvaccination on covid_death.location=covidvaccination.location and covid_death.date=covidvaccination.date)
 select* ,( rolling_people_vaccinated/population)*100 as percentage_of_people_vaccinated
 from popvsvac;
 
 -- creating view for data visualization later on
 create view percentage_of_people_vaccinated as 
 select covid_death.location,covid_death.date,covid_death.population,covidvaccination.new_vaccinations,sum(covidvaccination.new_vaccinations)
	 over(partition by covid_death.location order by covid_death.location ,covid_death.date) as rolling_people_vaccinated 
     from covid_death join covidvaccination on covid_death.location=covidvaccination.location and covid_death.date=covidvaccination.date;
     
 
 

 
 
   



 
