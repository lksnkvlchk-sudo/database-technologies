#Uloha 1
SELECT product_name, total_amount 
FROM flourmills_sales 
WHERE total_amount > (SELECT AVG(total_amount) FROM flourmills_sales);

SELECT COUNT(*) 
FROM flourmills_sales 
WHERE total_amount > (SELECT AVG(total_amount) FROM flourmills_sales);
