import "gl"
import "glut"
import "glu"
import "os"
import "math"

glut.init()
gl.init()
glut.init_display_mode(glut.RGBA | glut.DOUBLE | glut.DEPTH)
glut.init_window_size(440, 440)
glut.init_window_position(100, 100)
glut.create_window("Interactive Anime Toon Engine")

gl.enable(gl.DEPTH_TEST)
gl.enable(gl.LIGHTING)
gl.enable(gl.LIGHT0)
gl.enable(gl.TEXTURE_2D)

// Set up fixed lighting properties (The shader will read this automatically!)
gl.lightfv(gl.LIGHT0, gl.POSITION, 3.0, 4.0, 5.0, 1.0)
gl.lightfv(gl.LIGHT0, gl.DIFFUSE, 1.0, 1.0, 1.0, 1.0)

// --- Toon Shader Definition ---
var vertex_src = `
#version 120
varying vec3 vNormal;
varying vec3 vLightDir;
varying vec2 vTexCoord;
varying vec3 vViewDir;

void main() {
    // Transform normal into eye space
    vNormal = normalize(gl_NormalMatrix * gl_Normal);
    
    // Grab fixed light position from gl.lightfv automatically
    vLightDir = normalize(gl_LightSource[0].position.xyz);
    
    // Calculate the view direction (from vertex to camera) for rim lighting
    vec3 viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    vViewDir = normalize(-viewPos);
    
    // Forward standard texture coordinates
    vTexCoord = gl_MultiTexCoord0.xy;
    
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
`

var frag_src = `
#version 120
varying vec3 vNormal;
varying vec3 vLightDir;
varying vec2 vTexCoord;
varying vec3 vViewDir;
uniform sampler2D u_texture;

void main() {
    vec3 n = normalize(vNormal);
    vec3 l = normalize(vLightDir);
    vec3 v = normalize(vViewDir);
    
    // Calculate diffuse light intensity
    float NdotL = dot(n, l);
    
    // --- Nature Anime Art Direction ---
    // Anime nature uses cool shadows and warm highlights, not just greyscale darkening.
    vec3 shadowColor = vec3(0.55, 0.60, 0.85); // Airy, cool blue/purple sky ambient
    vec3 lightColor = vec3(1.1, 1.05, 0.95);   // Warm sunlight
    
    float shadowFactor;
    vec3 colorTint;
    
    // Crisp Cel-Shading Steps with Color Mixing
    if (NdotL > 0.4) {
        shadowFactor = 1.0;
        colorTint = lightColor;
    } else if (NdotL > 0.1) {
        shadowFactor = 0.85; // Softer midtone drop-off for foliage
        colorTint = mix(shadowColor, lightColor, 0.5);
    } else {
        shadowFactor = 0.65; // Keep shadows relatively bright and airy
        colorTint = shadowColor;
    }
    
    // --- Rim Lighting (Fresnel Effect) ---
    // Simulates sunlight scattering through the thin edges of leaves
    float rimDot = 1.0 - max(dot(v, n), 0.0);
    // Only apply rim light on the illuminated side of the object
    float rimIntensity = smoothstep(0.65, 0.9, rimDot) * max(NdotL, 0.0);
    vec3 rimColor = vec3(0.7, 1.0, 0.5) * rimIntensity * 0.8; // Greenish-yellow glow
    
    // --- Final Composition ---
    vec4 texColor = texture2D(u_texture, vTexCoord);
    
    // Multiply texture by shadow step, apply the color tint, and add the rim glow
    vec3 finalColor = (texColor.rgb * shadowFactor * colorTint) + rimColor;
    
    gl_FragColor = vec4(finalColor, texColor.a);
}
`

// --- Compile and Link the Toon Program ---
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

var toon_program = gl.create_program()
gl.attach_shader(toon_program, vs)
gl.attach_shader(toon_program, fs)
gl.link_program(toon_program)

// Get texture sampler location
var tex_uniform_loc = gl.get_uniform_location(toon_program, "u_texture")

