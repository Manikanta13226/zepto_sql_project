create database zepto;
use zepto;
select * from zepto_v2;

-- Data Exploration
select count(*) from zepto_v2;

-- finding out null values in a dataset 
select * from zepto_v2
where
	Category is null
    or 
    name is null
    or 
    mrp is null
    or
    discountPercent is null
    or
    availableQuantity is null
    or
    discountedSellingPrice is null
    or
    weightInGms is null
    or 
    outOfStock is null
    or
    quantity is null;

select distinct Category from zepto_v2;  

-- products in stock is out of stock

select outOfStock, count(*)
from zepto_v2
group by outOfStock;  

-- product names present multiple times 
select name, count(*) as "Number of skus"
from zepto_v2
group by name
having count(*) >1
order by count(*) DESC;

-- Data Cleaning
-- Q.3 product with price =0 and delete the row which have zero mrp products
select * from zepto_v2
where mrp = 0  or discountedSellingPrice = 0;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM zepto_v2
WHERE mrp = 0 OR discountedSellingPrice = 0;

SET SQL_SAFE_UPDATES = 1;

-- convert paise to rupees
UPDATE zepto_v2
set mrp=mrp/100.0,
	discountedSellingPrice = discountedSellingPrice/100.0;
    
select mrp,discountedSellingPrice from zepto_v2;

-- Business Problems
-- Q.1 Find the top 10 best value products based on the discount percentage?

select name, mrp, discountPercent
from zepto_v2
order by discountPercent desc
limit 10;

-- Q.2 what are the products with high mrp but out of stock?

SELECT distinct name, mrp, outOfStock 
FROM zepto_v2 
WHERE outOfStock = 'TRUE' 
AND mrp > 300
order by mrp desc;

-- Q.3 Calculate estimated revenue for each category

select Category,
	SUM(discountedsellingprice*availableQuantity) as total_revenue
from zepto_v2
group by Category
order by total_revenue;

-- Q.4 find all products where mrp is greater than 500 and discount is less than 10%?

select distinct name, mrp, discountPercent
from zepto_v2
where mrp>500 and discountPercent <10
order by mrp desc, discountPercent desc;

-- Q.5 identify the top 5 categories offering the highest average discount percentage.

select category,
	round(avg(discountpercent),2) as avg_discount
from zepto_v2
group by category
order by avg_discount desc
limit 5;

-- Q.6 find the price per gram for products above l00g and sort by best value

select distinct name,
	weightInGms, 
	discountedSellingPrice,
	round(discountedSellingPrice/WeightInGms,2) as price_per_gram
from zepto_v2
where weightInGms >=100
order by price_per_gram;

-- Q.7 Group the producta into categories like Low Medium, Bulk

select distinct name, weightInGms,
case when weightIngms <1000 then 'Low'
	 when weightInGms <5000 then 'Medium'
     else 'Bulk'
     end as weight_category
from zepto_v2;

-- Q.8  what is the Total Inventory weight per category?

select category,
sum(weightInGms * availableQuantity) as total_weight
from zepto_v2
group by Category
order by total_weight;


