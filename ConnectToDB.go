package main

import (
	"database/sql"
	"fmt"
	"log"
	"time"

	_ "github.com/lib/pq"
)

type User struct {
	ID       int
	Username string
	Password string
	Phone    string
}

type Message struct {
	ID         int
	Content    string
	SentAt     time.Time
	SenderID   int
	ReceiverID int
}

// ConnectToDB establishes a connection to the PostgreSQL database

func main() {
	connStr := "host=localhost port=5431 user=zak password=secret123 dbname=zak sslmode=disable"
	fmt.Println(connStr)

	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatalf("Error connecting to the database: %v", err)
	}
	defer db.Close()

	err = db.Ping()
	if err != nil {
		log.Fatal("Cannot connect to DB: ", err)
	}
	fmt.Println("Connected to database!")

	// Example: Query all users
	rows, err := db.Query("SELECT id, username, password, phone FROM users")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	for rows.Next() {
		var u User
		err := rows.Scan(&u.ID, &u.Username, &u.Password, &u.Phone)
		if err != nil {
			log.Fatal(err)
		}
		fmt.Printf("User: %#v\n", u)
	}

	// Handle any rows errors
	if err = rows.Err(); err != nil {
		log.Fatal(err)
	}
}
