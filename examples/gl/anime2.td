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
glut.create_window("Super Advanced Anime Toon Engine")

gl.enable(gl.DEPTH_TEST)
gl.enable(gl.LIGHTING)
gl.enable(gl.LIGHT0)
gl.enable(gl.TEXTURE_2D)

// Set up fixed lighting properties (the shader will read these automatically)
gl.lightfv(gl.LIGHT0, gl.POSITION, 3.0, 4.0, 5.0, 1.0)
gl.lightfv(gl.LIGHT0, gl.DIFFUSE, 1.0, 1.0, 1.0, 1.0)
gl.lightfv(gl.LIGHT0, gl.SPECULAR, 1.0, 1.0, 1.0, 1.0)

// Add a second light for rim (optional - we'll simulate rim in shader)
gl.enable(gl.LIGHT1)
gl.lightfv(gl.LIGHT1, gl.POSITION, -3.0, 2.0, -4.0, 1.0)
gl.lightfv(gl.LIGHT1, gl.DIFFUSE, 0.3, 0.3, 0.5, 1.0)

// --- Advanced Anime Shader Definition ---
var vertex_src = `
#version 120
varying vec3 vNormal;
varying vec3 vLightDir;
varying vec3 vViewDir;
varying vec2 vTexCoord;

void main() {
    // Transform normal and position to eye space
    vec3 eyePos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    vNormal = normalize(gl_NormalMatrix * gl_Normal);
    
    // Light direction (from light to vertex)
    vLightDir = normalize(gl_LightSource[0].position.xyz - eyePos);
    
    // View direction (from vertex to eye)
    vViewDir = normalize(-eyePos);
    
    vTexCoord = gl_MultiTexCoord0.xy;
    
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
`

var frag_src = `
#version 120
varying vec3 vNormal;
varying vec3 vLightDir;
varying vec3 vViewDir;
varying vec2 vTexCoord;
uniform sampler2D u_texture;

// Helper: Toon step with smooth transition
float toonStep(float value, float edge, float smooth) {
    return smoothstep(edge - smooth, edge + smooth, value);
}

void main() {
    vec3 normal = normalize(vNormal);
    vec3 lightDir = normalize(vLightDir);
    vec3 viewDir = normalize(vViewDir);
    
    // ----- Diffuse Lighting (Cel-Shading with 4 levels) -----
    float NdotL = dot(normal, lightDir);
    // Use smooth steps to create banding with subtle transitions
    float diff = 0.0;
    if (NdotL > 0.0) {
        // 4 bands: 0.0, 0.35, 0.65, 1.0
        float band1 = toonStep(NdotL, 0.2, 0.05);
        float band2 = toonStep(NdotL, 0.4, 0.05);
        float band3 = toonStep(NdotL, 0.7, 0.05);
        diff = mix(0.0, 0.4, band1);
        diff = mix(diff, 0.7, band2);
        diff = mix(diff, 1.0, band3);
    }
    // Add ambient base
    float ambient = 0.15;
    float diffuse = ambient + diff * 0.85;
    
    // ----- Toon Specular (stepped highlight) -----
    vec3 halfVec = normalize(lightDir + viewDir);
    float NdotH = dot(normal, halfVec);
    float spec = 0.0;
    if (NdotL > 0.0 && NdotH > 0.0) {
        // Blinn-Phong with toon stepping
        float specIntensity = pow(NdotH, 32.0);
        spec = step(0.5, specIntensity) * 0.8; // Sharp bright highlight
    }
    
    // ----- Rim Light (Fresnel) -----
    float rim = 1.0 - max(0.0, dot(normal, viewDir));
    rim = pow(rim, 2.0) * 0.6; // Rim intensity
    
    // ----- Shadow Color Tinting (cool/warm shift) -----
    // If diffuse is low, blend in a cool blue/purple tone
    vec3 shadowTint = vec3(0.2, 0.3, 0.6); // deep blue
    float shadowFactor = 1.0 - diffuse;     // 0 at full lit, 1 in shadow
    vec3 baseColor = texture2D(u_texture, vTexCoord).rgb;
    vec3 litColor = baseColor * diffuse;
    vec3 shadowColor = mix(baseColor * 0.3, baseColor * shadowTint, 0.7);
    vec3 finalColor = mix(litColor, shadowColor, shadowFactor * 0.8);
    
    // Add specular highlight
    finalColor += vec3(1.0, 0.9, 0.8) * spec;
    
    // Add rim light (soft glow)
    finalColor += vec3(0.8, 0.6, 1.0) * rim;
    
    // Optional: slight desaturation in shadow areas (anime style)
    float gray = dot(finalColor, vec3(0.299, 0.587, 0.114));
    finalColor = mix(finalColor, vec3(gray), shadowFactor * 0.2);
    
    gl_FragColor = vec4(finalColor, 1.0);
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
tex_id := gl.load_texture("textures/indoor plant_2_COL.jpg")
mesh_id := gl.load_obj("plant.obj")

// --- Interaction State Variables ---
var rot_x = 0.0
var rot_y = 0.0
var pos_x = -0.5
var pos_y = -3.0
var pos_z = -15.0

var is_dragging = false
var last_mouse_x = 0
var last_mouse_y = 0

// --- Render Callback ---
glut.display_func(fn() {
    gl.clear_color(0.4, 0.55, 0.7, 1.0)
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    
    gl.matrix_mode(gl.MODELVIEW)
    gl.load_identity()
    
    gl.translatef(pos_x, pos_y, pos_z)
    gl.rotatef(rot_x, 1.0, 0.0, 0.0)
    gl.rotatef(rot_y, 0.0, 1.0, 0.0)
    
    // Use the advanced toon shader
    gl.use_program(toon_program)
    
    gl.active_texture(gl.TEXTURE0)
    gl.bind_texture(gl.TEXTURE_2D, tex_id)
    gl.uniform1i(tex_uniform_loc, 0)
    
    gl.draw_obj(mesh_id)
    
    gl.use_program(0)
    gl.bind_texture(gl.TEXTURE_2D, 0)
    
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
    if button == 0 {
        if state == 0 {
            is_dragging = true
            last_mouse_x = x
            last_mouse_y = y
        } else {
            is_dragging = false
        }
    }
    if button == 3 && state == 0 { pos_z += 0.5; glut.post_redisplay() }
    if button == 4 && state == 0 { pos_z -= 0.5; glut.post_redisplay() }
})

// --- Motion Callback ---
glut.motion_func(fn(x, y) {
    if is_dragging {
        dx := x - last_mouse_x
        dy := y - last_mouse_y
        rot_y += dx * 0.5
        rot_x += dy * 0.5
        last_mouse_x = x
        last_mouse_y = y
        glut.post_redisplay()
    }
})

// --- Keyboard Callback ---
glut.keyboard_func(fn(key, x, y) {
    if key == "w" || key == "W" { pos_y += 0.2 }
    if key == "s" || key == "S" { pos_y -= 0.2 }
    if key == "a" || key == "A" { pos_x -= 0.2 }
    if key == "d" || key == "D" { pos_x += 0.2 }
    if key == "+" || key == "=" { pos_z += 0.5 }
    if key == "-" || key == "_" { pos_z -= 0.5 }
    if key == "c" || key == "C" { print("Advanced cel-shading active!") }
    if key == "q" || key == "Q" { os.exit(0) }
    glut.post_redisplay()
})

glut.idle_func(fn() { glut.post_redisplay() })

glut.main_loop()