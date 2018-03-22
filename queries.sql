--Cron job to truncate tables at 1:00PM everyday
00 13 * * * '/Users/sunday.alabi/SqlProject/truncate.sh'

--Cron job to import data into tables at 1:30PM everyday
30 13 * * * '/Users/sunday.alabi/SqlProject/mysql_airline.sh'


-- 1. The airline with the most expensive first class tickets
--- - (on average) over the 3 years

SELECT a.airlinename,
       t.ticketprice
FROM   airline a,
       ticket t
WHERE  t.airlineid = a.airlineid
       AND ticketprice >= 4590
ORDER  BY ticketprice DESC
LIMIT  1;

+-----------------+-------------+
| AirlineName     | TicketPrice |
+-----------------+-------------+
| British Airways |        9996 |
+-----------------+-------------+

-- 2. The airline with the cheapest first class tickets (on average) in 2016
SELECT a.airlinename,
       t.ticketprice,
       t.ticketdate
FROM   airline a,
       ticket t
WHERE  t.airlineid = a.airlineid
       AND ticketprice >= 4590
       AND ticketdate BETWEEN '2016-01-01' AND '2016-12-31'
ORDER  BY ticketprice ASC
LIMIT  1;

+-----------------+-------------+------------+
| AirlineName     | TicketPrice | TicketDate |
+-----------------+-------------+------------+
| Virgin Atlantic |        4605 | 2016-01-25 |
+-----------------+-------------+------------+

-- The cheapest ticket for business class between 14/02/2016 and 21/11/2016
SELECT a.airlinename,
       t.ticketprice,
       t.ticketdate
FROM   airline a,
       ticket t,
       airlineclass ac
WHERE  t.airlineid = a.airlineid
       AND ticketprice >= 1046
       AND ticketprice <= 5800
       AND ticketdate BETWEEN '2016-02-14' AND '2016-11-21'
ORDER  BY ticketprice ASC
LIMIT  1;

+-------------+-------------+------------+
| AirlineName | TicketPrice | TicketDate |
+-------------+-------------+------------+
| Emirates    |        1052 | 2016-06-24 |
+-------------+-------------+------------+

-- The total amount of money that Virgin Atlantic has made
-- from Economy ticket purchases in the first quarter of the year of 2017.

SELECT Sum(ticketprice) AS TotalMoney,
       a.airlinename
FROM   ticket,
       airline a
WHERE  ( ticketprice BETWEEN 515 AND 1481 )
       AND ticketdate BETWEEN '2017-01-01' AND '2017-04-31'
       AND a.airlineid = 1;

+------------+-----------------+
| TotalMoney | AirlineName     |
+------------+-----------------+
|       7749 | Virgin Atlantic |
+------------+-----------------+

-- The most profitable airline last year (2017).
SELECT t.airlineid,
       Sum(t.ticketprice) AS TotalMoney,
       a.airlinename
FROM   ticket t,
       airline a
WHERE  a.airlineid = t.airlineid
       AND t.ticketdate BETWEEN '2017-01-01' AND '2017-12-31'
GROUP  BY airlineid
ORDER  BY Sum(ticketprice) DESC
LIMIT  1;

+-----------+------------+-------------+
| AirlineID | TotalMoney | AirlineName |
+-----------+------------+-------------+
|         3 |     524994 | Emirates    |
+-----------+------------+-------------+

-- The top 3 most profitable airlines last year (2017).
SELECT t.airlineid,
       Sum(t.ticketprice) AS TotalMoney,
       a.airlinename
FROM   ticket t,
       airline a
WHERE  a.airlineid = t.airlineid
       AND t.ticketdate BETWEEN '2017-01-01' AND '2017-12-31'
GROUP  BY airlineid
ORDER  BY Sum(ticketprice) DESC
LIMIT  3;

