## CREATING DATABASE, loading data into table , veriying the data
create database ev;
use ev;
show tables;
select *from electric_vehicles;

# Queries
#1. Retrieve all records from the dataset where the State is 'Washington'. 
SELECT *  
FROM electric_vehicles  
WHERE State = 'WA';

#2.List distinct Electric Vehicle Types available in the dataset. 
SELECT DISTINCT `Electric_Vehicle_Type`
FROM electric_vehicles;

#3. Get all vehicles with an Electric Range greater than 200 miles, sorted in descending order.
SELECT *  
FROM electric_vehicles  
WHERE `Electric_Range` > 200
ORDER BY `Electric_Range` DESC;

# 4. Find all vehicles with a Base MSRP between $30,000 and $60,000.
SELECT *  
FROM electric_vehicles  
WHERE `Base_MSRP`BETWEEN 30000 AND 60000;

#5. Count the number of electric vehicles for each Make.
SELECT Make, COUNT(*) AS vehicle_count  
FROM electric_vehicles  
GROUP BY Make  
ORDER BY vehicle_count DESC;

#6. Find the average Electric Range for each Model Year.
SELECT `Model_Year`, AVG(`Electric_Range`) AS avg_electric_range  
from electric_vehicles  
GROUP BY `Model_Year`
ORDER BY `Model_Year` asc;

#7.Get the total number of electric vehicles available in each City, showing only cities with more than 100 vehicles.
select City, COUNT(*) AS vehicle_count  
from electric_vehicles  
group by  City  
having COUNT(*) > 100  
ORDER BY vehicle_count DESC;

#8. Find the total Base MSRP of all electric vehicles in each Legislative District, filtering districts where the total is above $10 million. 
SELECT `Legislative_District`, SUM(`Base_MSRP`) AS total_base_msrp  
from electric_vehicles  
GROUP BY `Legislative_District`  
having SUM(`Base_MSRP`) > 10000000  
ORDER BY total_base_msrp DESC;

#9. Assume you have a separate table Electric_Utility_Providers with columns (Utility_ID, Electric_Utility, State). Write a query to fetch all electric vehicles along with their Electric Utility Provider's State. 
SELECT ev.*, eup.State AS utility_provider_state  
FROM electric_vehicles ev  
JOIN electric_utility_providers eup  
ON ev.`Electric_Utility` = eup.`Electric_Utility`;

# 10.  Retrieve all vehicle models that have the highest Electric Range in each State using a subquery.
select ev.*  
from electric_vehicles ev  
JOIN ( SELECT State, MAX("Electric Range") AS max_range  
    FROM electric_vehicles  
    group by State  ) max_ev  ON ev.State = max_ev.State AND ev.`Electric_Range` = max_ev.max_range;
    
# 11.  Find the Make and Model of vehicles whose Base MSRP is higher than the average Base MSRP of all vehicles. 
SELECT Make, Model  
from electric_vehicles  
where `Base_MSRP` > (  SELECT AVG(`Base_MSRP`) FROM electric_vehicles );

# 12. . Extract the first 3 characters from the Postal Code of each vehicle and rename it as Postal_Region.
SELECT substring(`Postal_Code`, 1, 3) AS Postal_Region  
from electric_vehicles;

# 13.  Retrieve all vehicles where the Model Name contains the word 'Tesla' (case insensitive). 
SELECT *  
FROM electric_vehicles  
WHERE LOWER(Make) LIKE '%tesla%';

# 14.  Create a new column Price_Category:  'Low' if Base MSRP < 30,000 , 'Mid' if Base MSRP is between 30,000 and 60,000 ,'High' if Base MSRP > 60,000

alter table electric_vehicles  
add column Price_Category VARCHAR(10);
SET SQL_SAFE_UPDATES = 0;
update electric_vehicles  
set Price_Category =  
    case  
        when `Base_MSRP` < 30000 THEN 'Low'  
        when `Base_MSRP` between 30000 AND 60000 THEN 'Mid'  
        else 'High'  
    END;
select Price_Category from electric_vehicles;
# 15.  Update all records where the State is NULL by replacing it with 'Unknown'.
UPDATE electric_vehicles  
SET State = 'Unknown'  
WHERE State IS NULL;

# 16. Delete all records where Base MSRP is NULL or Electric Range is NULL. 
DELETE FROM electric_vehicles  
WHERE `Base_MSRP` IS NULL  
   OR `Electric_Range` IS NULL;

# 17.  Create an index on the VIN column to improve query performance. 
CREATE INDEX idx_vin  
ON electric_vehicles (VIN);

# 18.  Use a Common Table Expression (CTE) to list all vehicles along with the rank of their Electric Range within their Make. 
with RankedVehicles AS (  
    select *,  
           rank () OVER (PARTITION BY Make ORDER BY `Electric_Range` DESC) AS Range_Rank  
    from electric_vehicles  ) select * from RankedVehicles;
    
# 19.  Use a Window Function to calculate the running total of electric vehicles for each Model Year.
select `Model_Year`,  
       COUNT(*) AS vehicle_count,  
       SUM(COUNT(*)) OVER (PARTITION BY `Model_Year` ORDER BY `Model_Year`) AS running_total  
FROM electric_vehicles  
group by `Model_Year`  
ORDER BY `Model_Year`;


# 20 . Retrieve the top 5 most expensive vehicles and top 5 least expensive vehicles (based on Base MSRP) in a single query using UNION.
(select *  
 from electric_vehicles  
 order by `Base_MSRP` desc  
 LIMIT 5)  
union
(SELECT *  
 FROM electric_vehicles  
 ORDER BY `Base_MSRP` ASC  
 LIMIT 5);











