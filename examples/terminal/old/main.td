import "canvas"
import "os"

// Terminal window size
w := 600
h := 400
fontdata := embed("DMMono-Medium.ttf")

// Terminal state
fn new_terminal(width, height) {
    return {
        w: width,
        h: height,
        lines: [],
        input: "",
        prompt: "> "
    }
}

// Draw the terminal screen
fn draw_terminal(terminal, ctx) {
    ctx.hex("#000000")
    ctx.rect(0, 0, terminal.w, terminal.h)
    
    ctx.hex("#00ff00")
    y := 20
    for line in terminal.lines {
        ctx.text(line, 10, y)
        y += 20
    }
    
    // Draw input line
    ctx.text(terminal.prompt + terminal.input, 10, y)
}

// Execute a command and update the terminal
fn execute_command(terminal) {
    output := os.exec(terminal.input).output()
    terminal.lines.push(terminal.prompt + terminal.input)
    terminal.lines.push(output)
    terminal.input = ""
}

// Handle keyboard input
fn handle_input(terminal, e) {
    if e.code == 40 {
        execute_command(terminal)
    } else if e.code == 42 {
        terminal.input = terminal.input[0:terminal.input.length - 1]
    } else {
        terminal.input += e.rune
    }
}

// Main application
canvas.new_window(w, h, "Terminal Emulator", fn(window) {
    ctx := window.new_context(w, h)
    terminal := new_terminal(w, h)
    draw_terminal(terminal, ctx)
    window.update(w, h)
    
    for {
        e := window.next_event()
        if e.type == "key" && e.direction == 1 {
            handle_input(terminal, e)
            draw_terminal(terminal, ctx)
            window.update(w, h)
        } else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
            break
        }
    }
})
