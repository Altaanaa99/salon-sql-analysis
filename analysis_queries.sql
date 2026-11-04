-- Salon business analysis
-- Run with:  sqlite3 -header -column salon.db < analysis_queries.sql

-- 1. How much revenue did the salon make each month?
SELECT strftime('%Y-%m', a.appt_date) AS month,
       COUNT(*)                       AS completed_appointments,
       ROUND(SUM(s.price), 2)         AS revenue,
       ROUND(SUM(a.tip), 2)           AS tips
FROM appointments a
JOIN services s ON a.service_id = s.service_id
WHERE a.status = 'Completed'
GROUP BY month
ORDER BY month;

-- 2. Which services bring in the most money?
SELECT s.name                  AS service,
       s.category,
       COUNT(*)                AS times_booked,
       ROUND(SUM(s.price), 2)  AS revenue
FROM appointments a
JOIN services s ON a.service_id = s.service_id
WHERE a.status = 'Completed'
GROUP BY s.service_id
ORDER BY revenue DESC;

-- 3. Revenue by service category
SELECT s.category,
       COUNT(*)                AS appointments,
       ROUND(SUM(s.price), 2)  AS revenue,
       ROUND(100.0 * SUM(s.price) /
             (SELECT SUM(s2.price)
              FROM appointments a2
              JOIN services s2 ON a2.service_id = s2.service_id
              WHERE a2.status = 'Completed'), 1) AS pct_of_revenue
FROM appointments a
JOIN services s ON a.service_id = s.service_id
WHERE a.status = 'Completed'
GROUP BY s.category
ORDER BY revenue DESC;

-- 4. How does each stylist perform?
SELECT st.name                              AS stylist,
       st.role,
       COUNT(*)                             AS appointments,
       ROUND(SUM(s.price), 2)               AS revenue,
       ROUND(AVG(s.price), 2)               AS avg_ticket,
       ROUND(SUM(a.tip), 2)                 AS total_tips
FROM appointments a
JOIN stylists st ON a.stylist_id = st.stylist_id
JOIN services s  ON a.service_id = s.service_id
WHERE a.status = 'Completed'
GROUP BY st.stylist_id
ORDER BY revenue DESC;

-- 5. Which days of the week are busiest?
SELECT CASE strftime('%w', appt_date)
         WHEN '0' THEN 'Sunday'   WHEN '1' THEN 'Monday'
         WHEN '2' THEN 'Tuesday'  WHEN '3' THEN 'Wednesday'
         WHEN '4' THEN 'Thursday' WHEN '5' THEN 'Friday'
         ELSE 'Saturday' END AS day_of_week,
       COUNT(*) AS appointments
FROM appointments
WHERE status = 'Completed'
GROUP BY strftime('%w', appt_date)
ORDER BY appointments DESC;

-- 6. Who are the top 5 clients by money spent?
SELECT c.first_name || ' ' || c.last_name AS client,
       COUNT(*)                           AS visits,
       ROUND(SUM(s.price), 2)             AS total_spent
FROM appointments a
JOIN clients c  ON a.client_id = c.client_id
JOIN services s ON a.service_id = s.service_id
WHERE a.status = 'Completed'
GROUP BY c.client_id
ORDER BY total_spent DESC
LIMIT 5;

-- 7. How many clients come back? (one visit vs. repeat clients)
SELECT CASE WHEN visits = 1 THEN 'One-time' ELSE 'Repeat' END AS client_type,
       COUNT(*) AS clients
FROM (SELECT client_id, COUNT(*) AS visits
      FROM appointments
      WHERE status = 'Completed'
      GROUP BY client_id)
GROUP BY client_type;

-- 8. Where do the best clients come from? (marketing source)
SELECT c.source,
       COUNT(DISTINCT c.client_id)  AS clients,
       ROUND(SUM(s.price), 2)       AS revenue,
       ROUND(SUM(s.price) / COUNT(DISTINCT c.client_id), 2) AS revenue_per_client
FROM appointments a
JOIN clients c  ON a.client_id = c.client_id
JOIN services s ON a.service_id = s.service_id
WHERE a.status = 'Completed'
GROUP BY c.source
ORDER BY revenue_per_client DESC;

-- 9. How much money is lost to cancellations and no-shows?
SELECT a.status,
       COUNT(*)               AS appointments,
       ROUND(SUM(s.price), 2) AS lost_revenue
FROM appointments a
JOIN services s ON a.service_id = s.service_id
WHERE a.status IN ('Cancelled', 'No-show')
GROUP BY a.status;
