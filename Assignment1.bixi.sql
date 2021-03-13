#Question 1
#The total number of trips for the years of 2016 and 2017
SELECT COUNT(*),YEAR(start_date)
FROM trips 
GROUP BY YEAR(start_date);

#the total number of trips for the years of 2016 and 2017 broken down by month
SELECT COUNT(*),YEAR(start_date),MONTH(start_date)
FROM trips 
GROUP BY MONTH(start_date),YEAR(start_date);

#the average number of trips a day for each year-month combination
CREATE TABLE working_table1 AS
SELECT COUNT(*)/COUNT(DISTINCT DAY (start_date)) AS AVG, MONTH(start_date), YEAR(start_date)AS amin
FROM trips
GROUP BY MONTH(start_date),YEAR(start_date);


SELECT AVG(AVG)
FROM working_table1
GROUP BY amin;

#Question 2 
#the total number of trips in 2017 broken down by member ship status
SELECT COUNT(*),is_member
FROM trips
WHERE YEAR(start_date)= 2017
GROUP BY is_member;

#the fraction of total trips that were done by members for the year of 2017 broken down by month
SELECT COUNT(*) AS member_trip,is_member,MONTH(start_date)
FROM trips
WHERE YEAR(start_date) = 2017
GROUP BY is_member,MONTH(start_date)
HAVING is_member =1;

#Question 3
#1.during the summer is when demand is at its peak 
#2.during the susmmer as well 

#question 4
#1)using no subquery
CREATE VIEW mem AS
SELECT COUNT(*)AS COUNT,start_station_code
FROM trips 
GROUP BY start_station_code
ORDER BY COUNT DESC
LIMIT 5;

SELECT mem.COUNT,mem.start_station_code,stations.code,stations.name 
FROM mem
INNER JOIN stations
ON mem.start_station_code=stations.code;


#2)using a subquery
SELECT A.COUNT,A.start_station_code,stations.code,stations.name
FROM(SELECT COUNT(*)AS COUNT,start_station_code
FROM trips 
GROUP BY start_station_code
ORDER BY COUNT DESC
LIMIT 5) AS A
INNER JOIN stations
ON A.start_station_code=stations.code;

#Question 5
#starts
SELECT a.count, a.start_station_code, a.time_of_day, stations.name
FROM(
SELECT COUNT(*) as count, start_station_code,
CASE 
WHEN HOUR(start_date) BETWEEN 7 AND 11 THEN "morning"
WHEN HOUR(start_date) BETWEEN 12 AND 16 THEN "afternoon"
WHEN HOUR(start_date) BETWEEN 17 AND 21 THEN "evening"
ELSE "night"
END AS "time_of_day" 
FROM trips
GROUP BY start_station_code,time_of_day) as a 
JOIN stations
ON a.start_station_code = stations.code
HAVING name LIKE "%Mackay%";

#ends
SELECT a.count, a.end_station_code, a.time_of_day, stations.name
FROM(
SELECT COUNT(*) as count, end_station_code,
CASE 
WHEN HOUR(end_date) BETWEEN 7 AND 11 THEN "morning"
WHEN HOUR(end_date) BETWEEN 12 AND 16 THEN "afternoon"
WHEN HOUR(end_date) BETWEEN 17 AND 21 THEN "evening"
ELSE "night"
END AS "time_of_day" 
FROM trips
GROUP BY end_station_code,time_of_day) as a 
JOIN stations
ON a.end_station_code = stations.code
HAVING name LIKE "%Mackay%";

#question 6
#number of starting trips per station
SELECT COUNT(*), start_station_code
FROM trips
GROUP BY start_station_code;

#the number of round trips
CREATE VIEW C AS 
SELECT COUNT(*) as coun , start_station_code,end_station_code
FROM trips
GROUP BY start_station_code,end_station_code
HAVING start_station_code = end_station_code;

SELECT COUNT(DISTINCT start_station_code)
FROM C;

#fraction of round trips to total 
SELECT (C.coun/B.COUNT)*100 AS Fraction, C.start_station_code,C.end_station_code,B.COUNT,C.coun
FROM(SELECT COUNT(*) AS COUNT, start_station_code
FROM trips
GROUP BY start_station_code) AS B
INNER JOIN C
ON C.start_station_code=B.start_station_code;

#4
SELECT (C.coun/B.COUNT)*100 AS Fraction, C.start_station_code,C.end_station_code,B.COUNT,C.coun
FROM(SELECT COUNT(*) AS COUNT, start_station_code
FROM trips
GROUP BY start_station_code) AS B
INNER JOIN C
ON C.start_station_code=B.start_station_code
HAVING COUNT>500 AND Fraction>10;

SELECT (C.coun/B.COUNT)*100 AS Fraction, C.start_station_code,C.end_station_code,B.COUNT,C.coun,stations.name
FROM(SELECT COUNT(*) AS COUNT, start_station_code
FROM trips
GROUP BY start_station_code) AS B
INNER JOIN C
ON C.start_station_code=B.start_station_code
JOIN stations
ON C.start_station_code = stations.code
HAVING COUNT>500 AND Fraction>10

