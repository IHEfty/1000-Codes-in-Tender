import "gl"
import "glfw"
import "graphics"

glfw.init()
gl.init()

window := glfw.create_window(400, 400, "Simple Example")
glfw.make_context_current(window)

gl.viewport(0, 0, 400, 400)
gl.matrix_mode(gl.PROJECTION)
gl.load_identity()
gl.ortho(0, 400, 400, 0, -1, 1)
gl.matrix_mode(gl.MODELVIEW)
gl.load_identity()

gl.enable(gl.BLEND)
gl.blend_func(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)

// Create graphics context
ctx := graphics.new_context(400, 400)

// Function to draw using graphics
fn draw() {
    ctx.clear(0.2, 0.2, 0.3, 1.0)
    ctx.rgb(1.0, 0.5, 0.0)
    ctx.circle(200, 200, 100)
    ctx.fill()
    ctx.rgb(1.0, 1.0, 1.0)
    ctx.set_font_size(20)
    ctx.draw_string_anchored(200, 370, "Click to move", 0.5, 0.5)
}

// Convert graphics context to texture
fn get_texture() {
    img := ctx.image()
    pixels := img.get_pixels()
    tex := gl.gen_textures(1)[0]
    gl.bind_texture(gl.TEXTURE_2D, tex)
    gl.tex_image2d(gl.TEXTURE_2D, 0, gl.RGBA, 400, 400, 0, gl.RGBA, gl.UNSIGNED_BYTE, pixels)
    gl.tex_parameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
    gl.tex_parameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
    return tex
}

glfw.set_key_callback(window, fn(key, scancode, action, mods) {
    if action == glfw.PRESS && key == glfw.KEY_ESCAPE {
        glfw.set_window_should_close(window, 1)
    }
})

for !glfw.window_should_close(window) {
    draw()
    tex := get_texture()
    
    gl.clear_color(0, 0, 0, 1)
    gl.clear(gl.COLOR_BUFFER_BIT)
    
    gl.enable(gl.TEXTURE_2D)
    gl.bind_texture(gl.TEXTURE_2D, tex)
    gl.color4f(1, 1, 1, 1)
    gl.begin(gl.QUADS)
    gl.tex_coord2f(0, 0); gl.vertex2f(0, 0)
    gl.tex_coord2f(1, 0); gl.vertex2f(400, 0)
    gl.tex_coord2f(1, 1); gl.vertex2f(400, 400)
    gl.tex_coord2f(0, 1); gl.vertex2f(0, 400)
    gl.end()
    gl.disable(gl.TEXTURE_2D)
    
    glfw.swap_buffers(window)
    glfw.poll_events()
}

glfw.destroy_window(window)
glfw.terminate()