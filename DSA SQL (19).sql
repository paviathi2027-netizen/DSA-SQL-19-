WITH prod_records AS (SELECT p.product_id	,p.product_name	,p.category_name,
ps.sales_quantity,	ps.rating From products p
INNER JOIN product_sales ps 
ON p.product_id = ps.product_id),

rank_product AS(SELECT *,
rank() OVER(PARTITION BY category_name
ORDER BY sales_quantity DESC,rating DESC) as rnk_product
FROM prod_records
)

SELECT category_name,
product_name
FROM rank_product
WHERE rnk_product=1 ;

#OR

SELECT category_name, product_name
FROM (
  SELECT 
    RANK() OVER (
      PARTITION BY category_name 
      ORDER BY sales_quantity DESC, rating DESC) AS product_rank,
    category_name,
    product_name,
    sales_quantity,
    rating
  FROM products
  JOIN product_sales AS sales 
    ON products.product_id = sales.product_id
) AS best_products
WHERE product_rank = 1 
ORDER BY category_name;