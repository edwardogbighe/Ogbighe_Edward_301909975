# Hotel Reservation System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| guest_id | reservations records (list) |
| --- | --- |
| 1 | [21] |
| 2 | [22] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| reservations.reservation_id | reservations.guest_id | reservations.room_id | reservations.status | guests.guest_id | guests.full_name | rooms.room_id | rooms.room_number |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 21 | 1 | 11 | confirmed | 1 | Avery Morgan | 11 | 101 |
| 22 | 2 | 12 | confirmed | 2 | Jordan Lee | 12 | 202 |

Key: reservation_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## reservations_example

| reservations.reservation_id | reservations.guest_id | reservations.room_id | reservations.status | guests.guest_id | guests.full_name | rooms.room_id | rooms.room_number |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 21 | 1 | 11 | confirmed | 1 | Avery Morgan | 11 | 101 |
| 22 | 2 | 12 | confirmed | 2 | Jordan Lee | 12 | 202 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## guests

| guest_id | full_name | email |
| --- | --- | --- |
| 1 | Avery Morgan | avery.morgan@example.test |
| 2 | Jordan Lee | jordan.lee@example.test |

## rooms

| room_id | room_number | room_type | capacity |
| --- | --- | --- | --- |
| 11 | 101 | standard | 2 |
| 12 | 202 | suite | 4 |

## reservations

| reservation_id | guest_id | room_id | check_in | check_out | status |
| --- | --- | --- | --- | --- | --- |
| 21 | 1 | 11 | 2027-03-10 | 2027-03-13 | confirmed |
| 22 | 2 | 12 | 2027-04-05 | 2027-04-08 | confirmed |

## payments

| payment_id | reservation_id | amount | paid_at | payment_method |
| --- | --- | --- | --- | --- |
| 31 | 21 | 240 | 2027-02-20T14:30:00+00:00 | card |
| 32 | 22 | 510 | 2027-03-01T09:15:00+00:00 | cash |

## Dependencies

- guests: (guest_id) → full_name, email
- rooms: (room_id) → room_number, room_type, capacity
- reservations: (reservation_id) → guest_id, room_id, check_in, check_out, status
- payments: (payment_id) → reservation_id, amount, paid_at, payment_method

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
