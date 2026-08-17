// tender@v0.0.9
import "gl"
import "glut"
import "glu"
import "os"
import "math"

// Camera and Interaction State
var cam_rot_x = 0.0
var cam_rot_y = 0.0
var cam_distance = 8.0
var mouse_down = false
var last_mouse_x = 0
var last_mouse_y = 0

glut.init()
gl.init()
glut.init_display_mode(glut.RGBA | glut.DOUBLE | glut.DEPTH)
glut.init_window_size(600, 400)
glut.create_window("Tender 3D - Rainbow Sandbox")

// Vertex Shader: Full-screen quad
var vertex_src = `
#version 120
attribute vec2 position;
void main() {
    gl_Position = vec4(position, 0.0, 1.0);
}
`

// Fragment Shader: Upgraded to calculate world-space camera rotation
var frag_src = `
#version 120
uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_cam_rot; // Camera pitch and yaw in radians

vec3 wavelengthToColor(float w) {
    vec3 color;
    if (w >= 380.0 && w < 440.0) { color = vec3(-(w - 440.0) / (440.0 - 380.0), 0.0, 1.0); }
    else if (w >= 440.0 && w < 490.0) { color = vec3(0.0, (w - 440.0) / (490.0 - 440.0), 1.0); }
    else if (w >= 490.0 && w < 510.0) { color = vec3(0.0, 1.0, -(w - 510.0) / (510.0 - 490.0)); }
    else if (w >= 510.0 && w < 580.0) { color = vec3((w - 510.0) / (580.0 - 510.0), 1.0, 0.0); }
    else if (w >= 580.0 && w < 645.0) { color = vec3(1.0, -(w - 645.0) / (645.0 - 580.0), 0.0); }
    else if (w >= 645.0 && w <= 780.0) { color = vec3(1.0, 0.0, 0.0); }
    else { color = vec3(0.0); }
    
    float factor;
    if (w >= 380.0 && w < 420.0) { factor = 0.3 + 0.7 * (w - 380.0) / (420.0 - 380.0); }
    else if (w >= 420.0 && w < 700.0) { factor = 1.0; }
    else if (w >= 700.0 && w <= 780.0) { factor = 0.3 + 0.7 * (780.0 - w) / (780.0 - 700.0); }
    else { factor = 0.0; }
    
    return color * factor;
}

void main() {
    vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
    vec3 viewDir = normalize(vec3(uv, -1.0)); 
    
    // Rotate the view direction based on the camera angles 
    // so the rainbow stays fixed in the world!
    float cx = u_cam_rot.x;
    float cosX = cos(cx);
    float sinX = sin(cx);
    float y1 = viewDir.y * cosX - viewDir.z * sinX;
    float z1 = viewDir.y * sinX + viewDir.z * cosX;
    viewDir.y = y1;
    viewDir.z = z1;
    
    float cy = u_cam_rot.y;
    float cosY = cos(cy);
    float sinY = sin(cy);
    float x2 = viewDir.x * cosY + viewDir.z * sinY;
    float z2 = -viewDir.x * sinY + viewDir.z * cosY;
    viewDir.x = x2;
    viewDir.z = z2;
    
    // The sun is behind us, bobbing slightly
    float sunX = sin(u_time * 0.5) * 0.2;
    vec3 sunDir = normalize(vec3(sunX, 0.3, 1.0)); 
    vec3 antiSolarDir = -sunDir;                   
    
    float angle = acos(dot(viewDir, antiSolarDir));
    float degrees = degrees(angle);
    
    // Dynamic Sky Gradient based on looking angle
    float horizon = clamp(viewDir.y + 0.5, 0.0, 1.0);
    vec3 skyColor = mix(vec3(0.6, 0.75, 0.9), vec3(0.1, 0.3, 0.6), horizon);
    
    vec3 rainbowColor = vec3(0.0);
    
    // Primary Rainbow
    if (degrees > 40.0 && degrees < 42.5) {
        float wavelength = mix(380.0, 780.0, (degrees - 40.0) / 2.5);
        float edgeBlend = smoothstep(40.0, 40.2, degrees) * (1.0 - smoothstep(42.3, 42.5, degrees));
        rainbowColor += wavelengthToColor(wavelength) * 0.8 * edgeBlend;
    }
    
    // Secondary Rainbow
    if (degrees > 50.0 && degrees < 53.0) {
        float wavelength = mix(780.0, 380.0, (degrees - 50.0) / 3.0);
        float edgeBlend = smoothstep(50.0, 50.2, degrees) * (1.0 - smoothstep(52.8, 53.0, degrees));
        rainbowColor += wavelengthToColor(wavelength) * 0.25 * edgeBlend;
    }
    
    // Alexander's Band
    if (degrees > 42.5 && degrees < 50.0) {
        skyColor *= 0.85; 
    }

    gl_FragColor = vec4(skyColor + rainbowColor, 1.0);
}
`

// Compile Shader Program
var vs = gl.create_shader(gl.VERTEX_SHADER)
gl.shader_source(vs, vertex_src)
gl.compile_shader(vs)
var fs = gl.create_shader(gl.FRAGMENT_SHADER)
gl.shader_source(fs, frag_src)
gl.compile_shader(fs)
var program = gl.create_program()
gl.attach_shader(program, vs)
gl.attach_shader(program, fs)
gl.link_program(program)

var res_loc = gl.get_uniform_location(program, "u_resolution")
var time_loc = gl.get_uniform_location(program, "u_time")
var cam_rot_loc = gl.get_uniform_location(program, "u_cam_rot")

// Quad Geometry for the Shader Background
var quad_vertices = [
    -1.0,  1.0,  -1.0, -1.0,   1.0, -1.0,  
    -1.0,  1.0,   1.0, -1.0,   1.0,  1.0   
]

