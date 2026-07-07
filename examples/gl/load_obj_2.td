import "gl"
import "glut"
import "glu"

glut.init()
gl.init()
glut.init_display_mode(glut.RGBA | glut.DOUBLE | glut.DEPTH)
glut.init_window_size(400, 400)
glut.create_window("High Performance Textured Engine")

gl.enable(gl.DEPTH_TEST)
gl.enable(gl.LIGHTING)
gl.enable(gl.LIGHT0)
gl.enable(gl.TEXTURE_2D) // IMPORTANT: Globally enable 2D textures!

// Set up lighting properties
gl.lightfv(gl.LIGHT0, gl.POSITION, 3.0, 4.0, 5.0, 1.0)
gl.lightfv(gl.LIGHT0, gl.DIFFUSE, 1.0, 1.0, 1.0, 1.0)

// 1. Load an external texture straight to VRAM
tex_id := gl.load_texture("skin.png")

// 2. Demonstration: Parse an OBJ out of a raw embedded string (instead of a file)
raw_obj_string := embed("cube.obj")
mesh_id := gl.parse_obj(raw_obj_string)

var rot = 0.0

glut.display_func(fn() {
    gl.clear_color(0.05, 0.05, 0.08, 1.0)
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    
    gl.matrix_mode(gl.MODELVIEW)
    gl.load_identity()
    gl.translatef(0.0, 0.0, -5.0)
    gl.rotatef(rot, 0.0, 1.0, 0.0)
    
    // Bind texture to pipeline before processing the mesh display list
    gl.bind_texture(gl.TEXTURE_2D, tex_id)
    
    // Draw the hardware-cached geometry loop
    gl.draw_obj(mesh_id)
    
    glut.swap_buffers()
})

glut.reshape_func(fn(w, h) {
    gl.viewport(0, 0, w, h)
    gl.matrix_mode(gl.PROJECTION)
    gl.load_identity()
    glu.perspective(45.0, w/h, 0.1, 100.0)
})

glut.idle_func(fn() {
    rot += 0.5
    glut.post_redisplay()
})

glut.main_loop()