use classicmodels;

-- select all columns
SELECT * FROM employees
where officeCode=1
ORDER BY firstName;


-- select few columns
SELECT firstName,lastName FROM employees
WHERE officeCode=1
ORDER BY firstName;

SELECT *,
MSRP AS sellingPrice,
(MSRP*0.90) AS discountPrice
FROM products;

-- CONCAT
SELECT 
    CONCAT(lastName, ', ', firstName) AS employeeName
FROM employees;

-- IN operator
SELECT* FROM employees
WHERE officeCode In (1,3,4);

-- Between operator
SELECT* FROM employees
WHERE employeeNumber BETWEEN 1000 AND 1500;

-- Like operator
SELECT* FROM employees
WHERE jobTitle Like '%sale%'; -- % number of charecters matching

SELECT* FROM employees
WHERE jobTitle Like '%sale%';

-- REGEXP
-- ^ begining of string
-- $ ending of string
-- | logical or
-- [abcd] range
-- [a-d]
SELECT * FROM employees
WHERE jobTitle REGEXP 'sale';

SELECT * FROM employees
WHERE jobTitle REGEXP '^sale';

SELECT * FROM employees
WHERE jobTitle REGEXP 'Rep$';

SELECT * FROM employees
WHERE firstName REGEXP '^[A-D]'; -- range

SELECT * FROM employees
WHERE firstName REGEXP '^D|e$';

-- IS NULL opearator
SELECT * FROM orders
WHERE comments IS NULL;

SELECT * FROM orders
WHERE comments IS NOT NULL;

-- LIMIT clause
SELECT *FROM customers
LIMIT 10;

SELECT *FROM customers
LIMIT 15,20; -- skip first 15 customers showing next 20

-- ORDER BY CLAUSE
SELECT customerName,
       contactLastName,
       contactFirstName,
       city
FROM customers
ORDER BY city DESC,contactLastName;
       

-- top 10 max creditLimit customers
SELECT *FROM customers
ORDER BY creditLimit DESC
LIMIT 10;

-- IMPLICIT JOIN
SELECT p.customerNumber, 
	   paymentDate,              
       amount,
       customerName
FROM payments p, customers c
-- If we dont use 'where' then will create a cross join
-- every row of first table will be joind with evry row of second table
-- table1 10 rows table2 20 rows cross join 10*20=200 rows
WHERE p.customerNumber=c.customerNumber; 

-- INNER JOIN
-- makes less memory storage no need to record multiple value in same table

-- have to mention form which table to take (customers.customerNumber)
-- as it is same column in both tables which create ambiguity
SELECT customers.customerNumber,
	   paymentDate,              
       amount,
       customerName
FROM payments 
INNER JOIN customers
ON payments.customerNumber=customers.customerNumber;

-- ALIAS for table names
SELECT p.customerNumber, 
	   paymentDate,              
       amount,
       customerName
FROM payments p
INNER JOIN customers c
ON p.customerNumber=c.customerNumber;

-- JOINING MULTIPLE TABLES

-- Joining three different tables
SElECT c.customerNumber,
	   customerName,
       o.status,
       e.employeeNumber,
       e.email As emloyeeEmail -- alias name
       
FROM customers c -- alias name
JOIN orders o    -- alias name
ON o.customerNumber = c.customerNumber
JOIN employees e
ON c.salesRepEmployeeNumber=e.employeeNumber;

-- SELF join
SELECT e.employeeNumber,
	   e.firstName AS employeeName,
       e.email as employeeEmail,
       mgr.jobTitle as reportsToAuthority
FROM employees e
JOIN employees mgr
ON e.reportsTo = mgr.employeeNumber;


-- JOIN
 -- INNER JOIN
 -- OUTER JOIN 
    -- RIGHT JOIN
    -- LEFT JOIN
    
-- What orders have been placed by customers
-- but it does not show customers who have not placed order as null 
SELECT c.customerNumber,
	   customerName,
	   o.orderNumber,
       o.status
FROM customers c
INNER JOIN orders o
on c.customerNumber=o.customerNumber;

-- customers who have not placed orders (subquerry)
SELECT c.customerNumber,
	   customerName,
       phone,
	   o.orderNumber,
       o.status
