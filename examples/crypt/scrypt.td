import "crypto"

password := "my_password"
salt := "some_salt"

// Derive key using scrypt
key := crypto.scrypt(password, salt, 32, 16384, 8, 1)
println("scrypt derived key (hex):", key)