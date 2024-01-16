

-- 1. creation of income tax table
CREATE TABLE IncomeTax (
    TaxpayerID INT PRIMARY KEY,
    TaxpayerName VARCHAR(255),
    TaxpayerType VARCHAR(50),
    TaxYear INT,
    Income DECIMAL(10, 2),
    Deductions DECIMAL(10, 2),
    TaxableIncome DECIMAL(10, 2),
    TaxOwed DECIMAL(10, 2),
    TaxRefund DECIMAL(10, 2),
    TaxpayerAge INT
);

-- 2. insertion in table using procedure

create or replace procedure insertintoincometax
(TaxpayerID INT,TaxpayerName VARCHAR(255),TaxpayerType VARCHAR(50), TaxYear INT,
 Income DECIMAL(10, 2),Deductions DECIMAL(10, 2), TaxableIncome DECIMAL(10, 2),
 TaxOwed DECIMAL(10, 2), TaxRefund DECIMAL(10, 2), TaxpayerAge INT)
as $$
begin
insert into IncomeTax values(TaxpayerID,TaxpayerName,TaxpayerType,TaxYear,Income,
Deductions, TaxableIncome, TaxOwed, TaxRefund, TaxpayerAge );
end $$
language plpgsql;
drop procedure insertintoincometax

-- 3. calling procedure


call insertintoincometax(1,'Anil','Individual',2022,1200000,600000,114000,20000,0.00,25);



-- 4. trigger on income tax table

		create or replace function checkcondition()
		returns trigger as $$
		begin
		if new. TaxpayerID <0  then
		raise 'INVALID Taxpayer ID';
	    if new.TaxpayerAge>75 then
        
		raise notice 'person above age 75 has % taxableIncome',TaxableIncome;
     	end if;
		end if;
		return new;
		end $$
		language plpgsql;

		create trigger checkcd before insert on IncomeTax for each row 
     execute function checkcondition();


-- 5. checking trigger function

      insert into incometax( TaxpayerID) values(-1);
drop trigger checkcd on incometax;


-- 6. manually insertion into income tax table

INSERT INTO IncomeTax (TaxpayerID, TaxpayerName, TaxpayerType, TaxYear, Income, Deductions, TaxableIncome, TaxOwed, TaxRefund, TaxpayerAge)
VALUES 
    (2, 'Rajesh Sharma', 'Individual', 2023, 1500000.00, 20000.00, 1480000.00, 300000.00, 0.00, 40),
    (3, 'Meera Khanna', 'Individual', 2023, 1250000.00, 18000.00, 1232000.00, 260000.00, 0.00, 35),
    (4, 'Neha Singh', 'Individual', 2023, 2000000.00, 35000.00, 1965000.00, 450000.00, 0.00, 45),
    (5, 'Arun Kapoor', 'Individual', 2023, 1400000.00, 25000.00, 1375000.00, 280000.00, 0.00, 38),
    (6, 'Sanjay Gupta', 'Individual', 2023, 1100000.00, 19000.00, 1081000.00, 220000.00, 0.00, 42),
    (7, 'Sneha Patel', 'Individual', 2023, 1800000.00, 28000.00, 1772000.00, 360000.00, 0.00, 33),
    (8, 'Ramesh Verma', 'Individual', 2023, 1300000.00, 22000.00, 1278000.00, 260000.00, 0.00, 47),
    (9, 'Pooja Choudhary', 'Individual', 2023, 1350000.00, 24000.00, 1326000.00, 270000.00, 0.00, 30),
    (10, 'Vikas Reddy', 'Individual', 2023, 1600000.00, 26000.00, 1574000.00, 320000.00, 0.00, 37),
    (11, 'Anjali Mishra', 'Individual', 2023, 1150000.00, 21000.00, 1129000.00, 230000.00, 0.00, 41);

-- 7. cursor to see all tuples having income more than 1200000


create or replace procedure showtuppro()  as $$
declare
val1 incometax.TaxpayerID%type;
val2 incometax.TaxpayerName%type;
val3 incometax.Taxyear%type;
val4 incometax.Income%type;
cur1 cursor for select TaxpayerID,TaxpayerName,Taxyear,Income
from incometax where income>1200000;
begin
open cur1;
loop
fetch cur1 into val1,val2,val3,val4;
exit when not found;
raise notice 'TaxpayerID : % , TaxpayerName : % , Taxyear : % , Income : %'
,val1,val2,val3,val4;
end loop;
close cur1;
end $$
language plpgsql;

-- 8.calling procedure

call showtuppro();

-- 9. function for maximum

create or replace function maxincome()
returns decimal as $$
declare
maximum decimal;
begin
select max(income) into maximum from incometax;
raise notice 'max income : %',maximum;
return maximum;
end $$
language plpgsql;

drop function maxincome()

-- 10. calling max function
select maxincome();

-- 11. function for minimum

create or replace function minincome()
returns decimal as $$
declare
minimum decimal;
begin
select min(income) into minimum from incometax;
raise notice 'min income : %',minimum;
return minimum;
end $$
language plpgsql;

-- 12. calling min function
select minincome();

drop table IncomeTax
select * from IncomeTax;









