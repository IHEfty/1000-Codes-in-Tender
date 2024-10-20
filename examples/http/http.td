import "http"

// GET request
response := http.get("https://example.com")
if !is_error(response) {
    println(string(response))
} 
else {
    println("Response: ", response)
}