import "gl"
import "glut"
import "glu"
import "os"
import "math"

// Initialize
glut.init()
glut.init_display_mode(glut.RGBA | glut.DOUBLE | glut.DEPTH)
glut.init_window_size(800, 600)
glut.create_window("3D Cube with Texture")
gl.init()

gl.enable(gl.DEPTH_TEST)
gl.enable(gl.LIGHTING)
gl.enable(gl.LIGHT0)
gl.enable(gl.TEXTURE_2D)

// Lighting
gl.lightfv(gl.LIGHT0, gl.POSITION, 5.0, 5.0, 5.0, 1.0)
gl.lightfv(gl.LIGHT0, gl.DIFFUSE, 1.0, 1.0, 1.0, 1.0)
gl.lightfv(gl.LIGHT0, gl.AMBIENT, 0.3, 0.3, 0.3, 1.0)

// Cube vertices with normals and texture coordinates
var cube_vertices = bytes([
    // Front face
    -0.5, -0.5,  0.5,  0.0, 0.0, 1.0,  0.0, 0.0,
     0.5, -0.5,  0.5,  0.0, 0.0, 1.0,  1.0, 0.0,
     0.5,  0.5,  0.5,  0.0, 0.0, 1.0,  1.0, 1.0,
    -0.5,  0.5,  0.5,  0.0, 0.0, 1.0,  0.0, 1.0,
    // Back face
    -0.5, -0.5, -0.5,  0.0, 0.0,-1.0,  0.0, 0.0,
     0.5, -0.5, -0.5,  0.0, 0.0,-1.0,  1.0, 0.0,
     0.5,  0.5, -0.5,  0.0, 0.0,-1.0,  1.0, 1.0,
    -0.5,  0.5, -0.5,  0.0, 0.0,-1.0,  0.0, 1.0,
    // Top face
    -0.5,  0.5, -0.5,  0.0, 1.0, 0.0,  0.0, 0.0,
     0.5,  0.5, -0.5,  0.0, 1.0, 0.0,  1.0, 0.0,
     0.5,  0.5,  0.5,  0.0, 1.0, 0.0,  1.0, 1.0,
    -0.5,  0.5,  0.5,  0.0, 1.0, 0.0,  0.0, 1.0,
    // Bottom face
    -0.5, -0.5, -0.5,  0.0,-1.0, 0.0,  0.0, 0.0,
     0.5, -0.5, -0.5,  0.0,-1.0, 0.0,  1.0, 0.0,
     0.5, -0.5,  0.5,  0.0,-1.0, 0.0,  1.0, 1.0,
    -0.5, -0.5,  0.5,  0.0,-1.0, 0.0,  0.0, 1.0,
    // Right face
     0.5, -0.5, -0.5,  1.0, 0.0, 0.0,  0.0, 0.0,
     0.5, -0.5,  0.5,  1.0, 0.0, 0.0,  1.0, 0.0,
     0.5,  0.5,  0.5,  1.0, 0.0, 0.0,  1.0, 1.0,
     0.5,  0.5, -0.5,  1.0, 0.0, 0.0,  0.0, 1.0,
    // Left face
    -0.5, -0.5, -0.5, -1.0, 0.0, 0.0,  0.0, 0.0,
    -0.5, -0.5,  0.5, -1.0, 0.0, 0.0,  1.0, 0.0,
    -0.5,  0.5,  0.5, -1.0, 0.0, 0.0,  1.0, 1.0,
    -0.5,  0.5, -0.5, -1.0, 0.0, 0.0,  0.0, 1.0
])

// Index array for triangles (6 faces * 2 triangles * 3 vertices)
var cube_indices = [
    0, 1, 2,  0, 2, 3,  // Front
    4, 5, 6,  4, 6, 7,  // Back
    8, 9,10,  8,10,11,  // Top
    12,13,14, 12,14,15, // Bottom
    16,17,18, 16,18,19, // Right
    20,21,22, 20,22,23 // Left
]

// Load texture
var tex_id = gl.load_texture("crate.jpg")

// Rotation variables
var rot_x = 0.0
var rot_y = 0.0

glut.display_func(fn() {
    gl.clear_color(0.2, 0.2, 0.3, 1.0)
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    
    gl.matrix_mode(gl.MODELVIEW)
    gl.load_identity()
    gl.translatef(0.0, 0.0, -5.0)
    gl.rotatef(rot_x, 1.0, 0.0, 0.0)
    gl.rotatef(rot_y, 0.0, 1.0, 0.0)
    
    gl.bind_texture(gl.TEXTURE_2D, tex_id)
    
	gl.enable_client_state(gl.VERTEX_ARRAY)
	gl.enable_client_state(gl.NORMAL_ARRAY)
	gl.enable_client_state(gl.TEXTURE_COORD_ARRAY)

	gl.vertex_pointer(3, gl.FLOAT, 32, cube_vertices)
	gl.normal_pointer(gl.FLOAT, 32, cube_vertices[12:])
	gl.tex_coord_pointer(2, gl.FLOAT, 32, cube_vertices[24:])

	gl.draw_elements(gl.TRIANGLES, len(cube_indices), gl.UNSIGNED_INT, cube_indices)

	gl.disable_client_state(gl.VERTEX_ARRAY)
	gl.disable_client_state(gl.NORMAL_ARRAY)
	gl.disable_client_state(gl.TEXTURE_COORD_ARRAY)
		
    glut.swap_buffers()
})

glut.reshape_func(fn(w, h) {
    gl.viewport(0, 0, w, h)
    gl.matrix_mode(gl.PROJECTION)
    gl.load_identity()
    glu.perspective(45.0, w/h, 0.1, 100.0)
})

glut.idle_func(fn() {
    rot_x += 0.5
    rot_y += 0.7
    glut.post_redisplay()
})

glut.keyboard_func(fn(key, x, y) {
    if key == "q" || key == "Q" { os.exit(0) }
})

glut.main_loop()