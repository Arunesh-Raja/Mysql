select * from layoffs;

-- creating a stage table for verifying the data if any error 

create table staging_table 
like layoffs;

select * from staging_table;

insert into staging_table 
select * from layoffs;

-- Removing duplicates

select *,
row_number() over(partition by company, location,industry,total_laid_off,
percentage_laid_off,`date`,stage, country,funds_raised_millions) as row_num
from staging_table;


with duplicate_cte as
(
select *,
row_number() over(partition by company, location,industry,total_laid_off,
percentage_laid_off,`date`,stage, country,funds_raised_millions) as row_num
from staging_table
) 
select * 
from duplicate_cte 
where row_num >1;

select *from staging_table
where company in("Casper","Cazoo","Hibob","Wildlife Studios","Yahoo")
order by company;

DROP TABLE staging_table2;

CREATE TABLE `staging_table2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into staging_table2 
select *,
row_number() over(partition by company, location,industry,total_laid_off,
percentage_laid_off,`date`,stage, country,funds_raised_millions) as row_num
from staging_table;

select * from staging_table2;

delete from staging_table2 
where row_num >1;

select company ,trim(company) from staging_table2;

update staging_table2 
set company = trim(company);

select distinct(industry) from staging_table2
order by 1;

select * from staging_table2 
where industry like 'Cryp%';

update staging_table2 
set industry = "Crypto"
where industry like 'Cryp%';

select * from staging_table2
where industry ="";

select count(*) from staging_table2;

update staging_table2 
set `date` = str_to_date(`date`,"%m/%d/%Y");

alter table staging_table2 
modify column `date` date;

SELECT * FROM STAGING_TABLE2  
WHERE TOTAL_LAID_OFF IS NULL 
AND 
PERCENTAGE_LAID_OFF IS NULL;

SELECT * FROM STAGING_TABLE2  
WHERE INDUSTRY IS NULL 
or 
INDUSTRY ="";

SELECT * FROM STAGING_TABLE2 
WHERE COMPANY = "AIRBNB";

SELECT * 
FROM STAGING_TABLE2 S1
JOIN  STAGING_TABLE2 S2
 ON S1.COMPANY = S2.COMPANY 
WHERE (S1.INDUSTRY IS NULL)
AND 
S2.INDUSTRY IS NOT NULL;

SELECT S1.INDUSTRY , S2.INDUSTRY
FROM STAGING_TABLE2 S1
JOIN  STAGING_TABLE2 S2
 ON S1.COMPANY = S2.COMPANY 
WHERE (S1.INDUSTRY IS NULL)
AND 
S2.INDUSTRY IS NOT NULL;

UPDATE  STAGING_TABLE2 S1
JOIN  STAGING_TABLE2 S2
 ON S1.COMPANY = S2.COMPANY 
SET S1.INDUSTRY = S2.INDUSTRY
WHERE (S1.INDUSTRY IS NULL)
AND 
S2.INDUSTRY IS NOT NULL;

UPDATE STAGING_TABLE2 
SET INDUSTRY = NULL 
WHERE INDUSTRY ="";

SELECT * FROM STAGING_TABLE2 
WHERE COMPANY like "Bally%";

select * 
from staging_table2
where total_laid_off is null 
and 
percentage_laid_off is null;

delete 
from staging_table2
where total_laid_off is null 
and 
percentage_laid_off is null;

alter table staging_table2 
drop column row_num;

select * from staging_table2;

-- EDA (Exploratory Data Analysis)

select * 
from staging_table2;

-- highest laid_off by company

select company , sum(total_laid_off) 
from staging_table2 
group by company 
order by 2 desc;

-- highest laid_off by industry

select industry , sum(total_laid_off) 
from staging_table2 
group by industry 
order by 2 desc;

-- highest laid_off by country

select country , sum(total_laid_off) 
from staging_table2 
group by country 
order by 2 desc;

-- highest laid_off by Year

select year(`date`) , sum(total_laid_off) 
from staging_table2 
group by year(`date`) 
order by 1 desc;

select * 
from staging_table2;

-- laid off by stage

select stage , sum(total_laid_off) 
from staging_table2 
group by stage 
order by 2 desc;

-- percentage of laid_off by company

select company , sum(percentage_laid_off)
from staging_table2
group by company 
order by 2 desc;

select substring(`date`,1,7) `Month` ,sum(total_laid_off)
from staging_table2
where substring(`date`,1,7) is not null
group by `month` 
order by 1 asc;

-- Running Total of Total Laid Off 

With Running_total as
(select substring(`date`,1,7) `Month` ,sum(total_laid_off) as Total_laid
from staging_table2
where substring(`date`,1,7) is not null
group by `month` 
order by 1 asc
)
select `month` , total_laid ,
sum(total_laid) over (order by `month`) as rolling_total
from running_total;


select company ,year(`date`) as Year , sum(total_laid_off) 
from staging_table2 
group by company ,year(`date`)
order by 3 desc;

with company_year(company,Years,Total_laid_off) as
(
select company ,year(`date`) as Year , sum(total_laid_off) 
from staging_table2 
group by company ,year(`date`)
) ,Company_year_rank as 
(
select * , 
dense_rank() over(partition by years order by total_laid_off desc) Ranking
from company_year
where years is not null
)
select * from company_year_rank
where ranking <= 5
;







