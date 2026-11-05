# Hotel Reservation System — ER diagram

```mermaid
erDiagram
    direction LR
    guests {
        bigint guest_id PK
        text full_name
        text email UK
    }
    rooms {
        bigint room_id PK
        text room_number UK
        text room_type
        integer capacity
    }
    reservations {
        bigint reservation_id PK
        bigint guest_id FK
        bigint room_id FK
        date check_in
        date check_out
        text status
    }
    payments {
        bigint payment_id PK
        bigint reservation_id FK
        numeric amount
        timestamptz paid_at
        text payment_method
    }
    guests ||--o{ reservations : "guest_id"
    rooms ||--o{ reservations : "room_id"
    reservations ||--o{ payments : "reservation_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Ogbighe_Edward_301909975_ERDiagram.png)
