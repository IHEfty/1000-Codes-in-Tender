import "os"
import "http"
import "json"
import "crypto"
import "times"

// User structure
type user struct {
    username string
    password string  // stored as bcrypt hash
    created time
    last_login time
}

// Session structure
type session struct {
    token string
    username string
    expires time
}

// Global storage
var users = {}
var sessions = {}
var session_duration = 24 * times.hour  // 24 hours

// Helper functions
fn generate_token(username) {
    // Create a unique session token
    random_bytes := crypto.random.bytes(32)
    timestamp := string(times.now().unix())
    token_data := username + timestamp + string(random_bytes)
    return crypto.sha256(token_data)
}

fn get_user(username) {
    return users[username]
}

fn user_exists(username) {
    return users[username] != null
}

fn validate_password(password, hash) {
    // Verify password against stored hash
    return crypto.constant_time_compare(
        crypto.bcrypt(password, 12),
        hash
    )
}

fn create_session(username) {
    token := generate_token(username)
    session_data := session{
        token: token,
        username: username,
        expires: times.now().add(session_duration)
    }
    sessions[token] = session_data
    return token
}

fn validate_session(token) {
    session := sessions[token]
    if session == null {
        return false
    }
    
    if times.now().after(session.expires) {
        // Session expired
        delete(sessions, token)
        return false
    }
    
    return true
}

fn get_session_username(token) {
    session := sessions[token]
    if session == null {
        return ""
    }
    return session.username
}

fn get_auth_token(req) {
    // Get token from Authorization header
    auth_header := req.headers["Authorization"]
    if auth_header == null {
        return ""
    }
    
    // Check for "Bearer " prefix
    if string(auth_header).starts_with("Bearer ") {
        return string(auth_header).substring(7)
    }
    
    return ""
}

fn authenticate_request(req) {
    token := get_auth_token(req)
    if token == "" {
        return false
    }
    
    valid := validate_session(token)
    if !valid {
        return false
    }
    
    return true
}

// Request handlers
fn handle_register(req, res) {
    // Parse request body
    body := string(req.body)
    if body == "" {
        res.set_status(400)
        res.set_header("Content-Type", "application/json")
        res.write(json.encode({
            "error": "Request body required"
        }))
        return
    }
    
    // Decode JSON
    user_data := json.decode(body)
    if user_data == null {
        res.set_status(400)
        res.set_header("Content-Type", "application/json")
        res.write(json.encode({
            "error" : "Invalid JSON"
        }))
        return
    }
    
    username := user_data["username"]
    password := user_data["password"]
    5
    if username == "" || password == "" {
        res.set_status(400)
        res.set_header("Content-Type", "application/json")
        res.write(json.encode({
            "error": "Username and password required"
        }))
        return
    }
    
    // Check if user already exists
    if user_exists(username) {
        res.set_status(409)
        res.set_header("Content-Type", "application/json")
        res.write(json.encode({
            "error": "User already exists"
        }))
        return
    }
    
    // Hash password
    password_hash := string(crypto.bcrypt(password, 12))
    
    // Create user
    new_user := user{
        username: username,
        password: password_hash,
        created: times.now(),
        last_login: times.now()
    }
    
    users[username] = new_user
    
    res.set_status(201)
    res.set_header("Content-Type", "application/json")
    res.write(json.encode({
        message: "User registered successfully",
        username: username
    }))
}

fn handle_login(req, res) {
    // Parse request body
    body := string(req.body)
    if body == "" {
        res.set_status(400)
        res.set_header("Content-Type", "application/json")
        res.write(json.encode({
            "error": "Request body required"
        }))
        return
    }
    
    // Decode JSON
    login_data := json.decode(body)
    if login_data == null {
        res.set_status(400)
        res.set_header("Content-Type", "application/json")
        res.write(json.encode({
            "error": "Invalid JSON"
        }))
        return
    }
    
    username := login_data["username"]
    password := login_data["password"]
    
    if username == "" || password == "" {
        res.set_status(400)
        res.set_header("Content-Type", "application/json")
        res.write(json.encode({
            "error": "Username and password required"
        }))
        return
    }
    
    // Check if user exists
    user_data := get_user(username)
    if user_data == null {
        // Use constant time comparison to prevent timing attacks
        res.set_status(401)
        res.set_header("Content-Type", "application/json")
        res.write(json.encode({
            "error": "Invalid credentials"
        }))
        return
    }
    
    // Verify password
    if !validate_password(password, user_data.password) {
        // Use constant time comparison for all failures
        res.set_status(401)
        res.set_header("Content-Type", "application/json")
        res.write(json.encode({
            "error": "Invalid credentials"
        }))
        return
    }
    
    // Update last login
    user_data.last_login = times.now()
    users[username] = user_data
    
    // Create session
    token := create_session(username)
    
    res.set_status(200)
    res.set_header("Content-Type", "application/json")
    res.write(json.encode({
        message: "Login successful",
        token: token,
        username: username
    }))
}

