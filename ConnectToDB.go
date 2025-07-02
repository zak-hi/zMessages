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

	router.GET("/users", func(c *gin.Context) {
		rows, err := db.Query("SELECT id, username, phone FROM users")
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch users"})
			return
		}
		defer rows.Close()

		var users []User
		for rows.Next() {
			var user User
			if err := rows.Scan(&user.ID, &user.Username, &user.Phone); err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to scan user"})
				return
			}
			users = append(users, user)
		}

		c.JSON(http.StatusOK, users)
	})
	router.Run(":8080")
}
