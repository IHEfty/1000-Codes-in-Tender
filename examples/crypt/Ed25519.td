import "crypto"

// Generate Ed25519 key pair
key_pair := crypto.ed25519.generate_key()
public_key := key_pair.public
private_key := key_pair.private

println("Ed25519 Public key length:", len(public_key))
println("Ed25519 Private key length:", len(private_key))

data := "Hello, Ed25519!"

// Sign
signature := crypto.ed25519.sign(data, private_key)
println("Ed25519 Signature length:", len(signature))

// Verify
is_valid := crypto.ed25519.verify(data, signature, public_key)
println("Ed25519 Signature valid:", is_valid)