import "gl"
import "glfw"

glfw.init()
gl.init()

// Set window hints for transparency
glfw.window_hint(glfw.TRANSPARENT_FRAMEBUFFER, 1)  // Enable transparent framebuffer
glfw.window_hint(glfw.DECORATED, 0)                // Optional: remove window decorations
glfw.window_hint(glfw.FLOATING, 0)                 // Optional: stay on top (set to 1 if needed)

// Set OpenGL version hints (optional, for compatibility)
glfw.window_hint(glfw.CONTEXT_VERSION_MAJOR, 2)
glfw.window_hint(glfw.CONTEXT_VERSION_MINOR, 1)

window := glfw.create_window(400, 400, "Tender Transparent Triangle (GLFW)")

glfw.make_context_current(window)

wh := glfw.get_window_size(window)
width := wh[0]
height := wh[1]
gl.viewport(0, 0, width, height)

gl.matrix_mode(gl.PROJECTION)
gl.load_identity()
gl.ortho(-1.0, 1.0, -1.0, 1.0, -1.0, 1.0)
gl.matrix_mode(gl.MODELVIEW)
gl.load_identity()

// Enable blending for transparency
gl.enable(gl.BLEND)
gl.blend_func(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)

glfw.set_key_callback(window, fn(key, scancode, action, mods){
    println("Key: " + key + ", scancode: " + scancode + ", action: " + action + ", mods: " + mods)
    if key == glfw.KEY_ESCAPE && action == glfw.PRESS {
        glfw.set_window_should_close(window, 1)
    }
})

glfw.set_window_size_callback(window, fn(w, h){
    gl.viewport(0, 0, w, h)
    println("Window resized to: " + w + "x" + h)
})

glfw.set_mouse_button_callback(window, fn(button, action, mods){
    if action == glfw.PRESS {
        println("Mouse button " + button + " pressed")
    }
})

for !glfw.window_should_close(window) {
    // Set clear color with alpha = 0 for fully transparent background
    gl.clear_color(0.0, 0.0, 0.0, 0.0)
    gl.clear(gl.COLOR_BUFFER_BIT)
    
    gl.load_identity()
    
    // Draw semi-transparent triangle (alpha = 0.8)
    gl.begin(gl.TRIANGLES)
    gl.color4f(1.0, 0.0, 0.0, 0.8)  // Red with 80% opacity
    gl.vertex3f(0.0, 0.75, 0.0)
    gl.color4f(0.0, 1.0, 0.0, 0.8)  // Green with 80% opacity
    gl.vertex3f(-0.75, -0.75, 0.0)
    gl.color4f(0.0, 0.0, 1.0, 0.8)  // Blue with 80% opacity
    gl.vertex3f(0.75, -0.75, 0.0)
    gl.end()
    
    // Draw a semi-transparent overlay rectangle
    gl.begin(gl.QUADS)
    gl.color4f(1.0, 1.0, 1.0, 0.3)  // White with 30% opacity
    gl.vertex3f(-0.4, -0.2, 0.0)
    gl.vertex3f(0.4, -0.2, 0.0)
    gl.vertex3f(0.4, 0.2, 0.0)
    gl.vertex3f(-0.4, 0.2, 0.0)
    gl.end()
    
    // Draw a semi-transparent label
    gl.color4f(0.0, 0.0, 0.0, 0.6)  // Black with 60% opacity
    // Text rendering would go here (simplified with a rectangle)
    gl.begin(gl.QUADS)
    gl.color4f(1.0, 1.0, 0.0, 0.5)  // Yellow with 50% opacity
    gl.vertex3f(-0.3, 0.85, 0.0)
    gl.vertex3f(0.3, 0.85, 0.0)
    gl.vertex3f(0.3, 0.95, 0.0)
    gl.vertex3f(-0.3, 0.95, 0.0)
    gl.end()
    
    gl.flush()
    glfw.swap_buffers(window)
    glfw.poll_events()
}

glfw.destroy_window(window)
glfw.terminate()