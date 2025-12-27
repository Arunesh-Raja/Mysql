create database project;
use project;
drop database project;

-- table creation customer_income
create table Customer_income
(Loan_id varchar(25) unique,
Customer_id varchar (25)primary key,
Applicant_income int,
Coapplicant_income int,
Property_area varchar(25),
Loan_status text );
select * from Customer_income;
Show tables;


 -- Change the datatype if already we created a table using modify
 alter table Customer_income 
 modify Applicant_income int not null;
 
-- Insert the values into customer_income
insert into Customer_income values
("LA01001","IP1001",5467,2043,"urban","Y"),
("LA01002","IP1002",5688,1578,"urban","N"),
("LA01003","IP1003",4562,1078,"rural","Y"),
("LA01004","IP1004",7689,0,"urban","Y"),
("LA01005","IP1005",6543,2078,"rural","N"),
("LA01006","IP1006",7865,3452,"urban","N"),
("LA01007","IP1007",5673,0,"rural","Y"),
("LA01008","IP1008",7653,4532,"rural","N"),
("LA01009","IP1009",7639,3456,"urban","Y"),
("LA01010","IP1010",5675,2682,"rural","N");

update Customer_income set Applicant_income =5900 where Loan_id="LA01005";
-- Create a grade table
 create table Grades as 
 select Loan_id,Customer_id,Applicant_income,
 Coapplicant_income,Property_area,Loan_status,'' as Grades from Customer_income;
 select * from Grades;
 drop table Grades;
 
 -- alter table for include a datatype into grades
 alter table Grades 
 modify Grades varchar(25) not null;
 
 -- insert a values into grades
 update Grades
 set Grades = if (Applicant_income>7000,'grade A',
			if(Applicant_income>6000,'grade B',
			if(Applicant_income>5000,'Middle class',		
            if(Applicant_income>3000,'Low class','undefined')))) ;
            
-- create another table monthly_interest
create table Monthly_interest 
select *,if (Applicant_income<5000 and  Property_area='rural','3',
if(Applicant_income<6000 and Property_area='urban','5',
if(Applicant_income<6000 and Property_area='rural','5',
if(Applicant_income>7000 ,'7',Applicant_income)))) as interest_percentage from Customer_income; 
-- here applicant_income is used after'7',-> this is none of condition met applicant_income value ia defaultly  appear an monthly interesr row 

select*from Monthly_interest; 
drop table Monthly_interest;
-- loan table 
create table loan_table
(loan_id varchar(30) primary key,
customer_id varchar(30),
Loan_amount varchar(50),
Loan_Amount_Term int,
Cibil_Score int);
select * from loan_table;
drop table  loan_table;
truncate table loan_table;

-- insert a values for loan table
insert into loan_table values(
"LA01001","IP1001",20034,876,405),
("LA01003","IP1003",13224,420,974),
("LA01004","IP1004",34534,600,805),
("LA01005","IP1005",12645,170,500),
("LA01006","IP1006",12457,235,65);
truncate table loan_table;

 -- create a trigger for loan_table
delimiter $$
create trigger loan_status
before insert on loan_table
for each row
begin
if new.Loan_amount is null then
   set new.Loan_amount ='Loan still processing';
end if;
end $$   
delimiter ;


-- create a table for cibil score
create table Cibil_score_status_info
(Loan_Id varchar(50) primary key,
Loan_Amount int,
cibil_score int,
cibil_score_status varchar(50));
drop table  Cibil_score_status_info;

-- check the primary key
SHOW KEYS FROM loan_table WHERE Key_name = 'PRIMARY';
SHOW KEYS FROM Cibil_score_status_info WHERE Key_name = 'PRIMARY';

select * from Cibil_score_status_info;
drop table Cibil_score_status_info; 

-- trigger and insert a value cibil_score_status_info
delimiter $$
create trigger loan_status_score
after insert on  loan_table
for each row
begin
     insert into cibil_score_status_info(Loan_Id,Loan_Amount ,cibil_score,cibil_score_status)
     values(
     new.Loan_Id,
     new.Loan_Amount ,
     new.cibil_score,
     case 
		when new.cibil_score >900 then 'High cibil score'
        when new.cibil_score >750 then 'No penalty'
        when new.cibil_score >0 then  'Penalty customers'
        else 'Reject customer'
      end);
END $$

DELIMITER ;   
drop trigger  loan_status_score;

create table customer_interest_analysis  select
l.loan_id ,
l.customer_id ,
l.Loan_amount,
l.Loan_Amount_Term,
l.Cibil_Score,
m.Applicant_income ,
m.Coapplicant_income ,
m.Property_area ,
m.Loan_status,
m.interest_percentage ,
 -- Calculating Monthly and Annual Interest
    concat(l.Loan_amount / 100 * m.interest_percentage) AS monthly_interest_amount,
    concat(l.Loan_amount / 100 * m.interest_percentage * 12) AS annual_interest_amount
