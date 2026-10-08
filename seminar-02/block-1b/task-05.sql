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
