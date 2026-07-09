import "gl"
import "glfw"
import { sin } from "math"   // Only sin needed for bounce

// ============================================================
// SCREENPET - Transparent Desktop Rectangle
// ============================================================

// Initialize GLFW and OpenGL
glfw.init()
gl.init()

// Set up transparent window
glfw.window_hint(glfw.TRANSPARENT_FRAMEBUFFER, 1)  // Enable transparency
glfw.window_hint(glfw.DECORATED, 0)                // No window decorations
glfw.window_hint(glfw.FLOATING, 1)                 // Stay on top
glfw.window_hint(glfw.RESIZABLE, 0)                // Fixed size
glfw.window_hint(glfw.VISIBLE, 1)                  // Visible initially

// Create window (150x150)
PET_SIZE := 150
window := glfw.create_window(PET_SIZE, PET_SIZE, "Screenpet")
glfw.make_context_current(window)

// Enable blending for transparency
gl.enable(gl.BLEND)
gl.blend_func(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)

// Disable vsync for smooth dragging
glfw.swap_interval(0)

// Setup viewport
fb := glfw.get_framebuffer_size(window)
fw := fb[0]
fh := fb[1]
gl.viewport(0, 0, fw, fh)

// Set orthographic projection (pixel coordinates)
gl.matrix_mode(gl.PROJECTION)
gl.load_identity()
gl.ortho(0, fw, fh, 0, -1, 1)

gl.matrix_mode(gl.MODELVIEW)
gl.load_identity()

// Clear with full transparency
gl.clear_color(0.0, 0.0, 0.0, 0.0)

// ============================================================
// PET STATE
// ============================================================
pet_state := {
    x: 100,
    y: 100,
    dragging: false,
    drag_offset_x: 0,
    drag_offset_y: 0,
    bounce_phase: 0
}

win_w := PET_SIZE
win_h := PET_SIZE

// Rectangle color (semi-transparent orange)
rect_color := [1.0, 0.6, 0.0, 0.8]

// ============================================================
// DRAWING FUNCTION – RECTANGLE
// ============================================================
draw_rect := fn(scale, time_) {
    // Rectangle dimensions (scaled)
    w := 80.0 * scale
    h := 60.0 * scale
    cx := win_w / 2.0
    cy := win_h / 2.0

    // Draw filled rectangle as a quad
    gl.begin(gl.QUADS)
    gl.color4f(rect_color[0], rect_color[1], rect_color[2], rect_color[3])
    gl.vertex2f(cx - w/2, cy - h/2)
    gl.vertex2f(cx + w/2, cy - h/2)
    gl.vertex2f(cx + w/2, cy + h/2)
    gl.vertex2f(cx - w/2, cy + h/2)
    gl.end()

    // Optional border
    gl.color4f(0.2, 0.2, 0.2, 0.5)
    gl.line_width(2.0)
    gl.begin(gl.LINE_LOOP)
    gl.vertex2f(cx - w/2, cy - h/2)
    gl.vertex2f(cx + w/2, cy - h/2)
    gl.vertex2f(cx + w/2, cy + h/2)
    gl.vertex2f(cx - w/2, cy + h/2)
    gl.end()
}

// ============================================================
// CALLBACKS
// ============================================================

// Mouse button – start/stop dragging
glfw.set_mouse_button_callback(window, fn(button, action, mods) {
    if button == glfw.MOUSE_BUTTON_LEFT {
        if action == glfw.PRESS {
            mxy := glfw.get_cursor_pos(window)
            pet_state.dragging = true
            pet_state.drag_offset_x = mxy[0]
            pet_state.drag_offset_y = mxy[1]
        } else if action == glfw.RELEASE {
            pet_state.dragging = false
        }
    }
})

// Mouse move – drag the window
glfw.set_cursor_pos_callback(window, fn(x, y) {
    if pet_state.dragging {
        wxy := glfw.get_window_pos(window)
        win_x := wxy[0]
        win_y := wxy[1]
        new_x := win_x + (x - pet_state.drag_offset_x)
        new_y := win_y + (y - pet_state.drag_offset_y)
        glfw.set_window_pos(window, int(new_x), int(new_y))
        pet_state.x = new_x
        pet_state.y = new_y
    }
})

// Stop dragging if mouse leaves window
glfw.set_cursor_enter_callback(window, fn(entered) {
    if !entered && pet_state.dragging {
        pet_state.dragging = false
    }
})

// Keyboard shortcuts
glfw.set_key_callback(window, fn(key, scancode, action, mods) {
    if action == glfw.PRESS {
        if key == glfw.KEY_ESCAPE {
            glfw.set_window_should_close(window, 1)
        } else if key == glfw.KEY_H {
            if glfw.get_window_attrib(window, glfw.VISIBLE) == 1 {
                glfw.hide_window(window)
            } else {
                glfw.show_window(window)
            }
        }
        // Keys 1,2,3 do nothing (kept for compatibility)
    }
})

// ============================================================
// MAIN LOOP
// ============================================================
println("=== SCREENPET CONTROLS ===")
println("Click and drag to move")
println("Press H: Hide/Show")
println("Press ESC: Exit")
println("===========================")

// Place pet in center of screen
monitor := glfw.get_primary_monitor()
mode := glfw.get_video_mode(monitor)
screen_w := mode.width
screen_h := mode.height
glfw.set_window_pos(window, (screen_w - PET_SIZE)/2, (screen_h - PET_SIZE)/2)

time_ := 0.0

for !glfw.window_should_close(window) {
    time_ += 0.016  // ~60 FPS

    // Clear with full transparency
    gl.clear_color(0.0, 0.0, 0.0, 0.0)
    gl.clear(gl.COLOR_BUFFER_BIT)

    gl.load_identity()

    // Idle bounce
    if !pet_state.dragging {
        bounce := sin(time_ * 2.0) * 2.0
        gl.translatef(0, bounce, 0)
    }

    draw_rect(1.0, time_)

    glfw.swap_buffers(window)
    glfw.poll_events()
}

// Cleanup
glfw.destroy_window(window)
glfw.terminate()