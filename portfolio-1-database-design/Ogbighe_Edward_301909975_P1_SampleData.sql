-- Fictional sample records for Hotel Reservation System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."guests" ("guest_id", "full_name", "email") VALUES (1, 'Avery Morgan', 'avery.morgan@example.test');
INSERT INTO portfolio."guests" ("guest_id", "full_name", "email") VALUES (2, 'Jordan Lee', 'jordan.lee@example.test');
INSERT INTO portfolio."rooms" ("room_id", "room_number", "room_type", "capacity") VALUES (11, '101', 'standard', 2);
INSERT INTO portfolio."rooms" ("room_id", "room_number", "room_type", "capacity") VALUES (12, '202', 'suite', 4);
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status") VALUES (21, 1, 11, '2027-03-10', '2027-03-13', 'confirmed');
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status") VALUES (22, 2, 12, '2027-04-05', '2027-04-08', 'confirmed');
INSERT INTO portfolio."payments" ("payment_id", "reservation_id", "amount", "paid_at", "payment_method") VALUES (31, 21, 240, '2027-02-20T14:30:00Z', 'card');
INSERT INTO portfolio."payments" ("payment_id", "reservation_id", "amount", "paid_at", "payment_method") VALUES (32, 22, 510, '2027-03-01T09:15:00+00:00', 'cash');
COMMIT;
