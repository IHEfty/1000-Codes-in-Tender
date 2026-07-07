import "gl"
import "glut"
import "os"
import "math"

glut.init()
gl.init()
glut.init_display_mode(glut.RGBA | glut.DOUBLE)
glut.init_window_size(800, 600)
glut.create_window("2D Drawing & Text Demo")

// Setup orthographic projection
glut.reshape_func(fn(w, h) {
    gl.viewport(0, 0, w, h)
    gl.matrix_mode(gl.PROJECTION)
    gl.load_identity()
    gl.ortho(0.0, w, h, 0.0, -1.0, 1.0)
    gl.matrix_mode(gl.MODELVIEW)
})

// Store window dimensions
var win_w = 800
var win_h = 600

glut.display_func(fn() {
    gl.clear_color(0.1, 0.1, 0.2, 1.0)
    gl.clear(gl.COLOR_BUFFER_BIT)
    
    gl.matrix_mode(gl.MODELVIEW)
    gl.load_identity()
    
    // Draw a colorful rectangle
    gl.color4f(1.0, 0.3, 0.3, 0.8)
    // gl.rectf(50, 50, 200, 150)
    
    // Draw outlined shapes
    gl.color3f(0.3, 0.8, 0.3)
    gl.begin(gl.LINE_LOOP)
    gl.vertex2f(300, 50)
    gl.vertex2f(400, 150)
    gl.vertex2f(350, 200)
    gl.vertex2f(250, 150)
    gl.end()
    
    // Draw filled circle approximation
    gl.color3f(0.3, 0.3, 0.8)
    gl.begin(gl.TRIANGLE_FAN)
    gl.vertex2f(600, 100)
    for i := 0; i <= 360; i += 10 {
        var angle = i * 3.14159 / 180.0
        var x = 600 + 80 * math.cos(angle)
        var y = 100 + 80 * math.sin(angle)
        gl.vertex2f(x, y)
    }
    gl.end()
    
    // Draw some lines
    gl.color3f(1.0, 1.0, 1.0)
    gl.line_width(2.0)
    gl.begin(gl.LINES)
    gl.vertex2f(50, 200)
    gl.vertex2f(250, 300)
    gl.vertex2f(250, 300)
    gl.vertex2f(50, 400)
    gl.end()
    
    // Draw points
    gl.point_size(5.0)
    gl.color3f(1.0, 1.0, 0.0)
    gl.begin(gl.POINTS)
    for i := 0; i < 20; i++ {
        gl.vertex2f(350 + i*15, 350 + i*5)
    }
    gl.end()
    
    // Draw text
    gl.color3f(1.0, 1.0, 1.0)
    gl.raster_pos2f(50, 500)
    glut.bitmap_character(glut.BITMAP_HELVETICA_18, 'H')
    
    gl.raster_pos2f(50, 530)
    glut.bitmap_character(glut.BITMAP_HELVETICA_18, 'J')
    
    // gl.raster_pos2f(50, 560)
    // glut.bitmap_character(glut.BITMAP_HELVETICA_18, "FPS: " + string(glut.get(glut.ELAPSED_TIME)))
    
    glut.swap_buffers()
})

glut.keyboard_func(fn(key, x, y) {
    if key == "\x1b" || key == "q" || key == "Q" {
        os.exit(0)
    }
})

glut.main_loop()