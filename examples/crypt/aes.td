// tender@v0.0.2
import "crypto"

key := "0123456789abcdef0123456789abcdef" // 32 bytes for AES-256
data := "Sensitive data to encrypt"

// Encrypt
encrypted := crypto.aes.encrypt(data, key)
println("Encrypted:", encrypted)

// Decrypt
decrypted := crypto.aes.decrypt(encrypted, key)
println("Decrypted:", string(decrypted))

// Using bytes for key and data
key_bytes := [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f] // 16 bytes for AES-128
data_bytes := [0x48, 0x65, 0x6c, 0x6c, 0x6f] // "Hello"

encrypted_bytes := crypto.aes.encrypt(data_bytes, key_bytes)
decrypted_bytes := crypto.aes.decrypt(encrypted_bytes, key_bytes)

println("Decrypted bytes:", decrypted_bytes)