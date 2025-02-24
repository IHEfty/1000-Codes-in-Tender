import "canvas"
import "os"
import "strings"

var EL_TYPE_LABEL = 0
var EL_TYPE_BUTTON = 1
var EL_TYPE_INPUT = 2
var EL_TYPE_CHECKBOX = 3

fn new_label(x, y, text) {
    this := {
		type: EL_TYPE_LABEL,
        x: x,
        y: y,
        text: text,
        color: "#fff"
    }
    this.draw = fn(ctx) {
        // ctx.hex("#00ff0050")
		// wh := ctx.measure_text(this.text)
		// ctx.rect(this.x, this.y, wh[0], wh[1])
        // ctx.fill()
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
        background: "#ffffff10",
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
        text: ""
    }
    this.draw = fn(ctx) {
        ctx.hex(this.background)
        ctx.rect(this.x, this.y, this.w, this.h)
		ctx.stroke()
        ctx.hex(this.color)
		// wh := ctx.measure_text(this.text)
        ctx.text(this.text, this.x, this.y + this.h / 2)
		ctx.fill()
		ctx.hex("#0f0")
		ctx.text(strings.repeat(" ", this.cursor) + "|", this.x, this.y + this.h / 2)
		ctx.fill()
    }
    this.input = fn(ch, code) {
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

fn new_checkbox(x, y, label, checked) {
    this := {
		type: EL_TYPE_CHECKBOX,
        x: x,
        y: y,
		w: 15,
		h: 15,
        label: label,
        checked: checked
    }
    this.draw = fn(ctx) {
        ctx.hex("#0f0")
		wh := ctx.measure_text("+")
        ctx.circle(this.x + wh[1]/2, this.y + wh[0], this.w/2)
		ctx.stroke()
        if this.checked {
            ctx.hex("#0f0")
            ctx.text("+", this.x + 3, this.y + 12)
			ctx.fill()
        }
        ctx.hex("#fff")
        ctx.text(this.label, this.x + 20, this.y + 12)
		ctx.fill()
    }
    this.toggle = fn() {
        this.checked = !this.checked
    }
    return this
}

fn new_window(title, width, height) {
    this := {
        title: title,
        width: width,
        height: height,
        elements: [],
		start: null,
		add: null,
		draw: null
    }
	this.add = fn(element) {
		this.elements.push(element)
	}
	this.draw = fn(ctx) {
		ctx.clear()
		ctx.hex("#000")
		ctx.rect(0, 0, this.width, this.height)
		ctx.fill()
		for el in this.elements {
			el.draw(ctx)
		}
	}
	this.start = fn() {
		canvas.new_window(this.width, this.height, "GUI Library Demo", fn(window) {
			ctx := window.new_context(this.width, this.height)
			this.draw(ctx)
			window.update(this.width, this.height)
			focused_input := null
			for {
				e := window.next_event()
				if e.type == "size" {
					this.width = e.width_px 
					this.height = e.height_px
					ctx = window.new_context(e.width_px, e.height_px)
					this.draw(ctx)
					window.update(this.width, this.height)
				}
				else if e.type == "mouse" && e.direction == 1 {
					// println("B")
					for el in this.elements {
						if el.type == EL_TYPE_INPUT && e.x >= el.x && e.x <= el.x + el.w && e.y >= el.y && e.y <= el.y + el.h {
							focused_input = el
						}
						if el.on_click && e.x >= el.x && e.x <= el.x + el.w && e.y >= el.y && e.y <= el.y + el.h {
							el.on_click(e)
							this.draw(ctx)
							window.update(this.width, this.height)
						}
						else if el.toggle && e.x >= el.x && e.x <= el.x + el.w && e.y >= el.y && e.y <= el.y + el.h {
							el.toggle()
							this.draw(ctx)
							window.update(this.width, this.height)
						}
					}
				}
				else if e.type == "key" && e.direction == 1 {
					if focused_input != null {
						focused_input.input(e.rune, e.code)
					}
					this.draw(ctx)
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
	label: new_label
}