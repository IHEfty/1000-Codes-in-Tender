// tender@v0.0.2
import "crypto"

key := "secret_key"
data := "Hello, World!"

// HMAC with different hash functions
hmac_md5 := crypto.hmac.md5(key, data)
hmac_sha1 := crypto.hmac.sha1(key, data)
hmac_sha256 := crypto.hmac.sha256(key, data)
hmac_sha384 := crypto.hmac.sha384(key, data)
hmac_sha512 := crypto.hmac.sha512(key, data)
hmac_sha3_256 := crypto.hmac.sha3_256(key, data)
hmac_sha3_512 := crypto.hmac.sha3_512(key, data)

println("HMAC-MD5:", hmac_md5)
println("HMAC-SHA1:", hmac_sha1)
println("HMAC-SHA256:", hmac_sha256)
println("HMAC-SHA384:", hmac_sha384)
println("HMAC-SHA512:", hmac_sha512)
println("HMAC-SHA3-256:", hmac_sha3_256)
println("HMAC-SHA3-512:", hmac_sha3_512)