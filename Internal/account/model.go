package account

type Account struct {
	ID       string `json:"id" binding:"required,len=8,numeric"`     // 8 digits exactly
	Username string `json:"username" binding:"required,min=3"`       // min length 3
	Password string `json:"password" binding:"required,min=5"`       // min length 5
	Phone    string `json:"phone" binding:"required,len=10,numeric"` // exactly 10 digits
}
