-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. guest primary key. Expected: pk_guests, SQLSTATE 23505.
INSERT INTO portfolio."guests" ("guest_id", "full_name", "email")
VALUES (1, 'Casey Park', 'casey.park@example.test');

-- 2. guest unique email. Expected: uq_guests_0, SQLSTATE 23505.
INSERT INTO portfolio."guests" ("guest_id", "full_name", "email")
VALUES (105, 'Casey Park', 'avery.morgan@example.test');

-- 3. room primary key. Expected: pk_rooms, SQLSTATE 23505.
INSERT INTO portfolio."rooms" ("room_id", "room_number", "room_type", "capacity")
VALUES (11, '303', 'standard', 2);

-- 4. room unique number. Expected: uq_rooms_0, SQLSTATE 23505.
INSERT INTO portfolio."rooms" ("room_id", "room_number", "room_type", "capacity")
VALUES (106, '101', 'standard', 2);

-- 5. reservation primary key. Expected: pk_reservations, SQLSTATE 23505.
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status")
VALUES (21, 1, 11, '2027-05-01', '2027-05-03', 'confirmed');

-- 6. reservation guest foreign key. Expected: fk_reservations_0, SQLSTATE 23503.
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status")
VALUES (102, 999, 11, '2027-05-01', '2027-05-03', 'confirmed');

-- 7. reservation room foreign key. Expected: fk_reservations_1, SQLSTATE 23503.
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status")
VALUES (103, 1, 998, '2027-05-04', '2027-05-06', 'confirmed');

-- 8. payment primary key. Expected: pk_payments, SQLSTATE 23505.
INSERT INTO portfolio."payments" ("payment_id", "reservation_id", "amount", "paid_at", "payment_method")
VALUES (31, 21, 125, '2027-05-01T12:00:00Z', 'card');

-- 9. payment reservation foreign key. Expected: fk_payments_0, SQLSTATE 23503.
INSERT INTO portfolio."payments" ("payment_id", "reservation_id", "amount", "paid_at", "payment_method")
VALUES (104, 997, 125, '2027-05-01T12:00:00Z', 'card');

-- 10. room capacity check. Expected: room_capacity_positive, SQLSTATE 23514.
INSERT INTO portfolio."rooms" ("room_id", "room_number", "room_type", "capacity")
VALUES (107, '303', 'standard', 0);

-- 11. reservation dates check. Expected: reservation_dates_ordered, SQLSTATE 23514.
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status")
VALUES (108, 1, 12, '2027-06-03', '2027-06-02', 'confirmed');

-- 12. reservation status check. Expected: reservation_status_allowed, SQLSTATE 23514.
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status")
VALUES (109, 2, 11, '2027-06-01', '2027-06-03', 'pending');

-- 13. confirmed room checkin unique. Expected: confirmed_room_checkin_partial_unique, SQLSTATE 23505.
INSERT INTO portfolio."reservations" ("reservation_id", "guest_id", "room_id", "check_in", "check_out", "status")
VALUES (110, 2, 11, '2027-03-10', '2027-03-12', 'confirmed');

-- 14. payment amount check. Expected: payment_amount_positive, SQLSTATE 23514.
INSERT INTO portfolio."payments" ("payment_id", "reservation_id", "amount", "paid_at", "payment_method")
VALUES (111, 21, 0, '2027-05-02T12:00:00Z', 'card');

-- 15. guest full name not null. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."guests" ("guest_id", "full_name", "email")
VALUES (112, NULL, 'casey.park@example.test');
