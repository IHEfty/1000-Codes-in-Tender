import "canvas"
import "os"

// Terminal window size
w := 600
h := 400

// GUI Library
fn new_window(title, width, height) {
    return {
        title: title,
        w: width,
        h: height,
        elements: []
    }
}

fn add_element(window, element) {
    window.elements.push(element)
}

fn draw_window(window, ctx) {
    ctx.hex("#000")
    ctx.clear()
    ctx.rect(0, 0, window.w, window.h)
    for el in window.elements {
        el.draw(ctx)
    }
}

fn new_label(x, y, text, color) {
    this := {
        x: x,
        y: y,
        text: text,
        color: color
    }
    this.draw = fn(ctx) {
        ctx.hex(this.color)
        ctx.text(this.text, this.x, this.y)
    }
    return this
}

fn new_button(x, y, w, h, text, color, on_click) {
    this := {
        x: x,
        y: y,
        w: w,
        h: h,
        text: text,
        color: color,
        on_click: on_click
    }
    this.draw = fn(ctx) {
        ctx.hex(this.color)
        ctx.rect(this.x, this.y, this.w, this.h)
        ctx.hex("#f00")
        ctx.text(this.text, this.x + 10, this.y + this.h / 2)
    }
    return this
}

fn new_text_input(x, y, w, h, color) {
    this := {
        x: x,
        y: y,
        w: w,
        h: h,
        color: color,
        text: ""
    }
    this.draw = fn(ctx) {
        ctx.hex(this.color)
        ctx.rect(this.x, this.y, this.w, this.h)
        ctx.hex("#fff")
        ctx.text(this.text, this.x + 5, this.y + this.h / 2)
    }
    this.input = fn(char) {
        this.text += char
    }
    return this
}

fn new_checkbox(x, y, label, checked) {
    this := {
        x: x,
        y: y,
        label: label,
        checked: checked
    }
    this.draw = fn(ctx) {
        ctx.hex("#fff")
        ctx.rect(this.x, this.y, 15, 15)
        if this.checked {
            ctx.hex("#0f0")
            ctx.text("X", this.x + 3, this.y + 12)
        }
        ctx.hex("#fff")
        ctx.text(this.label, this.x + 20, this.y + 12)
    }
    this.toggle = fn() {
        this.checked = !this.checked
    }
    return this
}

// Main Application
canvas.new_window(w, h, "GUI Library Demo", fn(window) {
    ctx := window.new_context(w, h)
    gui := new_window("GUI Demo", w, h)
    
    label := new_label(20, 20, "Hello, GUI!", "#00ff00")
    add_element(gui, label)
    
    button := new_button(20, 60, 100, 30, "Click Me", "#ff0000", fn(e){
        label.text = "Button Clicked!"
        println(label.text)
    })
    add_element(gui, button)
    
    input_field := new_text_input(20, 100, 200, 30, "#3333ff")
    add_element(gui, input_field)
    
    checkbox := new_checkbox(20, 150, "Enable feature", true)
    add_element(gui, checkbox)
    
    draw_window(gui, ctx)
    window.update(w, h)
    
    for {
        e := window.next_event()
        if e.type == "size" {
            w = e.width_px 
            h = e.height_px
            ctx = window.new_context(e.width_px, e.height_px)
            draw_window(gui, ctx)
            window.update(w, h)
        }
        else if e.type == "mouse" && e.direction == 1 {
            for el in gui.elements {
                if el.on_click && e.x >= el.x && e.x <= el.x + el.w && e.y >= el.y && e.y <= el.y + el.h {
                    el.on_click(e)
                    draw_window(gui, ctx)
                    window.update(w, h)
                }
            }
        }
        else if e.type == "key" {
            input_field.input(e.rune)
            draw_window(gui, ctx)
            window.update(w, h)
        }
        else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
            break
        }
    }
})
