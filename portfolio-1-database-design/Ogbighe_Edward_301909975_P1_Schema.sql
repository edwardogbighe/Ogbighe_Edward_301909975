-- Hotel Reservation System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."guests" (
  "guest_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  CONSTRAINT "pk_guests" PRIMARY KEY ("guest_id"),
  CONSTRAINT "uq_guests_0" UNIQUE ("email")
);
CREATE TABLE portfolio."rooms" (
  "room_id" bigint NOT NULL,
  "room_number" text NOT NULL,
  "room_type" text NOT NULL,
  "capacity" bigint NOT NULL,
  CONSTRAINT "pk_rooms" PRIMARY KEY ("room_id"),
  CONSTRAINT "uq_rooms_0" UNIQUE ("room_number")
);
CREATE TABLE portfolio."reservations" (
  "reservation_id" bigint NOT NULL,
  "guest_id" bigint NOT NULL,
  "room_id" bigint NOT NULL,
  "check_in" date NOT NULL,
  "check_out" date NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_reservations" PRIMARY KEY ("reservation_id")
);
CREATE TABLE portfolio."payments" (
  "payment_id" bigint NOT NULL,
  "reservation_id" bigint NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "paid_at" timestamptz NOT NULL,
  "payment_method" text NOT NULL,
  CONSTRAINT "pk_payments" PRIMARY KEY ("payment_id")
);
ALTER TABLE portfolio."reservations" ADD CONSTRAINT "fk_reservations_0" FOREIGN KEY ("guest_id") REFERENCES portfolio."guests" ("guest_id");
ALTER TABLE portfolio."reservations" ADD CONSTRAINT "fk_reservations_1" FOREIGN KEY ("room_id") REFERENCES portfolio."rooms" ("room_id");
ALTER TABLE portfolio."payments" ADD CONSTRAINT "fk_payments_0" FOREIGN KEY ("reservation_id") REFERENCES portfolio."reservations" ("reservation_id");
ALTER TABLE portfolio."rooms" ADD CONSTRAINT "room_capacity_positive" CHECK ("capacity" > 0);
ALTER TABLE portfolio."reservations" ADD CONSTRAINT "reservation_dates_ordered" CHECK ("check_out" > "check_in");
ALTER TABLE portfolio."reservations" ADD CONSTRAINT "reservation_status_allowed" CHECK (("status" = 'confirmed') OR ("status" = 'cancelled'));
CREATE UNIQUE INDEX "confirmed_room_checkin_partial_unique" ON portfolio."reservations" ("room_id", "check_in") WHERE ("status" = 'confirmed');
ALTER TABLE portfolio."payments" ADD CONSTRAINT "payment_amount_positive" CHECK ("amount" > 0);
COMMIT;
