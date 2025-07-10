# 📩 zMessages

A lightweight messaging backend built with Go, PostgreSQL, and a SwiftUI frontend. This app allows users to create accounts, send messages, and view conversations — all locally hosted and simple to extend.

---

## ⚙️ Tech Stack

- **Go (Golang)** — REST API server
- **PostgreSQL** — Relational database for users and messages
- **SwiftUI** — iOS frontend (in separate repo)
- **Gin** — HTTP web framework for Go
- **PostgreSQL.app** — For local DB management

---

## 🗂 Project Structure

```bash
zMessages/
├── ConnectToDB.go                   # App entrypoint (starts server, connects to DB)
├── account/                  # Account logic (handlers, models, services)
│   ├── handler.go
│   ├── model.go
│   └── service.go
├── messages/                 # Messaging logic (optional)
├── go.mod / go.sum           # Go module and dependency tracking


🧪 How to Run
1. Clone the repo
git clone https://github.com/zak-hi/zMessages.git
cd zMessages

2. Set up the PostgreSQL DB
Using Postgres.app, create a local database called zMessage_DB on port 5431.

Inside that DB, run:

sql
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
3. Run the Go server
bash
Copy
Edit
go run ConnectToDB.go
Server will run at: http://localhost:8080

🚀 API Endpoints
➕ Create Account
http
Copy
Edit
POST /create-account
Body:

json
{
  "username": "zak",
  "password": "mypassword",
  "phone": "1234567890"
}
💬 Send Message
http
POST /send-message
Body:

json
{
  "content": "Hello there!",
  "sender_id": 1,
  "receiver_id": 2
}
📥 Get Messages Between Two Users
http
GET /messages?user1=1&user2=2
👥 Get All Users
http
Copy
Edit
GET /users
📱 iOS Frontend
To run the frontend locally, set the backend up and run the xproj file.
If desired to run on personal device then change the endpoint address to the local IP

🙋‍♂️ Author
Built by Zak Lalani
