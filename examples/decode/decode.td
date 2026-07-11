crypto := import("crypto")
base64 := import("base64")

ciphertext_b64 := "wooh"
key_input := "wooh"

// 1. Decode the base64 encrypted data
ciphertext := base64.decode(ciphertext_b64)

// 2. Hash the key with MD5 (produces a hex string key)
key := crypto.md5(key_input)

// 3. Decrypt using AES
decrypted_bytes := crypto.aes.decrypt(ciphertext, key)

// 4. Convert decrypted bytes to string and print
decrypted_text := string(decrypted_bytes)
println("Passphrase:", decrypted_text)
