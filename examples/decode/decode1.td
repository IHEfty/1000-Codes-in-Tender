crypto := import("crypto")
base64 := import("base64")
bufio := import("bufio")
strings := import("strings")

print("Enter Ciphertext: ")
ciphertext_b64 := strings.trim_space(bufio.readline())

print("Enter Key: ")
key_input := strings.trim_space(bufio.readline())

// 1. Decode the base64 encrypted data
ciphertext := base64.decode(ciphertext_b64)

// 2. Hash the key with MD5 (produces a hex string key)
key := crypto.md5(key_input)

// 3. Decrypt using AES
decrypted_bytes := crypto.aes.decrypt(ciphertext, key)

// 4. Convert to string and print
println("\nDecrypted Passphrase:", string(decrypted_bytes))
