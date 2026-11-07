# Salon SQL Analysis

A SQL project that analyzes six months of appointments at a hair and nail salon to answer real business questions: what earns the most, who the best clients are, and where money is being lost.

As a licensed cosmetologist, I built this project around questions a salon owner actually asks.

## The database

The salon database (SQLite) has four tables:

| Table | What it holds |
|---|---|
| `stylists` | 4 stylists and their roles |
| `services` | 10 services with category, price and length |
| `clients` | 120 clients and how they found the salon |
| `appointments` | 651 appointments (June–November 2025) with status and tips |

The data is sample data I generated for practice.

## Business questions

1. How much revenue did the salon make each month?
2. Which services bring in the most money?
3. What share of revenue comes from each service category?
4. How does each stylist perform?
5. Which days of the week are busiest?
6. Who are the top clients by money spent?
7. How many clients come back?
8. Which marketing source brings the most valuable clients?
9. How much money is lost to cancellations and no-shows?

## Key findings

- **Color services drive the business:** Color makes up only 22% of appointments but **48% of revenue**. Balayage is the single top earner.
- **Revenue doubled** from about $4,100 in June to about $8,800 in October.
- **Saturday and Friday are the busiest days**, so these are the days to fully staff.
- **Most clients return:** 89 of 113 clients who visited came back more than once.
- **Instagram brings the most valuable clients**, about $462 per client, compared with about $274 from Yelp.
- **Cancellations and no-shows cost about $7,100**, around 15% of potential revenue. A deposit or reminder-text policy could recover part of this.

## SQL skills used

- `JOIN` across multiple tables
- `GROUP BY` with `COUNT`, `SUM`, `AVG` and `ROUND`
- Filtering with `WHERE` and `IN`
- Subqueries
- `CASE` statements
- Date functions (`strftime`)
- Sorting and `LIMIT`

## Files

- `salon_setup.sql`: creates the tables and loads the data
- `analysis_queries.sql`: the business questions as SQL queries

## How to run

On a Mac, open Terminal in this folder and run:

```
sqlite3 salon.db < salon_setup.sql
sqlite3 -header -column salon.db < analysis_queries.sql
```


## 📊 Dashboard

I exported the data from SQL to a CSV file and built a dashboard in Google Sheets using pivot tables and charts.

👉 [View the Salon Performance Dashboard](https://docs.google.com/spreadsheets/d/1iq8j7Ko2rd3T8FEeI4klMK8sRn3zgui6qAHIwKtIVsI/edit?usp=sharing)

**Key findings**
- Revenue grew from $4,105 in June to a peak of $8,845 in October
- Jordan Kim (Color Specialist) brought in the most revenue ($14,755), while Maya Lopez, the Senior Stylist, brought in the least ($4,490)
- Instagram clients generated the most revenue ($12,020), followed by walk-ins ($10,745)
- Color services (Balayage, Highlights, Full Color) made up about 48% of revenue ($19,200 of $39,825)
