import "gl"
import "glut"
import "glu"
import "os"
import "math"
import "obj"
import "times"

model := null

// Camera State
cam_x := 0.0
cam_y := 2.0
cam_z := 5.0
yaw := -1.5708 // Starts facing -Z
pitch := 0.0

// Mouse State
last_mouse_x := -1
last_mouse_y := -1
is_dragging := false

glut.init()
glut.init_display_mode(glut.RGBA | glut.DOUBLE | glut.DEPTH)
glut.init_window_size(400, 400)
glut.create_window("3D OBJ Viewer")
gl.init()
// times.sleep(times.second*2)

glut.reshape_func(fn(w, h) {
    if h == 0 { h = 1 }
    gl.viewport(0, 0, w, h)
    gl.matrix_mode(gl.PROJECTION)
    gl.load_identity()
    glu.perspective(45.0/2, float(w)/float(h), 0.1, 100.0)
    gl.matrix_mode(gl.MODELVIEW)
})

model = obj.load_obj("monkey.obj")
if model == null {
    println("Failed to load model. Exiting.")
    os.exit(1)
}

glut.display_func(fn() {
    gl.clear_color(0.2, 0.3, 0.4, 1.0)
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    
    gl.load_identity()
    
    // Calculate view target based on yaw and pitch
    dir_x := math.cos(yaw) * math.cos(pitch)
    dir_y := math.sin(pitch)
    dir_z := math.sin(yaw) * math.cos(pitch)

    glu.look_at(
        cam_x, cam_y, cam_z,
        cam_x + dir_x, cam_y + dir_y, cam_z + dir_z,
        0, 1, 0
    )

    gl.enable(gl.LIGHTING)
    gl.enable(gl.LIGHT0)
    gl.lightfv(gl.LIGHT0, gl.POSITION, 1, 1, 1, 0)
    gl.lightfv(gl.LIGHT0, gl.DIFFUSE, 1, 1, 1, 1)
    gl.enable(gl.DEPTH_TEST)

    model.draw()
    glut.swap_buffers()
})

// Mouse Clicks
glut.mouse_func(fn(button, state, x, y) {
    if button == glut.LEFT_BUTTON {
        if state == glut.DOWN {
            is_dragging = true
            last_mouse_x = x
            last_mouse_y = y
        } else {
            is_dragging = false
        }
    }
})

// Mouse Dragging (Look Around)
glut.motion_func(fn(x, y) {
    if is_dragging {
        dx := float(x - last_mouse_x)
        dy := float(y - last_mouse_y)
        last_mouse_x = x
        last_mouse_y = y
        
        yaw += dx * 0.005
        pitch -= dy * 0.005
        
        // Prevent screen flip
        if pitch > 1.5 { pitch = 1.5 }
        if pitch < -1.5 { pitch = -1.5 }
        
        glut.post_redisplay()
    }
})

// Keyboard (Movement)
glut.keyboard_func(fn(key, x, y) {
    speed := 0.2
    
    if key == "w" {
        cam_x += math.cos(yaw) * speed
        cam_z += math.sin(yaw) * speed
    } else if key == "s" {
        cam_x -= math.cos(yaw) * speed
        cam_z -= math.sin(yaw) * speed
    } else if key == "a" {
        cam_x += math.cos(yaw - 1.5708) * speed
        cam_z += math.sin(yaw - 1.5708) * speed
    } else if key == "d" {
        cam_x += math.cos(yaw + 1.5708) * speed
        cam_z += math.sin(yaw + 1.5708) * speed
    } else if key == "q" || key == "Q" {
        os.exit(0)
    }
    
    glut.post_redisplay()
})

glut.main_loop()