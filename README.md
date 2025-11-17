# Inventory-Optimization-for-T.T-Inc.
Inventory Optimization and Sales Trend Analysis for T.T Inc.

## Executive Summary
T.T Inc., a leading consumer electronics company, faced challenges in managing inventory levels across its product portfolio. The Supply Chain Management team needed actionable insights to reduce overstock and understock situations, understand seasonal sales trends, and improve product availability.

This project leveraged PostgreSQL and advanced SQL techniques to analyze sales, product, and economic data. The solution provided clear metrics for inventory turnover, reorder levels, and the impact of external factors like inflation and seasonality.

### Key Outcomes:

- Identified top 10 best-selling SKUs

- Quantified the impact of promotions and inflation on sales

- Recommended optimal reorder levels per product

- Delivered insights to improve customer satisfaction and reduce holding costs

## The Business Problem
- Overstock leads to high holding costs and potential waste

- Understock causes missed sales and customer dissatisfaction

- Lack of visibility into seasonal and economic trends affecting demand

- Need for data-driven inventory planning for the upcoming fiscal year

## Methodology
### Data Integration: Combined three datasets—Sales, Product Info, and External Factors

#### SQL Analysis:

- Aggregated sales by SKU, category, and month

- Used CTEs to calculate average inventory and sales

- Joined tables on product ID and time dimensions

#### Inventory Metrics:

- Current Inventory Level

- Inventory Turnover Rate

- Optimal Reorder Level

- Total Cost of Holding Inventory

#### Correlation Analysis:

- Inflation vs. Sales Quantity

- GDP vs. Sales Volume

- Seasonality vs. Category Sales

## Skills & Tools Used
Category	Skills and  Tools

SQL Techniques:	JOIN, GROUP BY, HAVING, CTE, CASE, AGGREGATE FUNCTIONS

Database:	PostgreSQL

Analysis:	Inventory modeling, correlation analysis, cost estimation

## Results & Business Recommendations
- Promotions increased average sales quantity by up to 30% in certain categories

- Inflation showed a moderate positive correlation with sales volume

- Seasonality significantly impacted product categories like accessories and wearables

- Top 10 SKUs accounted for over 60% of total sales volume

- Reorder levels were recalculated to reduce understock risk by 40%

## Recommendations:

- Prioritize restocking high-turnover SKUs with low inventory

- Align promotional campaigns with seasonal peaks

- Monitor inflation and GDP trends to forecast demand shifts

- Implement dynamic safety stock buffers for volatile categories
