// daily_notes.lang
import "canvas"
import "os"
import "strings"

// ─────────────────────────────────────────────
// MATERIAL COLOR PALETTE
// ─────────────────────────────────────────────
var COLOR_BG         = "#121212"      // dark background
var COLOR_SURFACE    = "#1E1E1E"      // card background
var COLOR_PRIMARY    = "#03DAC6"      // teal accent
var COLOR_SECONDARY  = "#BB86FC"      // indigo accent
var COLOR_TEXT       = "#FFFFFF"      // main text
var COLOR_PLACEHOLDER= "#888888"      // secondary text
var COLOR_DIVIDER    = "#2A2A2A"      // divider lines
var COLOR_ACCENT     = "#FFB300"      // amber accent


// ─────────────────────────────────────────────
// ELEMENT TYPES
// ─────────────────────────────────────────────
var EL_TYPE_LABEL    = 0
var EL_TYPE_BUTTON   = 1
var EL_TYPE_INPUT    = 2
var EL_TYPE_TERMINAL = 3


// ─────────────────────────────────────────────
// LABEL
// ─────────────────────────────────────────────
fn new_label(x, y, text, color) {
	this := {
		type: EL_TYPE_LABEL,
		x: x,
		y: y,
		text: text,
		color: color || COLOR_TEXT
	}
	this.draw = fn(ctx) {
		ctx.hex(this.color)
		ctx.text(this.text, this.x, this.y)
		ctx.fill()
	}
	return this
}


// ─────────────────────────────────────────────
// BUTTON
// ─────────────────────────────────────────────
fn new_button(x, y, w, h, text) {
	this := {
		type: EL_TYPE_BUTTON,
		x: x, y: y, w: w, h: h,
		text: text,
		background: COLOR_PRIMARY,
		color: COLOR_BG,
		on_click: null
	}
	this.draw = fn(ctx) {
		ctx.hex(this.background)
		ctx.rect(this.x, this.y, this.w, this.h)
		ctx.fill()
		ctx.hex(this.color)
		wh := ctx.measure_text(this.text)
		ctx.text(this.text, this.x + this.w/2 - wh[0]/2, this.y + this.h/2 + wh[1]/2)
		ctx.fill()
	}
	return this
}


// ─────────────────────────────────────────────
// INPUT
// ─────────────────────────────────────────────
fn new_input(x, y, w, h, placeholder) {
	this := {
		type: EL_TYPE_INPUT,
		x: x, y: y, w: w, h: h,
		text: "",
		cursor: 0,
		color: COLOR_TEXT,
		background: COLOR_SURFACE,
		placeholder: placeholder,
		on_enter: null
	}
	this.draw = fn(ctx) {
		ctx.hex(this.background)
		// ctx.roundrect(this.x, this.y, this.w, this.h, 5)
		ctx.rect(this.x, this.y, this.w, this.h)
		ctx.fill()
		ctx.hex(this.color)
		if len(this.text) == 0 {
			ctx.hex(COLOR_PLACEHOLDER)
			ctx.text(this.placeholder, this.x + 10, this.y + this.h/1.6)
		} else {
			ctx.text(this.text, this.x + 10, this.y + this.h/1.6)
		}
		ctx.fill()
		ctx.hex(COLOR_PRIMARY)
		ctx.text(strings.repeat(" ", this.cursor) + "|", this.x + 10, this.y + this.h/1.6)
		ctx.fill()
	}
	this.input = fn(ch, code) {
		if code == 40 { // enter
			if is_callable(this.on_enter) { this.on_enter(this) }
			return
		}
		if code == 42 { // backspace
			if this.cursor > 0 {
				this.text = this.text[0:this.cursor-1]
				this.cursor--
			}
		} else if ch >= 32 && ch <= 126 {
			this.text += ch
			this.cursor++
		}
	}
	return this
}


