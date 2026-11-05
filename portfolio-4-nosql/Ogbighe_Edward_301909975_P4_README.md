# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection reservation_events for reservation_created and reservation_cancelled events. These are fictional event examples based on reservations, guests, rooms, payments.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related guests, rooms details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "reservation_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "payments",
        "key": {
            "payment_id": 31
        },
        "snapshot": {
            "payment_id": 31,
            "reservation_id": 21,
            "amount": 240,
            "paid_at": "2027-02-20T14:30:00Z",
            "payment_method": "card"
        }
    },
    "embedded": {
        "guests": [
            {
                "key": {
                    "guest_id": 1
                },
                "snapshot": {
                    "guest_id": 1,
                    "full_name": "Avery Morgan",
                    "email": "avery.morgan@example.test"
                },
                "via": [
                    "payments.reservation_id → reservations.guest_id → guests"
                ]
            }
        ],
        "rooms": [
            {
                "key": {
                    "room_id": 11
                },
                "snapshot": {
                    "room_id": 11,
                    "room_number": "101",
                    "room_type": "standard",
                    "capacity": 2
                },
                "via": [
                    "payments.reservation_id → reservations.room_id → rooms"
                ]
            }
        ]
    },
    "references": {
        "reservations": [
            {
                "key": {
                    "reservation_id": 21
                },
                "via": [
                    "payments.reservation_id → reservations"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 2 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 4 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("reservation_events").find({"eventType":"reservation_created"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "reservation_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "payment_id": 31
    }
  },
  {
    "_id": "event_000003",
    "eventType": "reservation_created",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "payment_id": 32
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("reservation_events").find({"source.key.payment_id":31}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "reservation_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "payment_id": 31
    }
  },
  {
    "_id": "event_000002",
    "eventType": "reservation_cancelled",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "payment_id": 31
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("reservation_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "reservation_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "payment_id": 31
    }
  },
  {
    "_id": "event_000002",
    "eventType": "reservation_cancelled",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "payment_id": 31
    }
  },
  {
    "_id": "event_000003",
    "eventType": "reservation_created",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "payment_id": 32
    }
  },
  {
    "_id": "event_000004",
    "eventType": "reservation_cancelled",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "payment_id": 32
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("reservation_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| reservation_cancelled | 2 |
| reservation_created | 2 |

## Validation and suitability

MongoDB inserted 4 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 4 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Ogbighe_Edward_301909975_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Ogbighe_Edward_301909975_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