from loan_table l
inner join
monthly_interest m on l.loan_id=m.Loan_id;
select * from customer_interest_analysis;
select* from loan_table;

 -- create table customer_details
 
create table customer_det
(customerid varchar(10),
customer_name varchar(20),
gender text,
age int,
Education text,
self_employed text,
loan_id1 varchar(10),
Region_id float);

drop table customer_det;


-- insert into customer_det

insert into customer_det values
('IP1001','Sneka', 'Female',21,'Graduated', 'No','LA01001', 22),
('IP1002', 'Rani', 'Female',45, 'Not graduate','Yes','LA01002',  23),
('IP1003', 'Narendraprasad', 'Male', 22,'Graduted', 'No','LA01003', 24),
('IP1004', 'Anushka', 'Female', 35,'Graduated', 'Yes','LA01004', 24),
('IP1005', 'Kannan', 'Male', 38,'Graduated', 'No', 'LA01005',25),
('IP1006','Ajith', 'Male',38, 'Graduatd', 'No', 'LA01006',25),
('IP1007', 'Ragu', 'Male', 66,'Graduated', 'Yes', 'LA01007', 22);
truncate customer_details;
select * from customer_det;

-- create table region
create table region_info
(region_id int,
region text,
postalcode int);
drop table region_info;

-- insert into 
insert into region_info values
(22, 'West', 736899),
(23,'north', 343432),
(24, 'East', 55325),
(25, 'Central', 874944);
truncate region_info;
drop table region_info;

create table country_state
(state text,
district text,
customerID varchar(10),
region_id int);
select* from country_state;
drop table country_state;

truncate table country_state;
insert into country_state values
('Kerala', 'Idukki','IP1001', 22),
('Tamilnadu', 'Chennai','IP1002',23),
('Karnataka', 'Bengaluru','IP1003',24),
('Tamilnadu', 'Coiambatore','IP1004',25),
('Kerala', 'Munnar','IP1005',22),
('Tamilnadu', 'Bengaluru','IP1006',23),
('Tamilnadu', 'Chennai','IP1007',23),
('Tamilnadu', 'Anna nagr,chennai','IP1008',23);

truncate country_state;
select * from country_state;

-- create a table  customer_details using join
-- this is refernce for understanding joins(2 joins)
-- 1st Join 1: Links customer_det and region_info using the region_id column.
-- DISTINCT in your query to remove repeated results:
-- in that customer_det Region_id ex:24 have anushka and narendraprasad they inner join with region _info through region id
-- in region _info  region_id 24 has  (24, 'East', 55325), so  anushka and narendraprasad have same region east
create table customer_detail_refer as  select distinct c.loan_id1 , c.customerid,c.Region_id AS customer_region_id, 
c.customer_name,r.*
from customer_det as c
inner join  region_info as r
 on c.Region_id = r.region_id;
 
 select * from customer_detail_refer order by loan_id1;
 drop table customer_detail_refer;

-- 2nd Join 2: Links customer_det and country_state using the customerID column
-- (three joins)
-- in that customer_det anushka-IP1004,Region_id is 24 and narendraprasad-IP1003 Region_id is 24  so having same east in first join and
-- in 2nd join link customer_det and country_state using the customerID column
-- ('Karnataka', 'Bengaluru','IP1003',24), for narendraprassd  and ('Tamilnadu', 'Coiambatore','IP1004',25), for anuskha in country_state
-- In country_state both have differnt region but we join only  using customer_id  
-- So anuskha have  coiambator tamilnadu ,narendraprasd have bengaluru karnataka but 
-- both have same region becoz have first join using customer_det and region_info using the region_id column.


create table customer_details select c.loan_id1 , c.customerid,c.Region_id AS customer_region_id, 
c.customer_name,r.*,s.state,s.district
from customer_det as c
inner join  region_info as r
 on c.Region_id = r.region_id
 inner join  country_state as s on
 c.customerid = s.customerID ; 
 
 drop table customer_details;
 select * from customer_details order by loan_id1;
 
 select * from customer_details;
 


 
 -- create loan_details using join
 create table loan_details
 select
 a.* from 
 customer_interest_analysis as a
 inner join
 Cibil_score_status_info as t
 on a.loan_id=t.Loan_Id;
 drop table  loan_details;

 select * from loan_details;
 
 
 -- create the table  final table using join
 create table final_table
 select  distinct c.*,l.loan_id,
 l.Loan_amount,
 l.Cibil_Score,
 l.Applicant_income,
 l.interest_percentage,
 l.monthly_interest_amount,l.annual_interest_amount
 from customer_details as c
 inner join loan_details as l
 on
 c.loan_id1 =l.loan_id;
 select * from final_table;
 drop table final_table;
 
