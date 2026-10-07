-- Active: 1790801754508@@127.0.0.1@5432@datacraftinglab_db
CREATE DATABASE datacraftinglab_db;

CREATE TABLE flourmills_sales (
    sales_id INT PRIMARY KEY,
    sale_date DATE,
    region VARCHAR(100),
    state VARCHAR(100),
    product_category VARCHAR(100),
    product_name VARCHAR(150),
    customer_type VARCHAR(100),
    customer_id INT,
    quantity_sold INT,
    unit_price NUMERIC(10, 2),
    discount_rate INT,
    payment_method VARCHAR(100),
    sales_rep VARCHAR(150),
    warehouse VARCHAR(100),
    delivery_status VARCHAR(100),
    order_channel VARCHAR(100),
    batch_number INT,
    production_date DATE,
    total_amount NUMERIC(12, 2)
);

SELECT * 
FROM flourmills_sales;


#Uloha 1
SELECT product_name, total_amount 
FROM flourmills_sales 
WHERE total_amount > (SELECT AVG(total_amount) FROM flourmills_sales);

SELECT COUNT(*) 
FROM flourmills_sales 
WHERE total_amount > (SELECT AVG(total_amount) FROM flourmills_sales);

#Uloha 2
SELECT *
FROM flourmills_sales
WHERE product_category = (
    SELECT product_category
    FROM flourmills_sales
    GROUP BY product_category
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
)
ORDER BY sales_id ASC;

#Uloha 3 
SELECT product_name 
FROM flourmills_sales 
WHERE total_amount = 9511208.41;

#Uloha 4
SELECT 
    product_name, 
    total_amount, 
    total_amount / (SELECT SUM(total_amount) FROM flourmills_sales) AS amount_share
FROM 
    flourmills_sales;

#Uloha 5
SELECT SUM(total_amount) AS monthly_sales
FROM flourmills_sales
WHERE EXTRACT(MONTH FROM sale_date) = 8; 

SELECT 
    month, 
    monthly_sales
FROM (
    SELECT 
        EXTRACT(MONTH FROM sale_date) AS month,
        SUM(total_amount) AS monthly_sales
    FROM 
        flourmills_sales
    GROUP BY 
        EXTRACT(MONTH FROM sale_date)
) AS monthly_summary
ORDER BY 
    monthly_sales DESC;




#Uloha 6
SELECT 
    product_category, 
    total_sales
FROM (
    SELECT 
        product_category,
        SUM(total_amount) AS total_sales
    FROM 
        flourmills_sales
    GROUP BY 
        product_category
) AS category_summary
WHERE 
    total_sales > 50000000
ORDER BY 
    total_sales DESC;

#Uloha 7
SELECT 
    f1.product_name, 
    f1.product_category, 
    f1.total_amount
FROM 
    flourmills_sales f1
WHERE 
    f1.total_amount > (
        SELECT AVG(f2.total_amount)
        FROM flourmills_sales f2
        WHERE f2.product_category = f1.product_category
    );

SELECT COUNT(*)
FROM flourmills_sales f1
WHERE f1.total_amount > (
    SELECT AVG(f2.total_amount)
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
);

#Uloha 8
SELECT 
    f1.product_name, 
    f1.region, 
    f1.total_amount, 
    (
        SELECT MIN(f2.total_amount)
        FROM flourmills_sales f2
        WHERE f2.region = f1.region
    ) AS region_min_amount
FROM 
    flourmills_sales f1;

#Uloha 9 не обовязковий 
SELECT f1.*
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_name = f1.product_name
    GROUP BY f2.product_name
    HAVING COUNT(DISTINCT EXTRACT(MONTH FROM f2.sale_date)) > 1
);

#Uloha 10 
SELECT f1.*
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
      AND f2.total_amount > 200000
);


#Uloha 11
SELECT DISTINCT f1.product_category
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
    GROUP BY f2.product_category
    HAVING COUNT(DISTINCT f2.region) > 3
);

#Uloha 12
SELECT COUNT(DISTINCT f1.product_category)
FROM flourmills_sales f1
WHERE NOT EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
      AND f2.total_amount > 500000
);

#Uloha 14
SELECT DISTINCT f1.region
FROM flourmills_sales f1
WHERE NOT EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.region = f1.region
      AND f2.product_category = 'Flour'
);