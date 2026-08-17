// tender@v0.0.9
import "gl"
import "glut"
import "os"
import "math"

glut.init()
gl.init()
glut.init_display_mode(glut.RGBA | glut.DOUBLE)
glut.init_window_size(600, 400)
glut.create_window("Physics-Based Shader Rainbow")

// Vertex Shader: Just draws a full-screen flat quad
var vertex_src = `
#version 120
attribute vec2 position;
void main() {
    gl_Position = vec4(position, 0.0, 1.0);
}
`

// Fragment Shader: Handles the physics of water droplet light refraction
var frag_src = `
#version 120
uniform vec2 u_resolution;
uniform float u_time;

// Convert a physical light wavelength (in nm) to an RGB color
vec3 wavelengthToColor(float w) {
    vec3 color;
    if (w >= 380.0 && w < 440.0) { color = vec3(-(w - 440.0) / (440.0 - 380.0), 0.0, 1.0); }
    else if (w >= 440.0 && w < 490.0) { color = vec3(0.0, (w - 440.0) / (490.0 - 440.0), 1.0); }
    else if (w >= 490.0 && w < 510.0) { color = vec3(0.0, 1.0, -(w - 510.0) / (510.0 - 490.0)); }
    else if (w >= 510.0 && w < 580.0) { color = vec3((w - 510.0) / (580.0 - 510.0), 1.0, 0.0); }
    else if (w >= 580.0 && w < 645.0) { color = vec3(1.0, -(w - 645.0) / (645.0 - 580.0), 0.0); }
    else if (w >= 645.0 && w <= 780.0) { color = vec3(1.0, 0.0, 0.0); }
    else { color = vec3(0.0); }
    
    // Smooth falloff at the invisible edges of the spectrum
    float factor;
    if (w >= 380.0 && w < 420.0) { factor = 0.3 + 0.7 * (w - 380.0) / (420.0 - 380.0); }
    else if (w >= 420.0 && w < 700.0) { factor = 1.0; }
    else if (w >= 700.0 && w <= 780.0) { factor = 0.3 + 0.7 * (780.0 - w) / (780.0 - 700.0); }
    else { factor = 0.0; }
    
    return color * factor;
}

void main() {
    // Normalize pixel coordinates (from -1 to 1)
    vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
    
    // Simulate a camera looking into the Z-axis
    vec3 viewDir = normalize(vec3(uv, -1.0)); 
    
    // Slowly animate the sun moving behind the viewer
    float sunX = sin(u_time * 0.5) * 0.2;
    vec3 sunDir = normalize(vec3(sunX, 0.3, 1.0)); // The sun is behind us
    vec3 antiSolarDir = -sunDir;                   // The center of the rainbow
    
    // Calculate the angle between our viewing ray and the anti-solar point
    float angle = acos(dot(viewDir, antiSolarDir));
    float degrees = degrees(angle);
    
    // Base sky atmospheric scattering (simple gradient)
    vec3 skyColor = mix(vec3(0.6, 0.75, 0.9), vec3(0.1, 0.3, 0.6), uv.y + 0.5);
    
    vec3 rainbowColor = vec3(0.0);
    
    // Primary Rainbow (40 to 42.5 degrees)
    if (degrees > 40.0 && degrees < 42.5) {
        // Map degrees to light wavelengths (380nm violet to 780nm red)
        float wavelength = mix(380.0, 780.0, (degrees - 40.0) / 2.5);
        // Add soft blending at the edges using smoothstep
        float edgeBlend = smoothstep(40.0, 40.2, degrees) * (1.0 - smoothstep(42.3, 42.5, degrees));
        rainbowColor += wavelengthToColor(wavelength) * 0.8 * edgeBlend;
    }
    
    // Secondary Rainbow (50 to 53 degrees, twice-reflected, inverted spectrum)
    if (degrees > 50.0 && degrees < 53.0) {
        // Note: Wavelength calculation is reversed (780.0 to 380.0)
        float wavelength = mix(780.0, 380.0, (degrees - 50.0) / 3.0);
        float edgeBlend = smoothstep(50.0, 50.2, degrees) * (1.0 - smoothstep(52.8, 53.0, degrees));
        rainbowColor += wavelengthToColor(wavelength) * 0.25 * edgeBlend; // Fainter
    }
    
    // Alexander's Band (the dark space between the two bows)
    if (degrees > 42.5 && degrees < 50.0) {
        skyColor *= 0.85; 
    }

    // Blend the optical effect into the sky additively
    gl_FragColor = vec4(skyColor + rainbowColor, 1.0);
}
`

// Compile and Link Shaders
var vs = gl.create_shader(gl.VERTEX_SHADER)
gl.shader_source(vs, vertex_src)
gl.compile_shader(vs)
if gl.get_shader_iv(vs, gl.COMPILE_STATUS) == 0 {
    print("Vertex Shader Error: " + gl.get_shader_info_log(vs))
}

var fs = gl.create_shader(gl.FRAGMENT_SHADER)
gl.shader_source(fs, frag_src)
gl.compile_shader(fs)
if gl.get_shader_iv(fs, gl.COMPILE_STATUS) == 0 {
    print("Fragment Shader Error: " + gl.get_shader_info_log(fs))
}

var program = gl.create_program()
gl.attach_shader(program, vs)
gl.attach_shader(program, fs)
gl.link_program(program)

// Get uniform locations
var res_loc = gl.get_uniform_location(program, "u_resolution")
var time_loc = gl.get_uniform_location(program, "u_time")

// Full Screen Quad Geometry 
var quad_vertices = [
    -1.0,  1.0,  
    -1.0, -1.0,  
     1.0, -1.0,  
    -1.0,  1.0,  
     1.0, -1.0,  
     1.0,  1.0   
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

var time_ = 0.0
var screen_w = 800.0
var screen_h = 600.0

glut.display_func(fn() {
    gl.clear(gl.COLOR_BUFFER_BIT)
    gl.use_program(program)
    
    time_ += 0.01
    gl.uniform2f(res_loc, screen_w, screen_h)
    gl.uniform1f(time_loc, time_)
    
    gl.bind_vertex_array(vao)
    gl.draw_arrays(gl.TRIANGLES, 0, 6)
    gl.bind_vertex_array(0)
    
    glut.swap_buffers()
})

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

glut.main_loop()