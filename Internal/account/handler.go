package account

import (
	"crypto/rand"
	"errors"
	"fmt"
	"math/big"
)

var accounts = make(map[string]Account)

func CreateAccount(username, password, phone string) (Account, error) {
	if username == "" || password == "" || phone == "" {
		return Account{}, errors.New("username and password and phone cannot be empty")
	}
	if _, exists := accounts[username]; exists {
		return Account{}, errors.New("account already exists")
	}

	// Generate a unique ID for the account
	zId, err := generateID()
	if err != nil {
		return Account{}, fmt.Errorf("error generating ID: %w", err)
	}
	account := Account{
		ID:       zId,
		Username: username,
		Password: password,
	}
	accounts[username] = account
	return account, nil
}

func generateID() (string, error) {
	max := big.NewInt(100000000) // 10^8
	id, err := rand.Int(rand.Reader, max)
	if err != nil {
		return "", err
	}
	fmt.Printf("Generated ID: %d\n", id.Int64())
	// Format with leading zeros if needed
	return fmt.Sprintf("%08d", id.Int64()), nil
}