FROM customers c, orders o
WHERE c.customerNumber NOT IN(SELECT DISTINCT o.customerNumber FROM orders o);
-- SELECT DISTINCT o.customerNumber FROM orders o (subquerry)
   -- gives distinct customers  who have placed orders 
   
-- customers who have not placed orders outer join
-- LEFT OUTER JOIN
 SELECT c.customerNumber,
	   customerName,
	   o.orderNumber,
       o.status
FROM customers c -- LEFT table (1st table)
LEFT JOIN orders o -- RIGHT table (2nd table) 
on c.customerNumber=o.customerNumber; -- mapping every customers with orders
-- (all rows of customers will be fetched)

-- RIGHT outer join
SELECT c.customerNumber,
	   customerName,
	   o.orderNumber,
       o.status
FROM customers c -- LEFT table (1st table)
RIGHT JOIN orders o -- RIGHT table (2nd table) 
on c.customerNumber=o.customerNumber; -- mapping every orders with customers
-- (all rows of orders will be fetched)

-- SELF OUTER JOIN
SELECT emp.employeeNumber,
	   emp.firstName AS employeeName,
       emp.email as employeeEmail,
       mgr.jobTitle as reportsToAuthority
FROM employees emp
LEFT JOIN employees mgr
	ON emp.reportsTo=mgr.employeeNumber;
    
-- THE USING CLAUSE
  SELECT c.customerNumber,
	   customerName,
	   o.orderNumber
FROM customers c 
LEFT JOIN orders o 
	USING (customerNumber);

SElECT c.customerNumber,
	   customerName,
       o.status,
       e.employeeNumber,
       e.email As emloyeeEmail -- alias name
       
FROM customers c -- alias name
JOIN orders o    -- alias name
	USING (customerNumber)
JOIN employees e
ON c.salesRepEmployeeNumber=e.employeeNumber;

-- NATURAl JOIN
-- joins same table automatically but volatile in nature
SELECT customerNumber,customerName
FROM customers
NATURAL JOIN orders;


-- SUMMARISING DATA
 -- Aggregate Functions
 -- MAX()
 -- MIN()
 -- AVG()
 -- COUNT()
 
-- QUERY 1
SELECT
MAX(amount) as highestAmount,
MIN(amount) as lowestAmount,
SUM(amount) as totalAmount,
AVG(amount) as avgAmount,
COUNT(amount) as total
FROM payments;

-- QUERY2
SELECT
COUNT(*) as totalOrders,
COUNT(requiredDate) AS totalOrdersReq,
COUNT(shippedDate) AS totalOrdersShipped
FROM orders;

-- QUERY3
SELECT
COUNT(*) AS cancelledOrders
FROM orders
WHERE status='cancelled';

-- QUERY4
SELECT
MAX(orderDate) AS ltestOrder,
MIN(orderDate)  firstOrder
FROM orders;

-- QUERY5
SELECT
MAX(productLine),
MIN(productLine)
FROM productLines;

-- GROUP BY CLAUSE

-- QUERY1
SELECT
COUNT(*) AS productCount
FROM products; 

-- QUERY2
SELECT DISTINCT productLine
FROM products;

-- QUERY3
SELECT
productLine,
COUNT(*) AS productCount
FROM products
GROUP BY productLine; 

-- GROUP BY in detail
/*SELECT 
	C1,C2...Cn, aggregate(Ci)
FROM
	table
WHERE
	where conditions
GROUP BY C1,C2...Cn;*/

-- count of employees in same office
SELECT
officeCode,
city,
COUNT(*) AS numberOfStaff
FROM employees 
JOIN offices
USING(officecode) 
GROUP BY officeCode;

-- Having clause
-- Offices having more than 4 employees
SELECT officeCode,
	   city,
COUNT(employeeNumber) as employeeCount
FROM employees
JOIN offices USING (officeCode)
-- WHERE employCount>4 -- filter out rows before grouping
GROUP BY officeCode
HAVING employeeCount>4; -- filter out columns after grouping

SELECT officeCode,
	   city,
COUNT(employeeNumber) as employeeCount
FROM employees
JOIN offices USING (officeCode)
WHERE officeCode IN(1,2,3,4,5,6,7)-- filter out rows before grouping
GROUP BY officeCode
HAVING employeeCount>4; -- filter out columns after grouping