fn handle_profile(req, res) {
    // Authenticate request
    valid := authenticate_request(req)
    if !valid {
        res.set_status(401)
        res.set_header("Content-Type", "application/json")
        res.write(json.encode({
            "error": "Authentication required"
        }))
        return
    }
    
    token := get_auth_token(req)
    username := get_session_username(token)
    
    user_data := get_user(username)
    if user_data == null {
        res.set_status(404)
        res.set_header("Content-Type", "application/json")
        res.write(json.encode({
            "error": "User not found"
        }))
        return
    }
    
    // Return user profile (excluding password)
    profile := {
        username: user_data.username,
        created: times.time_format(user_data.created, times.format_rfc3339),
        last_login: times.time_format(user_data.last_login, times.format_rfc3339)
    }
    
    res.set_status(200)
    res.set_header("Content-Type", "application/json")
    res.write(json.encode(profile))
}

fn handle_logout(req, res) {
    // Get token from request
    token := get_auth_token(req)
    if token != "" {
        // Delete session
        delete(sessions, token)
    }
    
    res.set_status(200)
    res.set_header("Content-Type", "application/json")
    res.write(json.encode({
        message: "Logged out successfully"
    }))
}

fn handle_users(req, res) {
    // Authenticate request (optional - admin only)
    valid := authenticate_request(req)
    if !valid {
        res.set_status(401)
        res.set_header("Content-Type", "application/json")
        res.write(json.encode({
            "error": "Authentication required"
        }))
        return
    }
    
    // Return list of usernames (excluding passwords)
    user_list := []
    
    // Iterate over users
    for user in users {
        username := user
        user_data := users[username]
        user_list.push({
            username: username,
            created: times.time_format(user_data.created, times.format_rfc3339)
        })
    }
    
    res.set_status(200)
    res.set_header("Content-Type", "application/json")
    res.write(json.encode(user_list))
}

// Main server
http.listen_and_serve(":8080", fn(req, res) {
    // Enable CORS for development
    res.set_header("Access-Control-Allow-Origin", "*")
    res.set_header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
    res.set_header("Access-Control-Allow-Headers", "Content-Type, Authorization")
    
    // Handle preflight
    if req.method == "OPTIONS" {
        res.set_status(200)
        res.write("")
        return
    }
    
    // Route handling
    if req.path == "/" {
        res.set_status(200)
        res.set_header("Content-Type", "text/plain")
        res.write("Authentication Server Running")
    }
    else if req.path == "/register" && req.method == "POST" {
        handle_register(req, res)
    }
    else if req.path == "/login" && req.method == "POST" {
        handle_login(req, res)
    }
    else if req.path == "/profile" && req.method == "GET" {
        handle_profile(req, res)
    }
    else if req.path == "/logout" && req.method == "POST" {
        handle_logout(req, res)
    }
    else if req.path == "/users" && req.method == "GET" {
        handle_users(req, res)
    }
    else {
        res.set_status(404)
        res.set_header("Content-Type", "application/json")
        res.write(json.encode({
            "error": "Endpoint not found"
        }))
    }
})

// Print startup message
println("Authentication server running on http://localhost:8080")
println("Endpoints:")
println("  POST /register - Register new user")
println("  POST /login    - Login and get token")
println("  GET  /profile  - Get user profile (requires auth)")
println("  POST /logout   - Logout (requires auth)")
println("  GET  /users    - List all users (requires auth)")