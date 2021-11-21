-- 1
SELECT t.price , count(price)
FROM packages.trpackages t 
WHERE t.price < 3000
GROUP BY t.price 

-- 2
SELECT namecompany, COUNT(namecompany)
FROM packages.companies c 
JOIN packages.trpackages t 
ON c.companyid = t.companyid 
GROUP BY namecompany 


-- 3
WITH new_table (trpackagesid, companyid, price, Min_price)
AS (
SELECT trpackagesid, companyid, price, MIN(t.price) OVER(PARTITION BY t.companyid) Min_price
FROM packages.trpackages t 
ORDER BY t.companyid 
)
SELECT * FROM new_table;

SELECT paca
-- 9
CREATE TABLE IF NOT EXISTS hotel_blacklist
(
	id INT PRIMARY KEY,
	hotelid INT,
	FOREIGN KEY(hotelid) REFERENCES packages.hotels(hotelid)
)

DROP TABLE hotel_blacklist 

SELECT * FROM packages.hotel_blacklist















