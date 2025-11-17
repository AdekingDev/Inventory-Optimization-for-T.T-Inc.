select * from factors

select * from product

select * from sales

select * from inventory_costs

--- 1. What is the total number of units sold per product SKU?
Select productid, SUM(inventoryquantity) AS total_units_sold
from sales
group by productid
order by total_units_sold Desc;

---2. Which product category had the highest sales volume last month?
Select product.productcategory, sum(inventoryquantity) AS total_units
from sales
join product on sales.productid = product.productid
where salesdate between '2022-01-01' and '2022-01-31'
group by productcategory
order by total_units desc
limit 1;


--3. How does the inflation rate correlate with sales volume for a specific month?
Select factors.inflationrate, SUM(sales.inventoryquantity) AS total_sales
from sales
join factors on sales.salesdate = factors.salesdate
where factors.factors_month = 12 and factors.factors_year = 2022
group by factors.inflationrate;


--4. What is the correlation between the inflation rate and sales quantity for all products combined on a monthly basis over the last year?
select factors.factors_month, factors.factors_year, factors.inflationrate, sum(sales.inventoryquantity) as total_sales
from sales
join factors on sales.sales_year = factors.factors_year and sales.sales_month = factors.factors_month
where factors.factors_year = 2022
group by factors.factors_month, factors.factors_year, factors.inflationrate
order by factors.factors_month;


-- 5. Did promotions significantly impact the sales quantity of products?
select product.promotions, AVG(sales.inventoryquantity) AS avg_sales
from sales
join product on sales.productid = product.productid
group by product.promotions;

--6. What is the average sales quantity per product category?
Select product.productcategory, AVG(sales.inventoryquantity) AS avg_inventoryquantity
from sales
join product on sales.productid = product.productid
group by product.productcategory;

--7. How does the GDP affect the total sales volume?
Select factors.gdp, sum(sales.inventoryquantity) AS total_sales
from sales
join factors ON sales.salesdate = factors.salesdate
group by factors.gdp
order by factors.gdp;

--8. What are the top 10 best-selling product SKUs?
Select productid, sum(inventoryquantity) AS total_sales
from sales
group by productid
order by total_sales DESC
limit 10;


--9. How do seasonal factors influence sales quantities for different product categories?
Select product.productcategory, factors.seasonalfactor, SUM(sales.inventoryquantity) AS total_sales
from sales
join product on sales.productid = product.productid
join factors ON sales.salesdate = factors.salesdate
group by product.productcategory, factors.seasonalfactor
order by product.productcategory, factors.seasonalfactor;


--10. What is the average sales quantity per product category, and how many products within each category were part of a promotion?
Select product.productcategory, avg(sales.inventoryquantity) as avg_inventoryquantity,
count(CASE WHEN product.promotions = 'Yes' THEN 1 END) as promotion_count
from sales
join product on sales.productid = product.productid
group by product.productcategory;


--- Inventory level
-- Simply the sum of quantities in the inventory for each product SKU.
select productid, sum(inventoryquantity) as current_inventory
from sales
group by productid;


--- Inventory Turnover Rate
-- Formula: Total Sales Quantity / Average Inventory Level
-- Assuming there is a table or subquery for average inventory
select productid,
sum(inventoryquantity)::NUMERIC / AVG(inventoryquantity)::NUMERIC AS turnover_rate
from sales
group by productid;


---Optimal Reorder Level
--Formula: (Average Daily Sales * Lead Time) + Safety Stock
-- Replace X with actual lead time and Y with safety stock
select productid,
(AVG(inventoryquantity) / 30 * 7) + 15 as optimal_reorder_level
from sales
group by productid;

---Total Cost of Holding Inventory
--Formula: Sum of Holding Costs + Sum of Overstock Costs - Sum of Understock Costs

-- firstly a table needs to be created for the inventory
Create TABLE inventory_costs (
    productid INTEGER,
    holding_cost NUMERIC,
    overstock_cost NUMERIC,
    understock_cost NUMERIC
);

--Holding cost
insert into inventory_costs (productid, holding_cost)
select productid,
sum(inventoryquantity * productcost * 0.02) AS holding_cost
from sales
group by productid;


---Overstock cost
-- First, create a temp table with average monthly sales
Create temp table avg_sales as
select productid, AVG(inventoryquantity) as avg_monthly_sales
from sales
group by productid;

-- Update inventory_costs with overstock cost
update inventory_costs ic
set overstock_cost = sub.overstock
from (select s.productid,
sum(case when s.inventoryquantity > a.avg_monthly_sales
then (s.inventoryquantity - a.avg_monthly_sales) * s.productcost * 0.5
else 0 end) as overstock
from sales s
join avg_sales a ON s.productid = a.productid
group by s.productid) sub
where ic.productid = sub.productid;


---Understock cost
update inventory_costs ic
set understock_cost = sub.understock
from (
select s.productid,
sum(case when s.inventoryquantity < a.avg_monthly_sales
then (a.avg_monthly_sales - s.inventoryquantity) * s.productcost * 1.2
else 0 end) as understock
from sales s
join avg_sales a ON s.productid = a.productid
group by s.productid) sub
where ic.productid = sub.productid;



---Total Cost of Holding Inventory
select productid,
coalesce (holding_cost, 0) + coalesce(overstock_cost, 0) - coalesce(understock_cost, 0) as total_inventory_cost
from inventory_costs;









