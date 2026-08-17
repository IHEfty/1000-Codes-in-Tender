// tender@v0.0.9
import "gl"
import "glut"
import "os"
import "math"

// --- Window & Context Initialization ---
glut.init()
gl.init()
glut.init_display_mode(glut.RGBA | glut.DOUBLE | glut.DEPTH)
glut.init_window_size(600, 600)
glut.create_window("Tender OpenGL - Blackhole Simulation")

// --- Shaders ---
// Vertex Shader: Full-screen quad
var vertex_src = `
#version 120
attribute vec2 position;
void main() {
    gl_Position = vec4(position, 0.0, 1.0);
}
`

// Fragment Shader: Black Hole Physics and Raymarching Approximation
var frag_src = `
#version 120
uniform vec2 u_resolution;
uniform float u_time;

// Basic pseudo-random noise for the accretion disk
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// 2D Noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

void main() {
    // Normalize coordinates (centered)
    vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
    vec3 color = vec3(0.0);

    // Black hole parameters
    float rs = 0.15; // Schwarzschild radius (Event Horizon)
    float dist = length(uv);

    if (dist <= rs) {
        // Inside the Event Horizon: no light escapes
        color = vec3(0.0);
    } else {
        // Gravitational Lensing effect
        // Deflection angle approximation: alpha ~ 4GM / (rc^2)
        float deflection = (rs * rs) / (dist * dist);
        vec2 lensed_uv = uv * (1.0 - deflection);

        // Background (Simulated Starfield / Cosmic Grid)
        float bg_grid = smoothstep(0.9, 1.0, sin(lensed_uv.x * 60.0 + u_time * 0.2)) + 
                        smoothstep(0.9, 1.0, sin(lensed_uv.y * 60.0 + u_time * 0.2));
        vec3 background = vec3(bg_grid) * vec3(0.1, 0.3, 0.6); // Deep blue cosmic background

        // Accretion Disk Physics (Superheated plasma)
        // Highest density just outside the photon ring
        float disk_density = smoothstep(rs, rs + 0.15, dist) * smoothstep(rs + 0.5, rs + 0.1, dist);
        
        // Swirling motion
        float angle = atan(uv.y, uv.x);
        float swirl = angle * 5.0 - u_time * 3.0; // Rotation speed
        float n = noise(vec2(swirl, dist * 15.0));
        
        // Doppler Beaming Effect (brighter on the side moving towards observer)
        float doppler = 1.0 + 0.5 * sin(angle);
        
        vec3 disk_color = vec3(1.0, 0.4, 0.05) * disk_density * n * doppler * 2.5;

        // Photon Ring (Light trapped in tight orbit before escaping or falling in)
        float photon_ring = smoothstep(rs + 0.03, rs, dist) * smoothstep(rs, rs + 0.01, dist);
        vec3 ring_color = vec3(1.0, 0.9, 0.5) * photon_ring * 4.0;

        // Composite the scene
        color = background + disk_color + ring_color;
    }

    // Vignette and tone mapping
    color *= 1.0 - smoothstep(0.5, 1.5, length(uv));
    color = color / (1.0 + color); // Simple HDR tonemapping

    gl_FragColor = vec4(color, 1.0);
}
`

// --- Shader Compilation ---
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

// --- Geometry Setup (Quad) ---
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

// --- Main Loop Variables ---
var time_ = 0.0
var screen_w = 800.0
var screen_h = 800.0

// --- Rendering Loop ---
glut.display_func(fn() {
    gl.disable(gl.DEPTH_TEST)
    gl.disable(gl.LIGHTING)
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    
    gl.use_program(program)
    
    time_ += 0.015
    gl.uniform2f(res_loc, screen_w, screen_h)
    gl.uniform1f(time_loc, time_)
    
    gl.bind_vertex_array(vao)
    gl.draw_arrays(gl.TRIANGLES, 0, 6)
    gl.bind_vertex_array(0)
    gl.use_program(0)
    
    glut.swap_buffers()
})

// --- Event Handlers ---
glut.reshape_func(fn(w, h) {
    gl.viewport(0, 0, w, h)
    screen_w = float(w)
    screen_h = float(h)
})

glut.idle_func(fn() {
    glut.post_redisplay()
})

glut.keyboard_func(fn(key, x, y) {
    if key == "q" || key == "Q" { os.exit(0) }
})

// Start Simulation
glut.main_loop()