-- clauses order
/* FROM
   WHERE
   GROUPING BY
   HAVING
   SELECT
   DISTINCT
   ORDEER BY
   LIMIT     */
   
   -- QUERY 3
   -- Same number of ordered quantity,display orderedqunt>35
   SELECT quantityOrdered,
          COUNT(*) AS sameorderQuantityOrdered
   FROM orderdetails
   -- WHERE orderNumber IN (10100,10101)
   GROUP BY quantityOrdered
   HAVING quantityOrdered>35;
   
   -- QUERY4
   -- product ordered quantity
	SELECT productCode,
          COUNT(quantityOrdered) AS quantity
   FROM orderdetails
   GROUP BY productCode;
   
-- QUERY5:Total payments by each cutomer after certain date
SELECT customerNumber,
	   customerName,
	   SUM(amount) AS totalPayment
FROM payments
JOIN customers USING (customerNumber)
WHERE paymentDate>'2005-02-22' -- date should be in qoutes its not an integer
GROUP BY customerNumber;

-- QUERY6: Value of each unique order sorted by Total order value
SELECT orderNumber,
      SUM(quantityOrdered*priceEach) AS totalOrderValue
FROM orderdetails
GROUP BY orderNumber
ORDER BY totalOrderValue DESC;
   
-- QUERY7: Value of each unique order,customerName,customer no. sorted by Total order value
SELECT orderNumber,
	   customerNumber,
        customerName,
      SUM(quantityOrdered*priceEach) AS totalOrderValue
FROM orderdetails
JOIN orders USING (orderNumber)
JOIN customers USING (customerNumber)
GROUP BY orderNumber
ORDER BY totalOrderValue DESC;

-- QUERY8: employeeName,employeeNumber who sold product
	    -- Value of each unique order,customerName,customer no. sorted by Total order value
SELECT orderNumber,
	   customerNumber,
        customerName,
        employeeNumber,
        CONCAT(firstName,' ',lastName) AS salesEmpName, -- concatinaton
      SUM(quantityOrdered*priceEach) AS totalOrderValue
FROM orderdetails
JOIN orders USING (orderNumber)
JOIN customers USING (customerNumber)
JOIN employees
ON employees.employeeNumber=customers.salesRepEmployeeNumber
GROUP BY orderNumber
ORDER BY totalOrderValue DESC;

-- QUERY9: number of orders placed by customer and salesRepresentative
SELECT -- orderNumber,can select only one column which grouped column if table is not joined with other table
	   customerNumber,
       customerName,
       firstName AS employeeName,
       employeeNumber,
COUNT(*) as orderplaced
FROM orders
JOIN customers USING (customerNumber)
JOIN employees 
ON employees.employeeNumber=customers.salesRepEmployeeNumber
GROUP BY customerNumber;

-- QUERY10: number of orders by each salesRepresentative
SELECT count(orderNumber) as numberOforders,
       employeeNumber,
       firstName as employeeName
FROM orders
JOIN customers using (customerNumber)
JOIN employees 
ON employees.employeeNumber=customers.salesRepEmployeeNumber
GROUP BY salesRepEmployeeNumber;

-- QUERY11: No.of orders form each country
SELECT COUNT(orderNumber) AS orderCount,
	   country
FROM orders
JOIN customers USING (customerNumber)
GROUP BY country;

-- QUERY12: No.of orders form each country on each date
-- GROUPING on two columns
SELECT COUNT(*) AS orderCount,
	   country,
       orderDate
FROM orders
JOIN customers USING (customerNumber)
GROUP BY country,orderDate;

-- QUERY13: Find customer whose total order>80000 accross all their orders
-- can use same querries for for total order by customer remove >80000

SELECT COUNT(orderNumber) as orderCount,
	   c.customerNumber,
        c.customerName,
      SUM(quantityOrdered*priceEach) AS totalOrderValue
FROM orderdetails
JOIN orders USING (orderNumber)
JOIN customers c USING (customerNumber)
GROUP BY c.customerNumber,c.customerName
HAVING totalOrderValue>80000
ORDER BY customerNumber;

  -- same question with litle diiference in query
  
  SELECT COUNT(orderNumber) as orderCount,
	     customerNumber,
         customerName,
         SUM(quantityOrdered*priceEach) AS totalOrderValue
FROM orderdetails
JOIN orders USING (orderNumber)
JOIN customers c USING (customerNumber)
GROUP BY customerNumber
HAVING totalOrderValue>80000
ORDER BY customerNumber;

