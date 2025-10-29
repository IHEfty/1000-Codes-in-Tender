import "canvas"
import "http"
import "json"

// ─────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────
var COLOR_BG = "#121212"
var COLOR_SURFACE = "#1E1E1E"
var COLOR_TEXT = "#FFFFFF"
var COLOR_PRIMARY = "#03DAC6"
var COLOR_PLACEHOLDER = "#888888"
var COLOR_SECONDARY = "#BB86FC"

// ─────────────────────────────────────────────
// LABEL
// ─────────────────────────────────────────────
fn new_label(x, y, text, color) {
	this := { x: x, y: y, text: text, color: color || COLOR_TEXT }
	this.draw = fn(ctx) {
		ctx.hex(this.color)
		ctx.text(this.text, this.x, this.y)
		ctx.fill()
	}
	return this
}

// ─────────────────────────────────────────────
// WINDOW
// ─────────────────────────────────────────────
fn new_window(title, w, h) {
	this := { title: title, w: w, h: h, ctx: null, window: null, elements: [] }
	this.add = fn(el) { this.elements.push(el) }
	this.draw = fn(ctx) {
		ctx.clear()
		ctx.hex(COLOR_BG)
		ctx.rect(0, 0, this.w, this.h)
		ctx.fill()
		ctx.hex(COLOR_SECONDARY)
		ctx.text(this.title, 20, 25)
		ctx.fill()
		for el in this.elements { el.draw(ctx) }
	}
	this.start = fn(on_ready) {
		canvas.new_window(this.w, this.h, this.title, fn(window) {
			this.window = window
			this.ctx = window.new_context(this.w, this.h)
			if is_callable(on_ready) { on_ready() }
			for {
				e := window.next_event()
				this.draw(this.ctx)
				window.update(this.w, this.h)
				if e.type == "lifecycle" && e.from == 3 && e.to == 0 { break }
			}
		})
	}
	return this
}

// ─────────────────────────────────────────────
// APP LOGIC — AUTO WEATHER
// ─────────────────────────────────────────────
fn main() {
	win := new_window("Local Weather", 500, 300)

	status := new_label(20, 80, "Loading weather...", COLOR_PLACEHOLDER)
	info := new_label(20, 120, "", COLOR_TEXT)

	win.add(status)
	win.add(info)

	fetch_weather := fn() {
		// // Get user IP location
		// loc_resp := http.get("https://ipapi.co/json/").body()
		// if is_error(loc_resp) {
			// status.text = "Failed to get location."
			// return
		// }
		// println(string(loc_resp)
		// loc := json.decode(loc_resp)
		// if is_error(loc) {
			// status.text = "Invalid location data."
			// return
		// }

		// city := loc["city"]
		// country := loc["country_name"]
		city := "London"
		country := "UK"
		if len(city) == 0 {
			status.text = "Location not found."
			return
		}

		status.text = "Fetching weather for " + city + ", " + country + "..."

		// Get weather info
		url := "https://wttr.in/" + city + "?format=j1"
		resp := http.get(url).body()
		if is_error(resp) {
			status.text = "Network error!"
			return
		}

		data := json.decode(resp)
		if is_error(data) {
			status.text = "Invalid weather data."
			return
		}

		current := data["current_condition"][0]
		temp := current["temp_C"]
		weather := current["weatherDesc"][0]["value"]
		humidity := current["humidity"]

		status.text = "Current weather in " + city + ":"
		info.text = temp + "°C, " + weather + " (Humidity " + humidity + "%)"
	}

	win.start(fn() { fetch_weather() })
}

main()
