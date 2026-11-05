# Hotel Reservation System — database design

My case study records guests, rooms, reservations, payments.

## Users

- Front-desk staff manage synthetic guest and reservation records.
- Managers review room reservations and payment summaries.

## Main operations

- Create a reservation for a guest and room, then commit it if its references and constraints are valid.
- Cancel a reservation by changing its status; roll back the change if it is unintended.
- Separate benchmark plan: generate 20000 synthetic reservations, run the same check-in date-range filter before and after adding a B-tree index, and compare query plans and measured latency without assuming an outcome.

## Entities

| Entity | Information stored |
| --- | --- |
| guests | Stores synthetic guest contact details. |
| rooms | Stores the hotel's synthetic room inventory. |
| reservations | Connects one guest to one room for a dated stay. |
| payments | Records synthetic payments associated with reservations. |

## guests

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| guest_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
- Unique key: (email).

## rooms

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| room_id | BIGINT | PK | Yes |
| room_number | TEXT | Unique | Yes |
| room_type | TEXT |  | Yes |
| capacity | INTEGER |  | Yes |
- Unique key: (room_number).

## reservations

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| reservation_id | BIGINT | PK | Yes |
| guest_id | BIGINT | FK | Yes |
| room_id | BIGINT | FK | Yes |
| check_in | DATE |  | Yes |
| check_out | DATE |  | Yes |
| status | TEXT |  | Yes |
- guest_id → guests.guest_id
- room_id → rooms.room_id

## payments

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| payment_id | BIGINT | PK | Yes |
| reservation_id | BIGINT | FK | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| paid_at | TIMESTAMPTZ |  | Yes |
| payment_method | TEXT |  | Yes |
- reservation_id → reservations.reservation_id

## Relationships and business rules

- Each guest email identifies at most one guest.
- Each room number identifies at most one room.
- Room capacity must be greater than zero.
- Each reservation guest_id must reference guests.guest_id.
- Each reservation room_id must reference rooms.room_id.
- A reservation must have check_out later than check_in.
- Reservation status must be confirmed or cancelled.
- For confirmed reservations only, at most one reservation may have the same room_id and check_in.
- Each payment reservation_id must reference reservations.reservation_id.
- A recorded payment amount must be greater than zero.

## Assumptions

- All records use synthetic data, and a shared identifier allocator makes primary-key values globally unique across entity tables.
- Each reservation refers to exactly one guest and one room; each payment refers to exactly one reservation.
- A reservation occupies the half-open date interval from check_in through, but not including, check_out.
- The partial uniqueness rule prevents two confirmed reservations for the same room and check-in date; it does not detect every overlapping stay interval.
- Reservation statuses are confirmed or cancelled, and only confirmed reservations are subject to the partial unique rule.
- Payments are recorded against a reservation and are not assumed to represent refunds or split tender.

