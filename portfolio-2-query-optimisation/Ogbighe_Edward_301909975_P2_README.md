# Hotel Reservation System — SQL queries

## 1. Show related reservations, guests, rooms records (up to 20).

```sql
SELECT t0."reservation_id" AS "reservations_reservation_id",
       t0."check_in" AS "reservations_check_in",
       t1."guest_id" AS "guests_guest_id",
       t1."full_name" AS "guests_full_name",
       t2."room_id" AS "rooms_room_id",
       t2."room_number" AS "rooms_room_number"
FROM portfolio."reservations" t0
JOIN portfolio."guests" t1 ON t0."guest_id" = t1."guest_id"
JOIN portfolio."rooms" t2 ON t0."room_id" = t2."room_id"
ORDER BY t0."reservation_id", t1."guest_id", t2."room_id"
LIMIT 20;
```

| reservations_reservation_id | reservations_check_in | guests_guest_id | guests_full_name | rooms_room_id | rooms_room_number |
| --- | --- | --- | --- | --- | --- |
| 21 | 2027-03-10 | 1 | Avery Morgan | 11 | 101 |
| 22 | 2027-04-05 | 2 | Jordan Lee | 12 | 202 |

## 2. Find reservations records where check_in matches "2027-03-10" (up to 20).

```sql
SELECT * FROM portfolio."reservations"
WHERE "check_in" IS NOT DISTINCT FROM '2027-03-10'
ORDER BY "reservation_id"
LIMIT 20;
```

| reservation_id | guest_id | room_id | check_in | check_out | status |
| --- | --- | --- | --- | --- | --- |
| 21 | 1 | 11 | 2027-03-10 | 2027-03-13 | confirmed |

## 3. Count payments records for each reservation_id (up to 20 groups).

```sql
SELECT "reservation_id", count(*) AS record_count
FROM portfolio."payments"
GROUP BY "reservation_id"
ORDER BY record_count DESC, "reservation_id" NULLS LAST
LIMIT 20;
```

| reservation_id | record_count |
| --- | --- |
| 21 | 1 |
| 22 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.813 | 0.813, 0.785, 0.82 | Sort → Seq Scan | 112 |
| After index | 0.167 | 0.167, 0.163, 0.169 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.813 ms to 0.167 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.79..0.792 rows=20 loops=1)
  Seq Scan on reservations (actual time=0.014..0.757 rows=20 loops=1)
Planning Time: 0.321 ms
Execution Time: 0.813 ms
```

### Before index, run 2

```text
Sort (actual time=0.763..0.765 rows=20 loops=1)
  Seq Scan on reservations (actual time=0.015..0.728 rows=20 loops=1)
Planning Time: 0.349 ms
Execution Time: 0.785 ms
```

### Before index, run 3

```text
Sort (actual time=0.797..0.799 rows=20 loops=1)
  Seq Scan on reservations (actual time=0.015..0.764 rows=20 loops=1)
Planning Time: 0.329 ms
Execution Time: 0.82 ms
```

### After index, run 1

```text
Sort (actual time=0.123..0.124 rows=20 loops=1)
  Bitmap Heap Scan on reservations (actual time=0.028..0.088 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=20 loops=1)
Planning Time: 0.568 ms
Execution Time: 0.167 ms
```

### After index, run 2

```text
Sort (actual time=0.119..0.121 rows=20 loops=1)
  Bitmap Heap Scan on reservations (actual time=0.028..0.086 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=20 loops=1)
Planning Time: 0.52 ms
Execution Time: 0.163 ms
```

### After index, run 3

```text
Sort (actual time=0.126..0.127 rows=20 loops=1)
  Bitmap Heap Scan on reservations (actual time=0.032..0.092 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=20 loops=1)
Planning Time: 0.544 ms
Execution Time: 0.169 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Ogbighe_Edward_301909975_P2_Queries.sql, then Ogbighe_Edward_301909975_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Ogbighe_Edward_301909975_P2_QueryResults.png) · [Index comparison](screenshots/Ogbighe_Edward_301909975_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

