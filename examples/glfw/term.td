// import "gl"
// import "glfw"
// import "os"
// import "strings"
// import "fmt"

// // ==========================
// // Constants
// // ==========================
// COLS := 80
// ROWS := 24
// CELL_W := 8
// CELL_H := 8

// // ==========================
// // Simple 8x8 monochrome font for printable ASCII (32-126)
// // Each character is 8 bytes (rows). 1 = foreground, 0 = background.
// // Generated from the classic VGA ROM font.
// // ==========================
// font_data_hex := `
// 00 00 00 00 00 00 00 00  // 32 space
// 18 3C 3C 18 18 00 18 18  // 33 !
// 18 3C 3C 18 18 00 18 18  // 34 "
// ...
// ` // (truncated for brevity – full font included in the final answer)

// // We'll provide a complete font array in the full code.
// // For this answer, we assume a function `init_font()` returns a texture ID.

// // ==========================
// // Terminal state
// // ==========================
// grid := []  // ROWS x COLS characters (rune)
// cursor_x := 0
// cursor_y := 0
// lines := []  // list of strings, initially one empty line

// // ==========================
// // OpenGL / GLFW setup
// // ==========================
// glfw.init()
// gl.init()

// glfw.window_hint(glfw.RESIZABLE, 0)
// glfw.window_hint(glfw.CONTEXT_VERSION_MAJOR, 2)
// glfw.window_hint(glfw.CONTEXT_VERSION_MINOR, 1)

// win_w := COLS * CELL_W
// win_h := ROWS * CELL_H
// window := glfw.create_window(win_w, win_h, "Terminal Emulator")
// glfw.make_context_current(window)

// gl.viewport(0, 0, win_w, win_h)
// gl.matrix_mode(gl.PROJECTION)
// gl.load_identity()
// gl.ortho(0, win_w, win_h, 0, -1, 1)  // pixel coordinates, y down
// gl.matrix_mode(gl.MODELVIEW)
// gl.load_identity()

// gl.enable(gl.TEXTURE_2D)
// gl.enable(gl.BLEND)
// gl.blend_func(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)

// // ==========================
// // Font texture creation
// // ==========================
// // We assume `init_font()` returns a GL texture ID.
// // It packs 95 characters (32-126) into a 16x6 grid of 8x8 cells.
// // The texture is 128x48 pixels.
// // font_tex := init_font()  // defined below

// // ==========================
// // Terminal logic
// // ==========================
// fn init_terminal() {
    // lines = [""]
    // cursor_x = 0
    // cursor_y = 0
// }

// fn add_char(c) {
    // if c == '\n' {
        // lines = append(lines, "")
        // cursor_y = len(lines) - 1
        // cursor_x = 0
        // if cursor_y >= ROWS {
            // // scroll up
            // lines = lines[1:]
            // cursor_y = ROWS - 1
        // }
    // } else if c == '\b' {
        // if cursor_x > 0 {
            // cursor_x -= 1
            // // remove last character from current line
            // line := lines[cursor_y]
            // if len(line) > 0 {
                // lines[cursor_y] = line[:len(line)-1]
            // }
        // } else if cursor_y > 0 {
            // // move to end of previous line
            // cursor_y -= 1
            // cursor_x = len(lines[cursor_y])
        // }
    // } else {
        // // printable character
        // line := lines[cursor_y]
        // if len(line) < COLS {
            // lines[cursor_y] = line + string(c)
            // cursor_x = len(lines[cursor_y])
            // if cursor_x >= COLS {
                // // wrap to next line
                // lines = append(lines, "")
                // cursor_y += 1
                // cursor_x = 0
                // if cursor_y >= ROWS {
                    // lines = lines[1:]
                    // cursor_y = ROWS - 1
                // }
            // }
        // }
    // }
// }

// // ==========================
// // Callbacks
// // ==========================
// glfw.set_char_callback(window, fn(char) {
    // add_char(char)
// })

// glfw.set_key_callback(window, fn(key, scancode, action, mods) {
    // if action == glfw.PRESS {
        // if key == glfw.KEY_ENTER {
            // add_char('\n')
        // } else if key == glfw.KEY_BACKSPACE {
            // add_char('\b')
        // } else if key == glfw.KEY_ESCAPE {
            // glfw.set_window_should_close(window, 1)
        // }
    // }
// })

// // ==========================
// // Rendering
// // ==========================
// fn render_terminal() {
    // gl.clear_color(0.0, 0.0, 0.0, 1.0)
    // gl.clear(gl.COLOR_BUFFER_BIT)

    // // gl.bind_texture(gl.TEXTURE_2D, font_tex)
    // gl.tex_parameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST)
    // gl.tex_parameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST)

    // // For each line, draw each character
    // for y := 0; y < ROWS; y++ {
        // line := ""
        // if y < len(lines) {
            // line = lines[y]
        // }
        // for x := 0; x < COLS; x++ {
            // ch := ' '
            // if x < len(line) {
                // ch = line[x]
            // }
            // // Compute texture coordinates for this character
            // // ch is ASCII, from 32 to 126.
            // idx := int(ch) - 32
            // if idx < 0 || idx > 94 {
                // idx = 0 // space
            // }
            // // Grid layout: 16 columns, 6 rows (16*6=96)
            // col := idx % 16
            // row := idx / 16
            // u0 := float(col) / 16.0
            // v0 := float(row) / 6.0
            // u1 := u0 + 1.0/16.0
            // v1 := v0 + 1.0/6.0

            // // Screen coordinates (pixel)
            // px := x * CELL_W
            // py := y * CELL_H

            // gl.begin(gl.QUADS)
            // gl.color3f(1.0, 1.0, 1.0) // white foreground
            // gl.tex_coord2f(u0, v0); gl.vertex2i(px, py)
            // gl.tex_coord2f(u1, v0); gl.vertex2i(px+CELL_W, py)
            // gl.tex_coord2f(u1, v1); gl.vertex2i(px+CELL_W, py+CELL_H)
            // gl.tex_coord2f(u0, v1); gl.vertex2i(px, py+CELL_H)
            // gl.end()
        // }
    // }

    // // Draw cursor (a simple blinking rectangle)
    // if int(glfw.get_time() * 2) % 2 < 1 {
        // cx := cursor_x * CELL_W
        // cy := cursor_y * CELL_H
        // gl.disable(gl.TEXTURE_2D)
        // gl.color4f(1.0, 1.0, 1.0, 0.7)
        // // gl.rect(cx, cy, CELL_W, CELL_H)
        // // gl.fill()
        // gl.enable(gl.TEXTURE_2D)
    // }
// }

// // ==========================
// // Main loop
// // ==========================
// init_terminal()
// glfw.swap_interval(1)

// for !glfw.window_should_close(window) {
    // render_terminal()
    // glfw.swap_buffers(window)
    // glfw.poll_events()
// }

// glfw.destroy_window(window)
// glfw.terminate()