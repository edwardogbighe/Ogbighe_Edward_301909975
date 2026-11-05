// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("reservation_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("reservation_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "reservation_created",
                    "reservation_cancelled"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "payments"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "payment_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("reservation_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "reservation_cancelled",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "special_requests": "illustrative special_requests",
                "payment_metadata": "illustrative payment_metadata"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "reservation_created",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "payments",
            "key": {
                "payment_id": 32
            },
            "snapshot": {
                "payment_id": 32,
                "reservation_id": 22,
                "amount": 510,
                "paid_at": "2027-03-01T09:15:00+00:00",
                "payment_method": "cash"
            }
        },
        "embedded": {
            "guests": [
                {
                    "key": {
                        "guest_id": 2
                    },
                    "snapshot": {
                        "guest_id": 2,
                        "full_name": "Jordan Lee",
                        "email": "jordan.lee@example.test"
                    },
                    "via": [
                        "payments.reservation_id → reservations.guest_id → guests"
                    ]
                }
            ],
            "rooms": [
                {
                    "key": {
                        "room_id": 12
                    },
                    "snapshot": {
                        "room_id": 12,
                        "room_number": "202",
                        "room_type": "suite",
                        "capacity": 4
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
                        "reservation_id": 22
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
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "reservation_cancelled",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "payments",
            "key": {
                "payment_id": 32
            },
            "snapshot": {
                "payment_id": 32,
                "reservation_id": 22,
                "amount": 510,
                "paid_at": "2027-03-01T09:15:00+00:00",
                "payment_method": "cash"
            }
        },
        "embedded": {
            "guests": [
                {
                    "key": {
                        "guest_id": 2
                    },
                    "snapshot": {
                        "guest_id": 2,
                        "full_name": "Jordan Lee",
                        "email": "jordan.lee@example.test"
                    },
                    "via": [
                        "payments.reservation_id → reservations.guest_id → guests"
                    ]
                }
            ],
            "rooms": [
                {
                    "key": {
                        "room_id": 12
                    },
                    "snapshot": {
                        "room_id": 12,
                        "room_number": "202",
                        "room_type": "suite",
                        "capacity": 4
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
                        "reservation_id": 22
                    },
                    "via": [
                        "payments.reservation_id → reservations"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "special_requests": "illustrative special_requests",
                "payment_metadata": "illustrative payment_metadata"
            }
        }
    }
]));
  await db.getCollection("reservation_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("reservation_events").find({"eventType":"reservation_created"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("reservation_events").find({"source.key.payment_id":31}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("reservation_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("reservation_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("reservation_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("reservation_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("reservation_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