// ─────────────────────────────────────────────
// TERMINAL (for displaying notes)
// ─────────────────────────────────────────────
fn new_terminal(x, y, w, h) {
	this := {
		type: EL_TYPE_TERMINAL,
		x: x, y: y, w: w, h: h,
		lines: [],
		color: COLOR_TEXT,
		background: COLOR_SURFACE,
		scroll: 0,
		line_height: 14,
		scrollbar_track: COLOR_DIVIDER,
		scrollbar_thumb: COLOR_PRIMARY
	}
	this.add_line = fn(text) {
		this.lines.push(text)
		this.scroll = 9999
	}
	this.draw = fn(ctx) {
		ctx.hex(this.background)
		// ctx.roundrect(this.x, this.y, this.w, this.h, 8)
		ctx.rect(this.x, this.y, this.w, this.h)
		ctx.fill()

		visible := (this.h / this.line_height)
		start := len(this.lines) - visible
		if start < 0 { start = 0 }

		ctx.hex(this.color)
		cur_y := this.y + this.line_height + 5
		for i := start; i < len(this.lines); i++ {
			ctx.text(this.lines[i], this.x + 10, cur_y)
			cur_y += this.line_height
		}

		if len(this.lines) > visible {
			scrollbar_width := 8
			track_x := this.x + this.w - scrollbar_width
			track_y := this.y
			track_h := this.h
			ctx.hex(this.scrollbar_track)
			ctx.rect(track_x, track_y, scrollbar_width, track_h)
			ctx.fill()
			thumb_h := (visible / float(len(this.lines))) * track_h
			if thumb_h < 10 { thumb_h = 10 }
			scroll_ratio := (start / float(len(this.lines)))
			thumb_y := track_y + scroll_ratio * (track_h - thumb_h)
			ctx.hex(this.scrollbar_thumb)
			ctx.rect(track_x, thumb_y, scrollbar_width, thumb_h)
			ctx.fill()
		}
	}
	return this
}


// ─────────────────────────────────────────────
// WINDOW
// ─────────────────────────────────────────────
fn new_window(title, width, height) {
	this := {
		title: title,
		width: width,
		height: height,
		elements: [],
		ctx: null,
		window: null
	}
	this.add = fn(el) {
		this.elements.push(el)
	}
	this.draw = fn(ctx) {
		ctx.clear()
		ctx.hex(COLOR_BG)
		ctx.rect(0, 0, this.width, this.height)
		ctx.fill()

		ctx.hex(COLOR_PRIMARY)
		ctx.text(this.title, 20, 25)
		ctx.fill()

		for el in this.elements {
			el.draw(ctx)
		}
	}
	this.start = fn() {
		canvas.new_window(this.width, this.height, this.title, fn(window) {
			this.window = window
			this.ctx = window.new_context(this.width, this.height)
			this.draw(this.ctx)
			window.update(this.width, this.height)
			this.focused = null

			for {
				e := window.next_event()
				if e.type == "mouse" && e.direction == 1 {
					for el in this.elements {
						if el.type == EL_TYPE_INPUT &&
						   e.x >= el.x && e.x <= el.x + el.w &&
						   e.y >= el.y && e.y <= el.y + el.h {
							this.focused = el
						}
						if el.type == EL_TYPE_BUTTON &&
						   e.x >= el.x && e.x <= el.x + el.w &&
						   e.y >= el.y && e.y <= el.y + el.h &&
						   is_callable(el.on_click) {
							el.on_click(e)
						}
					}
				}
				else if e.type == "key"; e.direction == 1 {
					if this.focused != null {
						this.focused.input(e.rune, e.code)
					}
				}
				this.draw(this.ctx)
				window.update(this.width, this.height)
				if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
					break
				}
			}
		})
	}
	return this
}


// ─────────────────────────────────────────────
// APP LOGIC — DAILY NOTES
// ─────────────────────────────────────────────
fn main() {
	win := new_window("Daily Notes", 500, 400)

	header := new_label(20, 60, "Today's Notes", COLOR_SECONDARY)
	date_label := new_label(20, 80, "Wooh", COLOR_PLACEHOLDER)

	notes_area := new_terminal(20, 110, 460, 220)
	input_box := new_input(20, 340, 340, 30, "Write a note...")
	add_btn := new_button(370, 340, 110, 30, "Add Note")

	add_note := fn() {
		if len(input_box.text) > 0 {
			notes_area.add_line("[" + "TEST" + "] " + input_box.text)
			input_box.text = ""
			input_box.cursor = 0
		}
	}

	add_btn.on_click = fn(e) { add_note() }
	input_box.on_enter = fn(self) { add_note() }

	win.add(header)
	win.add(date_label)
	win.add(notes_area)
	win.add(input_box)
	win.add(add_btn)

	win.start()
}

main()
