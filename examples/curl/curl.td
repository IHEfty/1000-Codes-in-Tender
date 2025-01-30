import "os"

export {
    http: fn(addr) {
        return os.exec("curl", addr)
    },

    get: fn(url) {
        return os.exec("curl", "-X", "GET", url)
    },

    post: fn(url, data) {
        return os.exec("curl", "-X", "POST", "-d", data, url)
    },

    put: fn(url, data) {
        return os.exec("curl", "-X", "PUT", "-d", data, url)
    },

    delete: fn(url) {
        return os.exec("curl", "-X", "DELETE", url)
    },

    head: fn(url) {
        return os.exec("curl", "-I", url)
    },

    headers: fn(url, headers) {
        args = ["curl", url]
        for h in headers {
            args = args.concat(["-H", h])
        }
        return os.exec(args...)
    },

    download: fn(url, filename) {
        return os.exec("curl", "-o", filename, url)
    },

    upload: fn(url, file) {
        return os.exec("curl", "-F", "file=@" + file, url)
    },

    auth: fn(url, user, pass) {
        return os.exec("curl", "-u", user + ":" + pass, url)
    },

    verbose: fn(url) {
        return os.exec("curl", "-v", url)
    },

    timeout: fn(url, seconds) {
        return os.exec("curl", "--max-time", seconds, url)
    },

    follow_redirects: fn(url) {
        return os.exec("curl", "-L", url)
    },

    cookies: fn(url, cookie_file) {
        return os.exec("curl", "-b", cookie_file, url)
    },

    save_cookies: fn(url, cookie_file) {
        return os.exec("curl", "-c", cookie_file, url)
    },

    json: fn(url, data) {
        return os.exec("curl", "-X", "POST", "-H", "Content-Type: application/json", "-d", data, url)
    },

    silent: fn(url) {
        return os.exec("curl", "-s", url)
    },

    location: fn(url) {
        return os.exec("curl", "--location", url)
    },

    user_agent: fn(url, agent) {
        return os.exec("curl", "-A", agent, url)
    },

    include_headers: fn(url) {
        return os.exec("curl", "-i", url)
    },

    http_version: fn(url, version) {
        return os.exec("curl", "--http1.1", url)  // Replace with "--http2" for HTTP/2
    },

    request_method: fn(url, method) {
        return os.exec("curl", "-X", method, url)
    },

    upload_progress: fn(url) {
        return os.exec("curl", "--progress-bar", url)
    },

    proxy: fn(url, proxy_url) {
        return os.exec("curl", "--proxy", proxy_url, url)
    },

    compress: fn(url) {
        return os.exec("curl", "--compressed", url)
    }
}
