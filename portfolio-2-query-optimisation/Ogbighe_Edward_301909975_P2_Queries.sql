-- Show related reservations, guests, rooms records (up to 20).
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

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
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

-- Find reservations records where check_in matches "2027-03-10" (up to 20).
SELECT * FROM portfolio."reservations"
WHERE "check_in" IS NOT DISTINCT FROM '2027-03-10'
ORDER BY "reservation_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."reservations"
WHERE "check_in" IS NOT DISTINCT FROM '2027-03-10'
ORDER BY "reservation_id"
LIMIT 20;

-- Count payments records for each reservation_id (up to 20 groups).
SELECT "reservation_id", count(*) AS record_count
FROM portfolio."payments"
GROUP BY "reservation_id"
ORDER BY record_count DESC, "reservation_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "reservation_id", count(*) AS record_count
FROM portfolio."payments"
GROUP BY "reservation_id"
ORDER BY record_count DESC, "reservation_id" NULLS LAST
LIMIT 20;
