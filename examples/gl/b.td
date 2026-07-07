import "gl"
import "glut"
import "graphics"
import { sin } from "math"

glut.init()
glut.init_display_mode(glut.RGB | glut.DOUBLE)  // Use DOUBLE buffer for smooth animation
glut.init_window_size(400, 400)
glut.create_window("Tender Graphics Demo")
gl.init()

ctx := graphics.new_context(400, 400)
angle := 0.0

glut.display_func(fn(){
    gl.clear_color(0.2, 0.2, 0.3, 1.0)
    gl.clear(gl.COLOR_BUFFER_BIT)
    gl.load_identity()
    
    // Setup 2D projection
    gl.matrix_mode(gl.PROJECTION)
    gl.load_identity()
    gl.ortho(0, 600, 600, 0, -1, 1)
    gl.matrix_mode(gl.MODELVIEW)
    gl.load_identity()
    
    // Draw a rotating square
    ctx.push()
    ctx.translate(300, 300)
    ctx.rotate(angle)
    ctx.translate(-50, -50)
    ctx.hex("#ff8800")
    ctx.rect(0, 0, 100, 100)
    ctx.fill()
    ctx.hex("#ffffff")
    ctx.set_line_width(2)
    ctx.stroke()
    ctx.pop()
    
    // Draw a pulsating circle
    scale_val := 1.0 + 0.3 * sin(angle * 2)
    ctx.push()
    ctx.translate(100, 100)
    ctx.scale(scale_val, scale_val)
    ctx.hex("#44aaff10")
    ctx.circle(0, 0, 40)
    ctx.fill()
    ctx.pop()
    
    // Draw some text (if font support is available)
    // ctx.hex("#ffffff")
    // ctx.draw_string(10, 10, "Hello, Tender!")
    
    glut.swap_buffers()  // For DOUBLE buffer
})

glut.reshape_func(fn(w, h) {
    gl.viewport(0, 0, w, h)
    gl.matrix_mode(gl.PROJECTION)
    gl.load_identity()
    gl.ortho(0, w, h, 0, -1, 1)
    gl.matrix_mode(gl.MODELVIEW)
})

glut.idle_func(fn(){
    angle += 0.02
    glut.post_redisplay()
})

glut.main_loop()