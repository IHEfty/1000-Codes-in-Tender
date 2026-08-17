// tender@v0.0.9
import "gl"
import "glut"
import "os"
import "math"

// --- Context Setup ---
glut.init()
gl.init()
glut.init_display_mode(glut.RGBA | glut.DOUBLE | glut.DEPTH)
glut.init_window_size(600, 600)
glut.create_window("Tender 3D Black Hole - Gargantua")

// --- Shaders ---
var vertex_src = `
#version 120
attribute vec2 position;
void main() {
    gl_Position = vec4(position, 0.0, 1.0);
}
`

// Non-linear Raytracing Fragment Shader
var frag_src = `
#version 120
uniform vec2 u_resolution;
uniform float u_time;
uniform vec3 u_cam_pos;
uniform float u_yaw;
uniform float u_pitch;

// Rotation matrices for the camera
mat3 rotY(float a) {
    float s = sin(a), c = cos(a);
    return mat3(c, 0.0, s, 0.0, 1.0, 0.0, -s, 0.0, c);
}

mat3 rotX(float a) {
    float s = sin(a), c = cos(a);
    return mat3(1.0, 0.0, 0.0, 0.0, c, -s, 0.0, s, c);
}

// Pseudo-random noise for the accretion disk
float hash(float n) { return fract(sin(n) * 43758.5453123); }
float noise(vec3 x) {
    vec3 p = floor(x);
    vec3 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    float n = p.x + p.y * 57.0 + 113.0 * p.z;
    return mix(mix(mix(hash(n + 0.0), hash(n + 1.0), f.x),
                   mix(hash(n + 57.0), hash(n + 58.0), f.x), f.y),
               mix(mix(hash(n + 113.0), hash(n + 114.0), f.x),
                   mix(hash(n + 170.0), hash(n + 171.0), f.x), f.y), f.z);
}

void main() {
    // Normalized device coordinates
    vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
    
    // Camera Setup
    vec3 ro = u_cam_pos;
    vec3 rd = normalize(vec3(uv, 1.0)); // Field of view
    
    // Apply Camera Rotation
    rd = rotY(u_yaw) * rotX(u_pitch) * rd;
    
    // Simulation Parameters
    float GM = 0.5; // Mass of the black hole
    float dt = 0.04; // Ray step size
    
    vec3 p = ro;
    vec3 v = rd;
    vec3 col = vec3(0.0);
    
    float escape_dist = 15.0; // Distance at which we consider light to have escaped
    bool hit_blackhole = false;
    
    // Curved Raymarching Loop
    for (int i = 0; i < 150; i++) {
        float r = length(p);
        
        // 1. Event Horizon Check (Absorbed)
        if (r < GM * 1.5) {
            hit_blackhole = true;
            break;
        }
        
        // 2. Escaped the gravitational well
        if (r > escape_dist) {
            break;
        }
        
        // 3. Gravity Calculation (Bending the light)
        // Pseudo-Newtonian approximation for photon orbits
        vec3 gravity = -p * (GM / (r * r * r * r));
        v = normalize(v + gravity * dt);
        
        vec3 next_p = p + v * dt;
        
        // 4. Accretion Disk Volumetric Integration
        // Check if the ray crosses or is inside the disk volume
        if (abs(p.y) < 0.1 && r > GM * 2.5 && r < GM * 8.0) {
            // Calculate orbital velocity for Doppler effect
            vec3 orbit_vel = normalize(vec3(-p.z, 0.0, p.x)); // Counter-clockwise rotation
            float dot_v = dot(v, orbit_vel);
            
            // Relativistic Doppler Beaming (Blue shift approaching, Red shift receding)
            float doppler = 1.0 + 1.2 * dot_v; 
            
            // Disk Structure and Noise
            float angle = atan(p.z, p.x);
            float radius_mask = smoothstep(GM * 2.5, GM * 3.5, r) * smoothstep(GM * 8.0, GM * 5.0, r);
            float n = noise(vec3(r * 3.0, angle * 10.0 - u_time * 2.0, u_time));
            
            // Temperature mapping (Inner = Hot/Blue-White, Outer = Cooler/Orange)
            vec3 base_col = mix(vec3(1.0, 0.4, 0.1), vec3(0.8, 0.9, 1.0), smoothstep(GM * 8.0, GM * 2.5, r));
            
            // Accumulate color (additive blending)
            col += base_col * radius_mask * n * doppler * 0.12;
        }
        
        p = next_p;
    }
    
    // 5. Background Starfield (If escaped)
    if (!hit_blackhole && length(p) > escape_dist - 1.0) {
        vec3 bg_dir = normalize(v);
        // Map directions to a grid/starfield so lensing is obvious
        float grid = smoothstep(0.98, 1.0, sin(bg_dir.x * 50.0)) + 
                     smoothstep(0.98, 1.0, sin(bg_dir.y * 50.0)) +
                     smoothstep(0.98, 1.0, sin(bg_dir.z * 50.0));
                     
        float stars = pow(noise(bg_dir * 100.0), 15.0) * 5.0;
        
        col += vec3(0.05, 0.1, 0.2) * grid * 0.3; // Dim grid
        col += vec3(stars); // Stars
    }
    
    // HDR Tonemapping & Gamma Correction
    col = col / (1.0 + col);
    col = pow(col, vec3(1.0 / 2.2));
    
    gl_FragColor = vec4(col, 1.0);
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

// --- Uniform Locations ---
var res_loc = gl.get_uniform_location(program, "u_resolution")
var time_loc = gl.get_uniform_location(program, "u_time")
var cam_pos_loc = gl.get_uniform_location(program, "u_cam_pos")
var yaw_loc = gl.get_uniform_location(program, "u_yaw")
var pitch_loc = gl.get_uniform_location(program, "u_pitch")

// --- Full Screen Quad ---
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

// --- State Variables ---
var time_ = 0.0
var screen_w = 1000.0
var screen_h = 800.0

// Camera State
var cam_x = 0.0
var cam_y = 1.5
var cam_z = -8.0
var yaw = 0.0
var pitch = -0.15

// --- Render Loop ---
glut.display_func(fn() {
    gl.disable(gl.DEPTH_TEST)
    gl.clear(gl.COLOR_BUFFER_BIT)
    
    gl.use_program(program)
    
    time_ += 0.02
    gl.uniform2f(res_loc, screen_w, screen_h)
    gl.uniform1f(time_loc, time_)
    gl.uniform3f(cam_pos_loc, cam_x, cam_y, cam_z)
    gl.uniform1f(yaw_loc, yaw)
    gl.uniform1f(pitch_loc, pitch)
    
    gl.bind_vertex_array(vao)
    gl.draw_arrays(gl.TRIANGLES, 0, 6)
    gl.bind_vertex_array(0)
    
    glut.swap_buffers()
})

// --- Input & Window Handlers ---
glut.reshape_func(fn(w, h) {
    gl.viewport(0, 0, w, h)
    screen_w = float(w)
    screen_h = float(h)
})

glut.idle_func(fn() {
    glut.post_redisplay()
})

glut.keyboard_func(fn(key, x, y) {
    var move_speed = 0.3
    var look_speed = 0.05
    
    // Movement (WSAD)
    if key == "w" || key == "W" { cam_z += move_speed * math.cos(yaw); cam_x -= move_speed * math.sin(yaw) }
    if key == "s" || key == "S" { cam_z -= move_speed * math.cos(yaw); cam_x += move_speed * math.sin(yaw) }
    if key == "a" || key == "A" { cam_x -= move_speed * math.cos(yaw); cam_z -= move_speed * math.sin(yaw) }
    if key == "d" || key == "D" { cam_x += move_speed * math.cos(yaw); cam_z += move_speed * math.sin(yaw) }
    
    // Camera Look (IJKL)
    if key == "j" || key == "J" { yaw -= look_speed }
    if key == "l" || key == "L" { yaw += look_speed }
    if key == "i" || key == "I" { pitch += look_speed }
    if key == "k" || key == "K" { pitch -= look_speed }
    
    // Exit
    if key == "q" || key == "Q" { os.exit(0) }
})

// Start Simulation
glut.main_loop()