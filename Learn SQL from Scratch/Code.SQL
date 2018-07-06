PAGE 1/6 Question 1.1 
How many campaigns and sources does CoolTShirts use? Which source is used for each campaign? 

SELECT COUNT (DISTNCT utm_campaign)
FROM page_vistits;

SELECT COUNT (DISTNCT utm_source)
FROM page_vistits;

SELECT DISTNCT utm_campaign,utm_source
FROM page_vistits;


Question 1.2
What pages are on the CoolTShirts website?

SELECT DISTINCT page_name
FROM page_visits;


Question 2.1
How many first touches is each campign responsible for?

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source as 'Source',
       ft_attr.utm_campaign as 'Campaign',
       COUNT(ft_attr.first_touch_at) as 'First Touch'
FROM ft_attr
GROUP BY 1,2
ORDER BY 3 DESC;

2.2 
How many last touches is each campaign responsible for?

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch AS lt
  JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source as 'Source',
       lt_attr.utm_campaign as 'Campaign',
       COUNT(*) as 'Last Touch'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

Question 2.3
How many vistors made a purhcase?

SELECT COUNT (DISTINCT user_id)
FROM page_visits
WHERE page_name LIKE '4 - purchase';

Question 2.4
How many last touches on the purchase page is each campaign responsible for?


WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch AS lt
  JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign as 'Campaign',
       COUNT (lt_attr.last_touch_at) as 'Last Touches'
FROM lt_attr
GROUP BY lt_attr.utm_campaign;

