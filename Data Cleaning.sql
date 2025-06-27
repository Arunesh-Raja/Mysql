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

select distinct location from staging_table2 
where location like "United%";









