package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
)

type User struct {
	ID       int
	Username string
	Password string
	Phone    string
}

type Message struct {
	ID          int
	Content     string
	SentAt      time.Time
	Sender_id   int
	Receiver_id int
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

	router := gin.Default()
	router.POST("/add-user", func(c *gin.Context) {
		var newUser User
		if err := c.ShouldBindJSON(&newUser); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
			return
		}

		// Basic validation
		if len(newUser.Username) < 3 || len(newUser.Password) < 5 || len(newUser.Phone) != 10 {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Validation failed"})
			return
		}

		// Insert user
		query := `INSERT INTO users (username, password, phone) VALUES ($1, $2, $3) RETURNING id`
		err := db.QueryRow(query, newUser.Username, newUser.Password, newUser.Phone).Scan(&newUser.ID) //will fail if the user already exists
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to insert user"})
			return
		}

		c.JSON(http.StatusCreated, gin.H{
			"message": "User created",
			"user":    newUser,
		})
	})

	router.POST("/send-message", func(c *gin.Context) {
		var msg Message
		if err := c.ShouldBindJSON(&msg); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
			return
		}
		if msg.Sender_id <= 0 || msg.Receiver_id <= 0 || msg.Content == "" { //eventually diff message for each return
			c.JSON(http.StatusBadRequest, gin.H{"error": "Validation failed"})
			return
		}

		query := `INSERT INTO messages (content, sent_at, sender_id, receiver_id) VALUES ($1, $2, $3, $4) RETURNING id`
		err := db.QueryRow(query, msg.Content, time.Now(), msg.Sender_id, msg.Receiver_id).Scan(&msg.ID)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to send message"})
		}
		c.JSON(http.StatusCreated, gin.H{
			"message": "Message sent",
			"msg":     msg,
		})

	})

	router.GET("/messages", func(c *gin.Context) {
		rows, err := db.Query("SELECT id, content, sent_at, sender_id, receiver_id FROM messages")
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch messages"})
			return
		}
		defer rows.Close()

		var messages []Message
		for rows.Next() {
			var msg Message
			if err := rows.Scan(&msg.ID, &msg.Content, &msg.SentAt, &msg.Sender_id, &msg.Receiver_id); err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to scan message"})
				return
			}
			messages = append(messages, msg)
		}

		c.JSON(http.StatusOK, messages)

	})

	router.GET("/converstation", func(c *gin.Context) {
		senderID := c.Query("user1")
		receiverID := c.Query("user2") //this is what adds it to the header the ideal query looks like http://localhost:8080/converstation?user1=1&user2=3

		if senderID == "" || receiverID == "" { //this may cause an issue
			c.JSON(http.StatusBadRequest, gin.H{"error": "Missing user IDs"})
			return
		}

		rows, err := db.Query(`SELECT content, sent_at, sender_id, receiver_id FROM messages WHERE (sender_id = $1 AND receiver_id = $2) OR (sender_id = $2 AND receiver_id = $1)`, senderID, receiverID)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch conversation"})
			return
		}
		defer rows.Close()

		var messages []Message //create a message item that we use to scan over the other rows in the DB
		for rows.Next() {
			var msg Message
			if err := rows.Scan(&msg.Content, &msg.SentAt, &msg.Sender_id, &msg.Receiver_id); err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to scan message"})
				return
			}
			messages = append(messages, msg)
		}
		c.JSON(http.StatusOK, messages) //return OK if succeed
	})
	router.GET("/users", func(c *gin.Context) {
		rows, err := db.Query("SELECT id, username, password, phone FROM users")
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch users"})
			return
		}
		defer rows.Close()

		var users []User
		for rows.Next() {
			var user User
			if err := rows.Scan(&user.ID, &user.Username, &user.Password, &user.Phone); err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to scan user"})
				return
			}
			users = append(users, user)
		}

		c.JSON(http.StatusOK, users)
	})

	router.Run(":8080")
}
