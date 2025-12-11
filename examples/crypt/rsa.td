// tender@v0.0.2
import "crypto"

// Generate RSA key pair (returns a map with both private and public keys)
key_pair := crypto.rsa.generate_key(2048)
private_key := key_pair.private
public_key := key_pair.public

println("Private key length:", len(private_key))
println("Public key length:", len(public_key))

// Export keys to PEM format
private_key_pem := crypto.rsa.export_key(private_key, "private")
public_key_pem := crypto.rsa.export_key(public_key, "public")

println("Private key PEM:\n", string(private_key_pem))
println("Public key PEM:\n", string(public_key_pem))

// Alternative: export public key from private key
public_key_from_private := crypto.rsa.export_key(private_key, "public")
println("Public key from private:\n", string(public_key_from_private))

data := "Hello, RSA!"

// Encrypt with public key
encrypted := crypto.rsa.encrypt(data, public_key)
println("Encrypted data length:", len(encrypted))

// Decrypt with private key
decrypted := crypto.rsa.decrypt(encrypted, private_key)
println("Decrypted:", string(decrypted))

// Signing
signature := crypto.rsa.sign(data, private_key)
println("Signature length:", len(signature))

// Verification
is_valid := crypto.rsa.verify(data, signature, public_key)
println("Signature valid:", is_valid)

// Test with PEM keys
encrypted2 := crypto.rsa.encrypt(data, public_key_pem)
decrypted2 := crypto.rsa.decrypt(encrypted2, private_key_pem)
println("Decrypted with PEM keys:", string(decrypted2))

// Import keys (if you have them in PEM)
imported_private_key := crypto.rsa.import_key(private_key_pem, "private")
imported_public_key := crypto.rsa.import_key(public_key_pem, "public")
println("Import successful - private:", len(imported_private_key), "public:", len(imported_public_key))