+-----------+------------+-----------------+
| AirlineID | TotalMoney | AirlineName     |
+-----------+------------+-----------------+
|         3 |     524994 | Emirates        |
|         4 |     482371 | KLM             |
|         2 |     444843 | British Airways |
+-----------+------------+-----------------+

-- The most used airline in last year (2017)
SELECT t.airlineid,
       a.airlinename,
       Count(*) AS 'No of times used'
FROM   ticket t,
       airline a
WHERE  a.airlineid = t.airlineid
       AND t.ticketdate BETWEEN '2017-01-01' AND '2017-12-31'
GROUP  BY airlineid
ORDER  BY Count(*) DESC
LIMIT  1;

+-----------+-------------+-----------------+
| AirlineID | AirlineName | No of times used |
+-----------+-------------+-----------------+
|         3 | Emirates    |              92 |
+-----------+-------------+-----------------+

--The most travelled to country in the world last year for British Airways (2017)
SELECT destinationcountry,
       airlineid,
       Count(*) AS 'No of times traveled with British Airways'
FROM   ticket
WHERE  airlineid = 2
       AND ticketdate BETWEEN '2017-01-01' AND '2017-12-31'
GROUP  BY destinationcountry
ORDER  BY Count(*) DESC
LIMIT  1;

+--------------------+-----------+-------------------------------------------+
| DestinationCountry | AirlineID | No of times traveled with British Airways |
+--------------------+-----------+-------------------------------------------+
|                310 |         2 |                                         2 |
+--------------------+-----------+-------------------------------------------+

-- 9. The airline with the last/final flight of last year (2017).
SELECT t.ticketdate AS 'Flight Date',
       t.airlineid,
       a.airlinename
FROM   ticket t,
       airline a
WHERE  a.airlineid = t.airlineid
       AND t.ticketdate BETWEEN '2017-01-01' AND '2017-12-31'
ORDER  BY ticketdate DESC
LIMIT  2;

+-------------+-----------+-------------+
| Flight Date | AirlineID | AirlineName |
+-------------+-----------+-------------+
| 2017-12-31  |         5 | Lufthansa   |
| 2017-12-31  |         4 | KLM         |
+-------------+-----------+-------------+

-- 10. The most loyal customer/frequent flier for each airline
-----  (in one table) in 2017
SELECT p.passengerlastname  AS 'Last Name',
       p.passengerfirstname AS 'First Name',
       t.passengerid,
       Count(t.passengerid) AS 'No of times Customers flown Arik'
FROM   ticket t,
       passenger p
WHERE  p.passengerid = t.passengerid
       AND airlineid = 2
       AND ticketdate BETWEEN '2017-01-01' AND '2017-12-31'
GROUP  BY passengerid
ORDER  BY Count(passengerid) DESC
LIMIT  1;

+-----------+------------+-------------+----------------------------------+
| Last Name | First Name | PassengerID | No of times Customers flown Arik |
+-----------+------------+-------------+----------------------------------+
| Peters    | Raymond    |          12 |                                6 |
+-----------+------------+-------------+----------------------------------+

--  11. The number of trips made to each country by each airline to each country.
-- SELECT a.*, b.*, e.*, k.*, l.*, v.*
-- FROM
-- (select AirlineID, count(DestinationCountry) as 'Arik' from ticket WHERE DestinationCountry between 1 and 490 and AirlineID=1 GROUP by AirlineID desc) as a,
-- (select count(DestinationCountry) as 'BritishAirways' from ticket WHERE AirlineID=2) as b,
-- (select count(DestinationCountry) as 'Emirates' from ticket WHERE AirlineID=3) as e,
-- (select count(DestinationCountry) as 'KLM' from ticket WHERE AirlineID=4) as k,
-- (select count(DestinationCountry) as 'Lufthansa' from ticket WHERE AirlineID=5) as l,
-- (select count(DestinationCountry) as 'VirginAtlantic' from ticket WHERE AirlineID=6) as v;
--
-- select t.TicketDate AS 'Flight Date', t.AirlineID, a.AirlineName from ticket t, airline a
-- where a.AirlineID=t.AirlineID  AND t.TicketDate between '2017-01-01' and '2017-12-31'
-- order by TicketDate desc;

