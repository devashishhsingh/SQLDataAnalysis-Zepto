
```sql
-- Drop table if it exists
DROP TABLE IF EXISTS zepto;

-- Create table
CREATE TABLE zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discount_percent NUMERIC(5,2),
    available_quantity INTEGER,
    discounted_selling_price NUMERIC(8,2),
    weight_in_grams INTEGER,
    out_of_stock BOOLEAN,
    quantity INTEGER
);

-- --- DATA EXPLORATION ---

-- Sample data
SELECT * FROM zepto
LIMIT 10;

-- Count of rows
SELECT COUNT(*) FROM zepto;

-- Check for NULL values
SELECT * FROM zepto 
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discount_percent IS NULL
   OR discounted_selling_price IS NULL
   OR weight_in_grams IS NULL
   OR available_quantity IS NULL
   OR out_of_stock IS NULL
   OR quantity IS NULL;

-- Different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- Products: in stock vs out of stock
SELECT out_of_stock, COUNT(sku_id) AS total_products
FROM zepto
GROUP BY out_of_stock;

-- Products with duplicate names
SELECT name, COUNT(*) AS number_of_skus
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY number_of_skus DESC;

-- --- DATA CLEANING ---

-- Check for zero MRP or zero selling price
SELECT * FROM zepto 
WHERE mrp = 0 OR discounted_selling_price = 0;

-- Delete products with MRP = 0
DELETE FROM zepto
WHERE mrp = 0;

-- Convert paise to rupees for MRP and discounted price
UPDATE zepto
SET 
    mrp = mrp / 100.0,
    discounted_selling_price = discounted_selling_price / 100.0;

-- --- BUSINESS QUESTIONS ---

-- Q1: Top 10 best-value products by discount percent
SELECT DISTINCT name, mrp, discount_percent, discounted_selling_price
FROM zepto
ORDER BY discount_percent DESC
LIMIT 10;

-- Q2: High MRP but Out of Stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE out_of_stock = TRUE
ORDER BY mrp DESC;

-- Q3: Estimated Revenue per Category
SELECT category,  
       SUM(discounted_selling_price * available_quantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY category, total_revenue;

-- Q4: Products with MRP > 500 and Discount < 10%
SELECT DISTINCT name, mrp, discount_percent
FROM zepto
WHERE mrp > 500 AND discount_percent < 10
ORDER BY mrp DESC, discount_percent DESC;

-- Q5: Top 5 Categories with Highest Average Discount %
WITH category_avg AS (
    SELECT category, 
           ROUND(AVG(discount_percent), 2) AS avg_discount
    FROM zepto
    GROUP BY category
),
ranked_categories AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY avg_discount DESC) AS rank_
    FROM category_avg
)
SELECT category, avg_discount
FROM ranked_categories
WHERE rank_ <= 5;

-- Q6: Price Per Gram for Products > 100g
SELECT DISTINCT name, mrp, weight_in_grams, discounted_selling_price,
       ROUND(discounted_selling_price / weight_in_grams, 2) AS per_gram_price
FROM zepto
WHERE weight_in_grams >= 100
ORDER BY per_gram_price ASC;

-- Q7: Categorize Products by Weight
SELECT DISTINCT name, weight_in_grams,
       CASE 
           WHEN weight_in_grams < 1000 THEN 'LOW'
           WHEN weight_in_grams < 5000 THEN 'MEDIUM'
           ELSE 'BULK'
       END AS weight_category
FROM zepto;

-- Q8: Total Weight per Category
SELECT category, 
       SUM(weight_in_grams * available_quantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;
```


