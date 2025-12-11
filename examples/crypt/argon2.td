import "crypto"

password := "my_password"
salt := "some_salt"

// Argon2id
argon2id_hash := crypto.argon2.id(password, salt, 1, 64*1024, 4, 32)
println("Argon2id hash:", argon2id_hash)

// Argon2i
argon2i_hash := crypto.argon2.i(password, salt, 1, 64*1024, 4, 32)
println("Argon2i hash:", argon2i_hash)