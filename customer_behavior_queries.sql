--Q1)
select gender ,
sum(purchase_amount)as Revenue
from customer
group by gender ;
--Q2)
select age_group,
sum(purchase_amount)as Revenue
from customer 
group by age_group
order by Revenue desc;
--Q3)
select customer_id,discount_applied from customer
where discount_applied = 'Yes' and 
purchase_amount>(select avg(purchase_amount)
from customer);

-- Q4: Average purchase amount by shipping type
SELECT
    shipping_type,
    ROUND(AVG(purchase_amount), 2) AS average_purchase
FROM customer
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;

-- Q5: Spending comparison by subscription status
SELECT
    subscription_status,
    COUNT(customer_id) AS total_customers,
    ROUND(AVG(purchase_amount), 2) AS average_spend,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC;

--Q6)
SELECT
    item_purchased,
    ROUND(
        SUM(
            CASE
                WHEN discount_applied = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;


--Q7)
WITH customer_type AS (
    SELECT
        customer_id,
        CASE
            WHEN previous_purchases = 1 THEN 'New'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customer
)
SELECT
    customer_segment,
    COUNT(*) AS number_of_customers
FROM customer_type
GROUP BY customer_segment;

--Q8)
WITH item_counts AS (
    SELECT
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_counts
WHERE item_rank <= 3;

--Q9)
select *from customer

SELECT
    subscription_status,
    COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases >5
GROUP BY subscription_status;

--Q10)
SELECT
    age_group,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;