// tender@v0.0.2
import "crypto"

// Generate ECDSA key pair (using P256 curve)
key_pair := crypto.ecdsa.generate_key("p256")
private_key := key_pair.private
public_key := key_pair.public

println("ECDSA Private key generated, length:", len(private_key))
println("ECDSA Public key generated, length:", len(public_key))

// Export keys to PEM
private_key_pem := crypto.ecdsa.export_key(private_key, "private")
public_key_pem := crypto.ecdsa.export_key(public_key, "public") // Use the actual public key

println("Private key PEM:\n", string(private_key_pem))
println("Public key PEM:\n", string(public_key_pem))

data := "Hello, ECDSA!"

// Sign data
signature := crypto.ecdsa.sign(data, private_key)
println("ECDSA Signature length:", len(signature))

// Verify with the actual public key
is_valid := crypto.ecdsa.verify(data, signature, public_key)
println("ECDSA Signature valid:", is_valid)

// Also test with PEM public key
is_valid_pem := crypto.ecdsa.verify(data, signature, public_key_pem)
println("ECDSA Signature valid (PEM):", is_valid_pem)

// Using other curves
key_pair_p384 := crypto.ecdsa.generate_key("p384")
key_pair_p521 := crypto.ecdsa.generate_key("p521")

println("P384 private key length:", len(key_pair_p384.private))
println("P521 private key length:", len(key_pair_p521.private))