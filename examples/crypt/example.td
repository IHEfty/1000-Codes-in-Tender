// tender@v0.0.2
import "crypto"

// Hashing examples
data := "Hello, World!"
println("MD5:", crypto.md5(data))
println("SHA256:", crypto.sha256(data))

// HMAC examples
key := "secret"
println("HMAC-SHA256:", crypto.hmac.sha256(key, data))

// AES encryption
aes_key := "0123456789abcdef0123456789abcdef" // 32 bytes
encrypted := crypto.aes.encrypt("secret message", aes_key)
decrypted := crypto.aes.decrypt(encrypted, aes_key)
println("Decrypted:", string(decrypted))

// RSA encryption
rsa_keys := crypto.rsa.generate_key(2048)
encrypted_rsa := crypto.rsa.encrypt("secret", rsa_keys.public)
decrypted_rsa := crypto.rsa.decrypt(encrypted_rsa, rsa_keys.private)
println("RSA Decrypted:", string(decrypted_rsa))

// Digital signatures
ec_keys := crypto.ecdsa.generate_key("p256")
signature := crypto.ecdsa.sign(data, ec_keys.private)
is_valid := crypto.ecdsa.verify(data, signature, ec_keys.public)
println("ECDSA Signature valid:", is_valid)

// Password hashing
password := "my_password"
salt := crypto.random.bytes(16)
argon_hash := crypto.argon2.id(password, salt, 3, 64*1024, 4, 32)
println("Argon2 hash:", argon_hash)

// Random generation
println("Random bytes:", crypto.random.bytes(32))
println("Random int:", crypto.random.int(1, 100))
println("UUID:", crypto.random.uuid())