import "gl"
import "glut"
import "os"
import "math"

// Global state for interactive camera
var cam_rot_x = 15.0
var cam_rot_y = -30.0
var cam_distance = 15.0
var mouse_down = false
var last_mouse_x = 0
var last_mouse_y = 0

// Helper function to setup 3D perspective
fn set_perspective(fov, aspect, near, far) {
    f := 1.0 / math.tan(fov * math.pi / 360.0)
    gl.load_identity()
    gl.mult_matrixf(
        f / aspect, 0.0, 0.0, 0.0,
        0.0, f, 0.0, 0.0,
        0.0, 0.0, (far + near) / (near - far), -1.0,
        0.0, 0.0, (2.0 * far * near) / (near - far), 0.0
    )
}

glut.init()
gl.init()
glut.init_display_mode(glut.RGBA | glut.DOUBLE | glut.DEPTH)
glut.init_window_size(600, 400)
glut.init_window_position(100, 100)
glut.create_window("Tender 3D - Realistic Rainbow")

gl.enable(gl.DEPTH_TEST)

// ROYGBIV with an alpha channel for transparency (0.0 to 1.0)
var rainbow_colors = [
    [1.0, 0.0, 0.0, 0.4],    // Red
    [1.0, 0.5, 0.0, 0.4],    // Orange
    [1.0, 1.0, 0.0, 0.4],    // Yellow
    [0.0, 1.0, 0.0, 0.4],    // Green
    [0.0, 0.0, 1.0, 0.4],    // Blue
    [0.29, 0.0, 0.51, 0.4],  // Indigo
    [0.56, 0.0, 1.0, 0.4]    // Violet
]

glut.display_func(fn() {
    // Soft sky-blue background
    gl.clear_color(0.5, 0.7, 0.9, 1.0)
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    
    gl.matrix_mode(gl.MODELVIEW)
    gl.load_identity()
    
    // Position the camera based on user interaction
    gl.translatef(0.0, -1.0, -cam_distance)
    gl.rotatef(cam_rot_x, 1.0, 0.0, 0.0)
    gl.rotatef(cam_rot_y, 0.0, 1.0, 0.0)
    
    // Draw the ground plane (grass/grid)
    gl.disable(gl.BLEND)
    gl.color3f(0.2, 0.5, 0.2)
    gl.begin(gl.LINES)
    for i in range(-15, 16) {
        gl.vertex3f(-15.0, 0.0, float(i))
        gl.vertex3f(15.0, 0.0, float(i))
        gl.vertex3f(float(i), 0.0, -15.0)
        gl.vertex3f(float(i), 0.0, 15.0)
    }
    gl.end()
    
    // Enable blending for the translucent light effect
    gl.enable(gl.BLEND)
    gl.blend_func(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
    
    // Geometry settings for the rainbow
    var num_segments = 64
    var base_radius = 8.0
    var thickness = 0.3
    var ribbon_depth = 2.0  // The width of the rainbow across the Z axis
    
    // Render each color band
    for c in range(0, 7) {
        gl.color4f(rainbow_colors[c][0], rainbow_colors[c][1], rainbow_colors[c][2], rainbow_colors[c][3])
        var r = base_radius - (c * thickness)
        
        // Draw the arch using a sequence of quads
        for i in range(0, num_segments) {
            var angle1 = (i * math.pi) / num_segments
            var angle2 = ((i + 1) * math.pi) / num_segments
            
            var x1 = math.cos(angle1) * r
            var y1 = math.sin(angle1) * r
            var x2 = math.cos(angle2) * r
            var y2 = math.sin(angle2) * r
            
            gl.begin(gl.QUADS)
            gl.vertex3f(x1, y1, ribbon_depth / 2.0)
            gl.vertex3f(x2, y2, ribbon_depth / 2.0)
            gl.vertex3f(x2, y2, -ribbon_depth / 2.0)
            gl.vertex3f(x1, y1, -ribbon_depth / 2.0)
            gl.end()
        }
    }
    
    gl.disable(gl.BLEND)
    glut.swap_buffers()
})

glut.reshape_func(fn(w, h) {
    gl.viewport(0, 0, w, h)
    gl.matrix_mode(gl.PROJECTION)
    gl.load_identity()
    
    // Protect against division by zero in the aspect ratio
    var aspect = 1.0
    if h > 0 {
        aspect = float(w) / float(h)
    }
    set_perspective(55.0, aspect, 0.1, 100.0)
})

// Mouse and camera interaction 
glut.mouse_func(fn(button, state, x, y) {
    if button == glut.LEFT_BUTTON {
        if state == glut.DOWN {
            mouse_down = true
            last_mouse_x = x
            last_mouse_y = y
        } else {
            mouse_down = false
        }
    }
})

glut.motion_func(fn(x, y) {
    if mouse_down {
        dx := x - last_mouse_x
        dy := y - last_mouse_y
        cam_rot_y += dx * 0.4
        cam_rot_x += dy * 0.4
        
        // Clamp vertical rotation so you don't flip under the floor
        if cam_rot_x > 90.0 {
            cam_rot_x = 90.0
        } else if cam_rot_x < -5.0 {
            cam_rot_x = -5.0
        }
        
        last_mouse_x = x
        last_mouse_y = y
        glut.post_redisplay()
    }
})

glut.keyboard_func(fn(key, x, y) {
    if key == "q" || key == "Q" {
        os.exit(0)
    }
})

glut.special_func(fn(key, x, y) {
    if key == glut.KEY_UP {
        cam_distance -= 0.5
    } else if key == glut.KEY_DOWN {
        cam_distance += 0.5
    }
    
    if cam_distance < 2.0 {
        cam_distance = 2.0
    } else if cam_distance > 40.0 {
        cam_distance = 40.0
    }
    glut.post_redisplay()
})

// Kick off the loop
glut.main_loop()