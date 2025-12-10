import "os"

export fn(url) {
    var cmd
    if os.platform == "linux" {
        cmd = os.exec("xdg-open", url)
	}
    else if os.platform == "darwin" {
        cmd = os.exec("open", url)
	}
    if os.platform == "windows" {
        cmd = os.exec("rundll32", "url.dll,FileProtocolHandler", url)
    }
	else {
        return
    }
    cmd.start()
}
