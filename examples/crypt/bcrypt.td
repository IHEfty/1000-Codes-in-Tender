import "crypto"

password := "my_password"

// Hash password with bcrypt
hashed := crypto.bcrypt(password, 10) // cost factor 10
println("bcrypt hash:", string(hashed))
