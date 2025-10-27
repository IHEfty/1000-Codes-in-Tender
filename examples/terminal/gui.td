// gui_lib_with_terminal.lang
import "canvas"
import "os"
import "strings"

var EL_TYPE_LABEL    = 0
var EL_TYPE_BUTTON   = 1
var EL_TYPE_INPUT    = 2
var EL_TYPE_CHECKBOX = 3
var EL_TYPE_TERMINAL = 4

fn new_label(x, y, text) {
    this := {
        type: EL_TYPE_LABEL,
        x: x,
        y: y,
        text: text,
        color: "#fff"
    }
    this.draw = fn(ctx) {
        ctx.hex(this.color)
        ctx.text(this.text, this.x, this.y)
        ctx.fill()
    }
    return this
}

fn new_button(x, y, w, h, text) {
    this := {
        type: EL_TYPE_BUTTON,
        x: x,
        y: y,
        w: w,
        h: h,
        text: text,
        color: "#00ff00",
        background: "#ffffff09",
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

fn new_input(x, y, w, h) {
    this := {
        type: EL_TYPE_INPUT,
        x: x,
        y: y,
        w: w,
        h: h,
        cursor: 0,
        color: "#fff",
        background: "#232323",
        text: "",
        password: false,
        on_enter: null
    }
    this.draw = fn(ctx) {
        ctx.hex(this.background)
        ctx.rect(this.x, this.y, this.w, this.h)
        ctx.stroke()
        ctx.hex(this.color)
        if this.password {
            ctx.text(strings.repeat("*", len(this.text)), this.x, this.y + this.h / 2)
        }
        else {
            ctx.text(this.text, this.x, this.y + this.h / 2)
        }
        ctx.fill()
        ctx.hex("#0f0")
        ctx.text(strings.repeat(" ", this.cursor) + "|", this.x - 2, this.y + this.h / 2)
        ctx.fill()
    }
    this.input = fn(ch, code) {
        if code == 40 {
            if is_callable(this.on_enter) {
                this.on_enter(this)
            }
            return
        }
        if code == 42 {
            if this.cursor > 0 {
                this.text = this.text[0: this.cursor - 1] + (this.text[this.cursor] || "")
                this.cursor--
            }
        }
        else if code == 80 {
            if this.cursor > 0 {
                this.cursor--
            }
        }
        else if code == 79 {
            if this.cursor < this.text.length {
                this.cursor++
            }
        }
        else if ch >= 32 && ch <= 126 {
            this.text += ch
            this.cursor++
        }
    }
    return this
}

fn new_checkbox(x, y, label) {
    this := {
        type: EL_TYPE_CHECKBOX,
        x: x,
        y: y,
        w: 15,
        h: 15,
        label: label,
        checked: true
    }
    this.draw = fn(ctx) {
        ctx.hex("#0f0")
        wh := ctx.measure_text("+")
        ctx.circle(this.x + wh[1], this.y - wh[1]/2 + this.h, this.w/2)
        ctx.stroke()
        if this.checked {
            ctx.hex("#0f0")
            ctx.text("+", this.x + wh[1]/2, this.y + this.h)
            ctx.fill()
        }
        ctx.hex("#fff")
        ctx.text(this.label, this.x + 20, this.y + this.h)
        ctx.fill()
    }
    this.toggle = fn() {
        this.checked = !this.checked
    }
    return this
}


fn new_terminal(x, y, w, h) {
    this := {
        type: EL_TYPE_TERMINAL,
        x: x,
        y: y,
        w: w,
        h: h,
        lines: [],     
        text: "",
        prompt: "> ",
        scroll: 0,
		cursor: 0,
		line_height: 12,
		background: "#121212",
		color: "#0f0",
		scrollbar_track: "#ffffff09",
		scrollbar_thumb: "#0f0"
    }

	
	this.on_enter = fn(input) {
		this.lines.push(this.prompt + this.text)
		this.text = ""
		this.cursor = 0
		this.scroll = 99999
	}
    
    this.wrap_text = fn(text, max_width, ctx) {
        words := strings.split(text, " ")
        if len(words) == 0 {
            return [""]
        }
        wrapped := []
        current_line := words[0]
        for i := 1; i < len(words); i++ {
            word := words[i]
            test_line := current_line + " " + word
            wh := ctx.measure_text(test_line)
            if wh[0] > max_width {
                wrapped.push(current_line)
                current_line = word
            } 
			else {
                current_line = test_line
            }
        }
        wrapped.push(current_line)
        return wrapped
    }
    
    this.draw = fn(ctx) {
        ctx.hex(this.background)
        ctx.rect(this.x, this.y, this.w, this.h)
        ctx.fill()

        wrapped_lines := []
        for raw_line in this.lines {
            wrapped := this.wrap_text(raw_line, this.w - 20, ctx)
            for subline in wrapped {
                wrapped_lines.push(subline)
            }
        }
        
        // Reserve one line at the bottom for the input prompt.
        visible_lines := (this.h - this.line_height) / this.line_height
        
        // Clamp scroll value relative to the wrapped_lines.
        if this.scroll > (len(wrapped_lines) - visible_lines) {
            this.scroll = len(wrapped_lines) - visible_lines
        }
        if this.scroll < 0 {
            this.scroll = 0
        }
        
        // Draw visible wrapped output lines.
        ctx.hex(this.color)
        current_y := this.y + this.line_height
        for i := this.scroll; i < this.scroll + visible_lines && i < len(wrapped_lines); i++ {
            ctx.text(wrapped_lines[i], this.x + 10, current_y)
            current_y += this.line_height
        }
        
        // Draw input line at the bottom.
        ctx.text(this.prompt + this.text, this.x + 10, current_y)
        ctx.fill()

        ctx.text(strings.repeat(" ", this.cursor + len(this.prompt)) + "_", this.x + 10, current_y)
        ctx.fill()
        
        if len(wrapped_lines) > visible_lines {
            scrollbar_width := 10
            track_x := this.x + this.w - scrollbar_width  // right-aligned
            track_y := this.y
            track_h := this.h
            // Draw scrollbar track.
            ctx.hex(this.scrollbar_track)
            ctx.rect(track_x, track_y, scrollbar_width, track_h)
            ctx.fill()
            // Compute thumb height (minimum size 10).
            thumb_h := (visible_lines / float(len(wrapped_lines))) * track_h
            if thumb_h < 10 { thumb_h = 10 }
            // Compute thumb position based on scroll offset.
            max_scroll := len(wrapped_lines) - visible_lines
            scroll_ratio := 0.0
            if max_scroll > 0 { scroll_ratio = this.scroll / max_scroll }
            thumb_y := track_y + scroll_ratio * (track_h - thumb_h)
            // Draw scrollbar thumb.
            ctx.hex(this.scrollbar_thumb)
            ctx.rect(track_x, thumb_y, scrollbar_width, thumb_h)
            ctx.fill()
        }
    }
    
    // Process keyboard input when the terminal is focused.
    this.input = fn(ch, code) {
        if code == 81 {
            this.handle_scroll(1)
        } 
        else if code == 82 { 
            this.handle_scroll(-1)
        }
        else if code == 40 { // Enter key
            if is_callable(this.on_enter) {
				this.on_enter(this)
			}
        }
        else if code == 42 { // Backspace key
			if this.cursor > 0 {
				this.text = this.text[0: this.cursor - 1] + (this.text[this.cursor] || "")
				this.cursor--
			}
        }
		else if code == 80 {
			if this.cursor > 0 {
				this.cursor--
			}
		}
		else if code == 79 {
			if this.cursor < this.text.length {
				this.cursor++
			}
		}
        else if ch >= 32 && ch <= 126 { // Regular character input
            this.text += ch
			this.cursor++
        }
    }
    
    // delta > 0 scrolls down; delta < 0 scrolls up.
    this.handle_scroll = fn(delta) {
        visible_lines := (this.h - this.line_height) / this.line_height
        this.scroll += delta
    }
    
    return this
}



fn new_window(title, width, height) {
    this := {
        title: title,
        width: width,
        height: height,
        elements: [],
        fontdata: null,
        fontsize: null,
        set_font: fn(data, size) {
            this.fontdata = data
            this.fontsize = size
        },
        ctx: null,
        start: null,
        add: null,
        draw: null
    }
	this.update = fn() {
		this.draw(this.ctx)
        this.window.update(this.width, this.height)
	}
    this.add = fn(element) {
        this.elements.push(element)
    }
    this.draw = fn(ctx) {
        ctx.clear()
        ctx.hex("#000")
        ctx.rect(0, 0, this.width, this.height)
        ctx.fill()
        if this.fontdata && this.fontsize {
            ctx.fontface(this.fontdata, this.fontsize)
        }
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
            this.focused_input = null
            for {
                e := window.next_event()
                if e.type == "size" {
                    this.width = e.width_px 
                    this.height = e.height_px
                    this.ctx = window.new_context(e.width_px, e.height_px)
                    this.draw(this.ctx)
                    window.update(this.width, this.height)
                }
                else if e.type == "mouse" && e.direction == 1 {
                    // Set focus for elements that accept keyboard input.
                    for el in this.elements {
                        if el.input && e.x >= el.x && e.x <= el.x + (el.w || 0) && e.y >= el.y && e.y <= el.y + (el.h || 0) {
                            this.focused_input = el
                        }
                        if el.toggle && e.x >= el.x && e.x <= el.x + (el.w || 0) && e.y >= el.y && e.y <= el.y + (el.h || 0) {
                            el.toggle()
                            this.draw(this.ctx)
                            window.update(this.width, this.height)
                        }
                        if el.on_click && e.x >= el.x && e.x <= el.x + (el.w || 0) && e.y >= el.y && e.y <= el.y + (el.h || 0) {
                            el.on_click(e)
                            this.draw(this.ctx)
                            window.update(this.width, this.height)
                        }
                    }
                }
                else if e.type == "key" && (e.direction == 1 || e.direction == 0) {
                    if this.focused_input != null {
                        this.focused_input.input(e.rune, e.code)
                    }
                    this.draw(this.ctx)
                    window.update(this.width, this.height)
                }
                else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
                    break
                }
            }
        })    
    }
    return this
}

export {
    window: new_window,
    button: new_button,
    checkbox: new_checkbox,
    input: new_input,
    label: new_label,
    terminal: new_terminal
}