// --- Load Model Assets ---
tex_id := gl.load_texture("color.jpg")
mesh_id := gl.load_obj("girl.obj")

// --- Interaction State Variables ---
var rot_x = 20
var rot_y = -32
var pos_x = 0.10000000000000003
var pos_y = -0.8
var pos_z = -2.5


var is_dragging = false
var last_mouse_x = 0
var last_mouse_y = 0

// --- Render Callback ---
glut.display_func(fn() {
    gl.clear_color(0.4, 0.55, 0.7, 1.0) // Nice clear background color
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    
    gl.matrix_mode(gl.MODELVIEW)
    gl.load_identity()
    
    // Apply camera viewing transforms
    gl.translatef(pos_x, pos_y, pos_z)
    gl.rotatef(rot_x, 1.0, 0.0, 0.0)
    gl.rotatef(rot_y, 0.0, 1.0, 0.0)
    
    // 1. Activate the Toon Shader
    gl.use_program(toon_program)
    
    // 2. Bind the active texture asset to unit 0
    gl.active_texture(gl.TEXTURE0)
    gl.bind_texture(gl.TEXTURE_2D, tex_id)
    gl.uniform1i(tex_uniform_loc, 0) // Tell shader to use texture unit 0
    
    // 3. Draw the mesh using the shader
    gl.draw_obj(mesh_id)
    
    // 4. Cleanup (optional)
    gl.use_program(0) // Disable shader
    gl.bind_texture(gl.TEXTURE_2D, 0) // Unbind texture
    
    glut.swap_buffers()
})

// --- Reshape Callback ---
glut.reshape_func(fn(w, h) {
    gl.viewport(0, 0, w, h)
    gl.matrix_mode(gl.PROJECTION)
    gl.load_identity()
    glu.perspective(45.0, w/h, 0.1, 100.0)
})

// --- Mouse Callback ---
glut.mouse_func(fn(button, state, x, y) {
    // Left click (0) to drag
    if button == 0 {
        if state == 0 { // Button down
            is_dragging = true
            last_mouse_x = x
            last_mouse_y = y
        } else {        // Button up
            is_dragging = false
        }
    }
    
    // Scroll wheel to zoom (Buttons 3 and 4 in standard GLUT)
    if button == 3 && state == 0 { 
        pos_z += 0.5
        glut.post_redisplay()
    }
    if button == 4 && state == 0 { 
        pos_z -= 0.5
        glut.post_redisplay()
    }
})

// --- Motion Callback ---
glut.motion_func(fn(x, y) {
    if is_dragging {
        dx := x - last_mouse_x
        dy := y - last_mouse_y
        
        // Update rotations based on mouse delta
        rot_y += dx * 0.5
        rot_x += dy * 0.5
        
        last_mouse_x = x
        last_mouse_y = y
        
        glut.post_redisplay()
    }
})

// --- Keyboard Callback ---
glut.keyboard_func(fn(key, x, y) {
    // Movement
    if key == "w" || key == "W" { pos_y += 0.2 }
    if key == "s" || key == "S" { pos_y -= 0.2 }
    if key == "a" || key == "A" { pos_x -= 0.2 }
    if key == "d" || key == "D" { pos_x += 0.2 }
    
    // Zoom keys (alternative to scroll wheel)
    if key == "+" || key == "=" { pos_z += 0.5 }
    if key == "-" || key == "_" { pos_z -= 0.5 }
    
    // Toggle cel-shading steps (optional feature)
    if key == "c" || key == "C" {
        // Could toggle between different shading styles
        print("Cel-shading active!")
    }
    
    // Exit
    if key == "q" || key == "Q" { os.exit(0) }
    if key == "p" || key == "P" { 
		println(`
var rot_x = ${rot_x}
var rot_y = ${rot_y}
var pos_x = ${pos_x}
var pos_y = ${pos_y}
var pos_z = ${pos_z}
		`)
	}
    
    glut.post_redisplay()
})

// --- Idle Callback for Continuous Animation ---
glut.idle_func(fn() {
    glut.post_redisplay()
})

// --- Start the Main Loop ---
glut.main_loop()