var vaos = gl.gen_vertex_arrays(1)
var vao = vaos[0]
var vbos = gl.gen_buffers(1)
var vbo = vbos[0]

gl.bind_vertex_array(vao)
gl.bind_buffer(gl.ARRAY_BUFFER, vbo)
gl.buffer_data(gl.ARRAY_BUFFER, quad_vertices, gl.STATIC_DRAW)
gl.enable_vertex_attrib_array(0)
gl.vertex_attrib_pointer(0, 2, gl.FLOAT, false, 8, 0)
gl.bind_vertex_array(0)

// Sandbox 3D Lighting Setup (From light.td)
gl.enable(gl.NORMALIZE)
gl.enable(gl.COLOR_MATERIAL)

gl.lightfv(gl.LIGHT0, gl.POSITION, 5.0, 5.0, 5.0, 1.0)
gl.lightfv(gl.LIGHT0, gl.DIFFUSE, 1.0, 1.0, 1.0, 1.0)
gl.lightfv(gl.LIGHT0, gl.SPECULAR, 1.0, 1.0, 1.0, 1.0)

gl.lightfv(gl.LIGHT1, gl.POSITION, -5.0, -5.0, 5.0, 1.0)
gl.lightfv(gl.LIGHT1, gl.DIFFUSE, 0.3, 0.3, 1.0, 1.0)
gl.lightfv(gl.LIGHT1, gl.SPECULAR, 0.3, 0.3, 1.0, 1.0)

gl.materialfv(gl.FRONT_AND_BACK, gl.SPECULAR, 0.8, 0.8, 0.8, 1.0)
gl.materialf(gl.FRONT_AND_BACK, gl.SHININESS, 32.0)


var time_ = 0.0
var screen_w = 800.0
var screen_h = 600.0
var object_rot = 0.0

glut.display_func(fn() {
    // --- PASS 1: BACKGROUND SHADER ---
    gl.disable(gl.DEPTH_TEST) // Turn off depth so it draws flat on the screen
    gl.disable(gl.LIGHTING)   // Don't apply 3D lights to the shader
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    
    gl.use_program(program)
    
    time_ += 0.01
    gl.uniform2f(res_loc, screen_w, screen_h)
    gl.uniform1f(time_loc, time_)
    
    // Convert camera angles to radians and send to the shader
    var rad_x = cam_rot_x * math.pi / 180.0
    var rad_y = cam_rot_y * math.pi / 180.0
    gl.uniform2f(cam_rot_loc, rad_x, rad_y)
    
    gl.bind_vertex_array(vao)
    gl.draw_arrays(gl.TRIANGLES, 0, 6)
    gl.bind_vertex_array(0)
    gl.use_program(0) // Turn off shader

    
    // --- PASS 2: 3D SANDBOX ENVIRONMENT ---
    gl.enable(gl.DEPTH_TEST)
    gl.enable(gl.LIGHTING)
    gl.enable(gl.LIGHT0)
    gl.enable(gl.LIGHT1)
    
    // Clear depth again so 3D objects don't clip into the background
    gl.clear(gl.DEPTH_BUFFER_BIT) 
    
    gl.matrix_mode(gl.PROJECTION)
    gl.load_identity()
    glu.perspective(45.0, screen_w/screen_h, 0.1, 100.0)
    
    gl.matrix_mode(gl.MODELVIEW)
    gl.load_identity()
    
    // Apply Sandbox Camera View
    gl.translatef(0.0, 0.0, -cam_distance) 
    gl.rotatef(cam_rot_x, 1.0, 0.0, 0.0) 
    gl.rotatef(cam_rot_y, 0.0, 1.0, 0.0) 
    
    object_rot += 0.5
    
    // 1. Center Floating Torus
    gl.push_matrix()
    gl.color3f(0.8, 0.2, 0.3)
    gl.rotatef(object_rot, 1.0, 1.0, 0.0)
    glut.solid_torus(0.5, 1.5, 32, 32)
    gl.pop_matrix()
    
    // 2. Spinning Dodecahedron on the Left
    gl.push_matrix()
    gl.color3f(0.2, 0.8, 0.4)
    gl.translatef(-4.0, 0.0, 0.0)
    gl.rotatef(object_rot * 1.5, 0.0, 1.0, 0.0)
    gl.scalef(0.8, 0.8, 0.8)
    glut.solid_dodecahedron()
    gl.pop_matrix()
    
    // 3. Ground Sphere on the Right
    gl.push_matrix()
    gl.color3f(0.2, 0.4, 0.9)
    gl.translatef(4.0, -1.0, 0.0) 
    glut.solid_sphere(1.2, 32, 32)
    gl.pop_matrix()
    
    glut.swap_buffers()
})

glut.reshape_func(fn(w, h) {
    gl.viewport(0, 0, w, h)
    screen_w = float(w)
    screen_h = float(h)
})

// Mouse Interaction
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
        
        if cam_rot_x > 89.0 { cam_rot_x = 89.0 }
        if cam_rot_x < -89.0 { cam_rot_x = -89.0 }
        
        last_mouse_x = x
        last_mouse_y = y
    }
})

// Keyboard Zoom Controls
glut.special_func(fn(key, x, y) {
    if key == glut.KEY_UP {
        cam_distance -= 0.5
    } else if key == glut.KEY_DOWN {
        cam_distance += 0.5
    }
    
    if cam_distance < 3.0 { cam_distance = 3.0 }
    if cam_distance > 30.0 { cam_distance = 30.0 }
})

glut.idle_func(fn() {
    glut.post_redisplay()
})

glut.keyboard_func(fn(key, x, y) {
    if key == "q" || key == "Q" { os.exit(0) }
})

glut.main_loop()