-- SUBQUERIES
-- QUERY1: Find products that have same product line as of "1917 Maxwell Touring Car"
SELECT productName,
	   productLine
FROM products
WHERE productLine=
(SELECT productline
FROM products
WHERE productName="1917 Maxwell Touring Car");


-- QUERY2: Find cars that are costlier than "1936 Mercedes-Benz 500k Special Roadster"
SELECT productName
	   MSRP
FROM products
WHERE productName REGEXP "car" AND MSRP>
(SELECT MSRP
FROM products
WHERE productName="1936 Mercedes-Benz 500k Special Roadster");

-- QUERY3: Find Cars cotlier than avg value of cars
SELECT*
FROM products
WHERE productLine REGEXP 'car' AND MSRP >
(SELECT AVG(MSRP)
FROM products
WHERE productLine IN ('Classic Cars','Vintage Cars')
);

-- QUERY4: Customers who never placed any orders(subqueries and joins)
-- Using Subquery
SELECT customerNumber
FROM customers
WHERE customerNumber NOT IN
(SELECT DISTINCT customerNumber
 FROM orders);
 
 -- Using Join
 SELECT customerNumber
 FROM customers
 LEFT JOIN orders
 USING (customerNumber)
 WHERE orderNumber IS NULL;
 
 -- QUERY5: where Join is prefered over Subquery
 --  SELECT customer with product code "S50_1514"
 -- Using join
SELECT DISTINCT *
FROM customers
JOIN orders USING(customerNumber)
JOIN orderdetails USING(orderNumber)
WHERE productCode="S50_1514";

-- Using subquery
SELECT DISTINCT *
FROM customers
WHERE customerNumber IN(SELECT customerNumber
FROM orders 
JOIN orderdetails USING(orderNumber)
WHERE productCode="S50_1514");

-- ALL keyword
-- Find products costlier than all trucks
SELECT*
FROM products
WHERE MSRP>(SELECT MAX(MSRP)
FROM products
WHERE productLine REGEXP "Truck");

SELECT*
FROM products
WHERE MSRP>ALL(SELECT MSRP -- comapres with all the prices of truck and > than all values then only true
FROM products
WHERE productLine REGEXP "Truck");

-- ANY Keyword
-- used to match with any entry from subquerry 
-- select clients who have made atleast two payments
SELECT*
FROM customers
WHERE customerNumber IN
(SELECT customerNumber
 FROM payments
 GROUP BY customerNumber
 HAVING COUNT(*)>2);
 
 SELECT*
FROM customers
WHERE customerNumber = ANY -- if matches with any result of subquery then true
(SELECT customerNumber
 FROM payments
 GROUP BY customerNumber
 HAVING COUNT(*)>2);

-- CORELATED QUERRY
-- performance low/slow yet powerfull used in real life scenarieo
-- inner query corelated with outter query

-- Find products whose price are higher than average MSRP in their corresponding product line
SELECT*
FROM products p
WHERE MSRP>
(
SELECT AVG(MSRP)
FROM products 
WHERE productLine=productLine);

-- exercise avg of each product line
SELECT AVG(MSRP),
productline
FROM products 
group by productLine;

-- EXISTS Keyword
-- EXISTS is same as ANY except for the time consumed will be less as, 
-- in ANY the query goes on executing where ever the condition is met and gives results. 
-- In case of exists it first has to check throughout the table for all the records that match and then execute it
-- Customers who have made any payments

SELECT *
FROM payments
WHERE customerNumber IN -- list can be large which affect performance
(SELECT DISTINCT customerNumber
FROM payments
);

SELECT *
FROM customers c
WHERE  EXISTS -- returns true as soon as a customer is found in the payment table
(SELECT customerNumber
FROM payments p
WHERE c.customerNumber=p.customerNumber
);

-- SUBQUERY In SELECT clause
SELECT*,
(SELECT AVG(amount) FROM payments) AS avgPayment,
amount - (SELECT avgPayment) AS difference
FROM payments;

-- SUBQUERY In FROM clause
-- display amount>avgAmount

SELECT*
FROM
(SELECT*,
(SELECT AVG(amount) FROM payments) AS avgPayment,
amount - (SELECT avgPayment) AS difference
FROM payments) AS invoiceSummary -- alias is mandatory
WHERE amount>avgPayment;