-- 12 The least travelled to country for the year in 2017
SELECT Count(t.destinationcountry),
       a.airlineid,
       a.airlinename
FROM   ticket t,
       airline a
WHERE  t.airlineid = a.airlineid
       AND ticketdate BETWEEN '2017-01-01' AND '2017-12-31'
GROUP  BY airlineid
ORDER  BY Count(t.destinationcountry) ASC
LIMIT  1;

-- 13. Which customer has spent the most money on travel for 2017
SELECT p.passengerid,
       p.passengerfirstname,
       p.passengerlastname               AS PassengerLastName,
       Sum(t.ticketprice * ticketvolume) AS 'Money Spent'
FROM   passenger p,
       ticket t
WHERE  p.passengerid = t.passengerid
       AND ticketdate BETWEEN '2017-01-01' AND '2017-12-31'
GROUP  BY t.passengerid
ORDER  BY Sum(t.ticketprice * ticketvolume) DESC
LIMIT  1;

+-------------+--------------------+----------+-------------+
| PassengerID | PassengerFirstName | FullName | Money Spent |
+-------------+--------------------+----------+-------------+
|          15 | Stephen            | Quinn    |      590999 |
+-------------+--------------------+----------+-------------+

--14. How many trips did the customer that spent the most
------ money on flights go on in 2017
SELECT p.passengerid,
       p.passengerfirstname,
       p.passengerlastname               AS FullName,
       Sum(t.ticketprice * ticketvolume) AS 'Money Spent',
       Sum(ticketvolume)                 AS 'Number of Flightd made'
FROM   passenger p,
       ticket t
WHERE  p.passengerid = t.passengerid
       AND ticketdate BETWEEN '2017-01-01' AND '2017-12-31'
GROUP  BY t.passengerid
ORDER  BY Sum(t.ticketprice * ticketvolume) DESC
LIMIT  1;

-- 15. The average price of first economy tickets in 2016 & 2017 for
------- each airline (in one table) , b.*, e.*, k.*, l.*, v.*
SELECT airlineid,
       Avg(CASE
             WHEN ticketdate BETWEEN '2016-01-01' AND '2016-12-31'
                  AND ticketprice BETWEEN 552 AND 1302 THEN ticketprice
           end) AS 'Average Price of Economy tickets in 2016',
       Avg(CASE
             WHEN ticketdate BETWEEN '2017-01-01' AND '2017-12-31'
                  AND ticketprice BETWEEN 552 AND 1302 THEN ticketprice
           end) AS 'Average Price of Economy tickets in 2017'
FROM   ticket
WHERE  airlineid BETWEEN 1 AND 6
GROUP  BY airlineid;

-- 16. Which airline sold the most expensive business class tickets
-----  to customer in 2017
SELECT airlineid,
       Max(CASE
             WHEN ticketdate BETWEEN '2017-01-01' AND '2017-12-31'
                  AND ticketprice BETWEEN 1046 AND 5800 THEN ticketprice
           end) AS 'most expensive business class tickets 2017'
FROM   ticket
WHERE  airlineid BETWEEN 1 AND 6
GROUP  BY airlineid;

-- 17. The total amount of money each customer has spent on airline
------- travel since the system was created.
SELECT p.passengerid,
       p.passengerfirstname,
       p.passengerlastname,
       Sum(t.ticketprice * t.ticketvolume) AS
       'total amount of money each customer'
FROM   ticket t,
       passenger p
WHERE  p.passengerid = t.passengerid
GROUP  BY passengerid;

--18. A list of all the passengers who have travelled to Singapore 164
--------| The United States 198 | Georgia 67 OR SouthAfrica 169 in the
-----last year. - Query should allow case insensitive search by Name not Country IDs
