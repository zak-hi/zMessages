# 📱 iPhone Messaging App (Backend)

This is the backend for an iOS messaging application, built using **Go (Golang)**, **PostgreSQL**, and integrates with a **Swift** frontend.

---

## Tech Stack

- **Backend Language:** Go (Golang)
- **Database:** PostgreSQL
- **Frontend:** Swift (iOS app)
- **API Format:** JSON over HTTP (RESTful)

---

##  Database Setup

You’ll need to set up a local PostgreSQL database with the following tables:

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    phone TEXT NOT NULL
);

CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    sent_at TIMESTAMP NOT NULL,
    sender_id INTEGER NOT NULL REFERENCES users(id),
    receiver_id INTEGER NOT NULL REFERENCES users(id)
);
