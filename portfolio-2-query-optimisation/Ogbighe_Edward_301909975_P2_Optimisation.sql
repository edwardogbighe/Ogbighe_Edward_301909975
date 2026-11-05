-- A separate performance table using the case's reservations.check_in type.
-- Only this field and a lab row ID are copied. Business constraints stay in Portfolio 1.
-- Generated values are for measuring a selective lookup, not complete case records.
CREATE SCHEMA query_lab;
CREATE TABLE query_lab."reservations" AS
SELECT "check_in", 0::bigint AS "lab_row_id" FROM portfolio."reservations" WITH NO DATA;
INSERT INTO query_lab."reservations" ("check_in", "lab_row_id")
SELECT (DATE '2030-01-01' + (g % 1000)::integer), g FROM generate_series(1, 20000) AS g;
ANALYZE query_lab."reservations";

-- Before: warm the lookup, then measure it three times.
SELECT "lab_row_id", "check_in"
FROM query_lab."reservations"
WHERE "check_in" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "check_in"
FROM query_lab."reservations"
WHERE "check_in" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "check_in"
FROM query_lab."reservations"
WHERE "check_in" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "check_in"
FROM query_lab."reservations"
WHERE "check_in" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";

CREATE INDEX p2_filter_idx ON query_lab."reservations" USING btree ("check_in");

-- After: run the same lookup and repeat the measurements.
SELECT "lab_row_id", "check_in"
FROM query_lab."reservations"
WHERE "check_in" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "check_in"
FROM query_lab."reservations"
WHERE "check_in" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "check_in"
FROM query_lab."reservations"
WHERE "check_in" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "check_in"
FROM query_lab."reservations"
WHERE "check_in" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
