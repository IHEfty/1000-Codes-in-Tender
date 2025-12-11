// tender@v0.0.2
import "crypto"

data := "Hello, World!"

// MD5
md5_hash := crypto.md5(data)
println("MD5:", md5_hash)

// SHA1
sha1_hash := crypto.sha1(data)
println("SHA1:", sha1_hash)

// SHA256
sha256_hash := crypto.sha256(data)
println("SHA256:", sha256_hash)

// SHA512
sha512_hash := crypto.sha512(data)
println("SHA512:", sha512_hash)

// SHA3-256
sha3_256_hash := crypto.sha3_256(data)
println("SHA3-256:", sha3_256_hash)

// Other hashes
sha224_hash := crypto.sha224(data)
sha384_hash := crypto.sha384(data)
sha3_224_hash := crypto.sha3_224(data)
sha3_384_hash := crypto.sha3_384(data)
sha3_512_hash := crypto.sha3_512(data)
blake2b_256_hash := crypto.blake2b_256(data)
blake2b_512_hash := crypto.blake2b_512(data)

println("SHA224:", sha224_hash)
println("SHA384:", sha384_hash)
println("SHA3-224:", sha3_224_hash)
println("SHA3-384:", sha3_384_hash)
println("SHA3-512:", sha3_512_hash)
println("BLAKE2b-256:", blake2b_256_hash)
println("BLAKE2b-512:", blake2b_512_hash)