import "gl"
import "glu"
import "glut"
import "os"
import "math"
import "rand"
import "times"

// Constants
const GRID_WIDTH = 10
const GRID_HEIGHT = 20
const BLOCK_SIZE = 20
const WINDOW_WIDTH = 380 
const WINDOW_HEIGHT = 450 

// Tetromino shapes
const SHAPES = [
    [[1, 1, 1, 1]], // I
    [[1, 1],        // O
     [1, 1]],
    [[0, 1, 0],     // T
     [1, 1, 1]],
    [[0, 1, 1],     // S
     [1, 1, 0]],
    [[1, 1, 0],     // Z
     [0, 1, 1]],
    [[1, 0, 0],     // L
     [1, 1, 1]],
    [[0, 0, 1],     // J
     [1, 1, 1]]
]

const COLORS = [
    [0.0, 0.0, 0.0],      // Empty
    [0.0, 1.0, 1.0],      // I - Cyan
    [1.0, 1.0, 0.0],      // O - Yellow
    [1.0, 0.0, 1.0],      // T - Purple
    [0.0, 1.0, 0.0],      // S - Green
    [1.0, 0.0, 0.0],      // Z - Red
    [1.0, 0.5, 0.0],      // L - Orange
    [0.0, 0.0, 1.0]       // J - Blue
]

// Game state
grid := []
for i := 0; i < GRID_HEIGHT; i++ {
    row := []
    for j := 0; j < GRID_WIDTH; j++ {
        row = append(row, 0)
    }
    grid = append(grid, row)
}

current_piece := 0
current_rotation := 0
current_x := GRID_WIDTH / 2 - 1
current_y := 0
next_piece := 0
score := 0
level := 1
lines_cleared := 0
game_over := false
drop_counter := 0
drop_interval := 30
move_cooldown := 0
das_active := false
const DAS_DELAY = 12
const ARR = 3

// Camera State (Zoom and Orientation)
cam_zoom := 24.0
cam_rot_x := 0.0
cam_rot_y := 0.0
is_dragging := false
last_mouse_x := 0
last_mouse_y := 0

// Keyboard state
key_left := false
key_right := false
key_down := false
key_rotate := false

fn rand_int() {
    min := 1
    max := 100
    return int(math.floor(rand.float() * float(max - min + 1)) + float(min))
}

fn get_piece_shape(piece, rotation) {
    shape := SHAPES[piece]
    rows := len(shape)
    cols := len(shape[0])
    
    if rotation == 0 {
        return shape
    }
    
    rotated := []
    for i := 0; i < cols; i++ {
        row := []
        for j := 0; j < rows; j++ {
            if rotation == 1 {
                row = append(row, shape[rows - 1 - j][i])
            } else if rotation == 2 {
                row = append(row, shape[rows - 1 - i][cols - 1 - j])
            } else if rotation == 3 {
                row = append(row, shape[j][cols - 1 - i])
            }
        }
        rotated = append(rotated, row)
    }
    return rotated
}

fn can_place(shape, x, y) {
    rows := len(shape)
    cols := len(shape[0])
    
    for i := 0; i < rows; i++ {
        for j := 0; j < cols; j++ {
            if shape[i][j] != 0 {
                grid_x := x + j
                grid_y := y + i
                
                if grid_x < 0 || grid_x >= GRID_WIDTH || grid_y >= GRID_HEIGHT {
                    return false
                }
                if grid_y >= 0 && grid[grid_y][grid_x] != 0 {
                    return false
                }
            }
        }
    }
    return true
}

fn lock_piece() {
    shape := get_piece_shape(current_piece, current_rotation)
    rows := len(shape)
    cols := len(shape[0])
    
    for i := 0; i < rows; i++ {
        for j := 0; j < cols; j++ {
            if shape[i][j] != 0 {
                grid_x := current_x + j
                grid_y := current_y + i
                
                if grid_y < 0 {
                    game_over = true
                    return
                }
                grid[grid_y][grid_x] = current_piece + 1
            }
        }
    }
    
    // Check for completed lines
    lines := 0
    i := GRID_HEIGHT - 1
    for i >= 0 {
        full := true
        for j := 0; j < GRID_WIDTH; j++ {
            if grid[i][j] == 0 {
                full = false
                break
            }
        }
        if full {
            k := i
            for k > 0 {
                j := 0
                for j < GRID_WIDTH {
                    grid[k][j] = grid[k-1][j]
                    j++
                }
                k--
            }
            j := 0
            for j < GRID_WIDTH {
                grid[0][j] = 0
                j++
            }
            lines++
        } else {
            i--
        }
    }
    
    // Update score and level
    if lines > 0 {
        lines_cleared += lines
        if lines == 1 { score += 100 * level }
        else if lines == 2 { score += 300 * level }
        else if lines == 3 { score += 500 * level }
        else if lines == 4 { score += 800 * level }
        
        level = lines_cleared / 10 + 1
        drop_interval = 30 - (level - 1) * 2
        if drop_interval < 5 { drop_interval = 5 }
    }
    
    current_piece = next_piece
    next_piece = rand_int() % len(SHAPES)
    current_rotation = 0
    current_x = GRID_WIDTH / 2 - 1
    current_y = 0
    
    shape2 := get_piece_shape(current_piece, current_rotation)
    if !can_place(shape2, current_x, current_y) {
        game_over = true
    }
}

fn rotate_piece() {
    shape := get_piece_shape(current_piece, (current_rotation + 1) % 4)
    if can_place(shape, current_x, current_y) {
        current_rotation = (current_rotation + 1) % 4
    }
}

fn move_piece(dx, dy) {
    shape := get_piece_shape(current_piece, current_rotation)
    if can_place(shape, current_x + dx, current_y + dy) {
        current_x += dx
        current_y += dy
        return true
    }
    return false
}

fn hard_drop() {
    shape := get_piece_shape(current_piece, current_rotation)
    for can_place(shape, current_x, current_y + 1) {
        current_y++
    }
    lock_piece()
}

fn update() {
    if game_over { return }
    
    if key_left || key_right {
        if move_cooldown == 0 {
            if key_left { move_piece(-1, 0) }
            else if key_right { move_piece(1, 0) }
            
            if !das_active {
                move_cooldown = DAS_DELAY
                das_active = true
            } else {
                move_cooldown = ARR
            }
        } else {
            move_cooldown--
        }
    } else {
        move_cooldown = 0
        das_active = false
    }
    
    if key_rotate {
        rotate_piece()
        key_rotate = false
    }
    
    drop_speed := 1
    if key_down { drop_speed = 4 }
    
    drop_counter += drop_speed
    if drop_counter >= drop_interval {
        drop_counter = 0
        if !move_piece(0, 1) {
            lock_piece()
        }
    }
}

fn draw_block_3d(x, y, color_index, is_ghost) {
    px := float(x) - float(GRID_WIDTH)/2.0 + 0.5
    py := float(GRID_HEIGHT)/2.0 - float(y) - 0.5
    color := COLORS[color_index]
    
    gl.push_matrix()
    gl.translatef(px, py, 0.0)
    
    if is_ghost {
        gl.color4f(color[0], color[1], color[2], 0.4)
        gl.disable(gl.LIGHTING)
        glut.wire_cube(0.95)
        gl.enable(gl.LIGHTING)
    } else {
        // Main block surface
        gl.color3f(color[0], color[1], color[2])
        glut.solid_cube(0.95)
        
        // Block border
        gl.disable(gl.LIGHTING)
        gl.color3f(0.1, 0.1, 0.1)
        glut.wire_cube(0.96)
        gl.enable(gl.LIGHTING)
    }
    
    gl.pop_matrix()
}

fn draw_grid_3d() {
    // Draw the playfield container frame
    gl.disable(gl.LIGHTING)
    gl.color3f(0.3, 0.3, 0.4)
    w := float(GRID_WIDTH) / 2.0
    h := float(GRID_HEIGHT) / 2.0
    
    gl.begin(gl.LINE_LOOP)
    gl.vertex3f(-w, -h, -0.5)
    gl.vertex3f(w, -h, -0.5)
    gl.vertex3f(w, h, -0.5)
    gl.vertex3f(-w, h, -0.5)
    gl.end()
    gl.enable(gl.LIGHTING)
    
    // Draw placed blocks
    y := 0
    for y < GRID_HEIGHT {
        x := 0
        for x < GRID_WIDTH {
            if grid[y][x] != 0 {
                draw_block_3d(x, y, grid[y][x], false)
            }
            x++
        }
        y++
    }
    
    // Draw active piece
    shape := get_piece_shape(current_piece, current_rotation)
    rows := len(shape)
    cols := len(shape[0])
    
    i := 0
    for i < rows {
        j := 0
        for j < cols {
            if shape[i][j] != 0 {
                grid_x := current_x + j
                grid_y := current_y + i
                if grid_y >= 0 {
                    draw_block_3d(grid_x, grid_y, current_piece + 1, false)
                }
            }
            j++
        }
        i++
    }
    
    // Draw ghost piece
    ghost_y := current_y
    shape2 := get_piece_shape(current_piece, current_rotation)
    for can_place(shape2, current_x, ghost_y + 1) {
        ghost_y++
    }
    
    if ghost_y != current_y {
        i := 0
        for i < rows {
            j := 0
            for j < cols {
                if shape2[i][j] != 0 {
                    grid_x := current_x + j
                    grid_y := ghost_y + i
                    if grid_y >= 0 {
                        draw_block_3d(grid_x, grid_y, current_piece + 1, true)
                    }
                }
                j++
            }
            i++
        }
    }
}

fn draw_hud() {
    gl.matrix_mode(gl.PROJECTION)
    gl.push_matrix()
    gl.load_identity()
    gl.ortho(0, float(WINDOW_WIDTH), float(WINDOW_HEIGHT), 0, -1, 1)
    
    gl.matrix_mode(gl.MODELVIEW)
    gl.push_matrix()
    gl.load_identity()
    
    gl.disable(gl.DEPTH_TEST)
    gl.disable(gl.LIGHTING)
    
    gl.color3f(1.0, 1.0, 1.0)
    
    // Side Panel Background - Scaled for 380x450
    gl.color4f(0.1, 0.1, 0.15, 0.8)
    gl.begin(gl.QUADS)
    gl.vertex2f(WINDOW_WIDTH - 120, 0)
    gl.vertex2f(WINDOW_WIDTH, 0)
    gl.vertex2f(WINDOW_WIDTH, WINDOW_HEIGHT)
    gl.vertex2f(WINDOW_WIDTH - 120, WINDOW_HEIGHT)
    gl.end()
    
    // Draw Text & Info
    gl.color3f(1.0, 1.0, 1.0)
    gl.raster_pos2i(WINDOW_WIDTH - 110, 40)
    next_text := "Next:"
    idx := 0
    for idx < len(next_text) { glut.bitmap_character(glut.BITMAP_HELVETICA_18, next_text[idx]); idx++ }
    
    // 2D Next Shape Preview
    next_shape := get_piece_shape(next_piece, 0)
    rows := len(next_shape)
    cols := len(next_shape[0])
    
    i := 0
    for i < rows {
        j := 0
        for j < cols {
            if next_shape[i][j] != 0 {
                px := WINDOW_WIDTH - 110 + float(j * 15)
                py := float(60 + i * 15)
                color := COLORS[next_piece + 1]
                gl.color3f(color[0], color[1], color[2])
                gl.begin(gl.QUADS)
                gl.vertex2f(px, py)
                gl.vertex2f(px + 15, py)
                gl.vertex2f(px + 15, py + 15)
                gl.vertex2f(px, py + 15)
                gl.end()
            }
            j++
        }
        i++
    }
    
    gl.color3f(1.0, 1.0, 1.0)
    gl.raster_pos2i(WINDOW_WIDTH - 110, 150)
    score_text := "Score: " + string(score)
    idx = 0
    for idx < len(score_text) { glut.bitmap_character(glut.BITMAP_HELVETICA_12, score_text[idx]); idx++ }
    
    gl.raster_pos2i(WINDOW_WIDTH - 110, 180)
    level_text := "Level: " + string(level)
    idx = 0
    for idx < len(level_text) { glut.bitmap_character(glut.BITMAP_HELVETICA_12, level_text[idx]); idx++ }
    
    gl.raster_pos2i(WINDOW_WIDTH - 110, 210)
    lines_text := "Lines: " + string(lines_cleared)
    idx = 0
    for idx < len(lines_text) { glut.bitmap_character(glut.BITMAP_HELVETICA_12, lines_text[idx]); idx++ }
    
    if game_over {
        gl.color3f(1.0, 0.2, 0.2)
        gl.raster_pos2i(WINDOW_WIDTH/2 - 120, WINDOW_HEIGHT / 2)
        game_over_text := "GAME OVER! Press R"
        idx = 0
        for idx < len(game_over_text) { glut.bitmap_character(glut.BITMAP_HELVETICA_18, game_over_text[idx]); idx++ }
    }
    
    // Restore states
    gl.enable(gl.DEPTH_TEST)
    gl.enable(gl.LIGHTING)
    
    gl.matrix_mode(gl.PROJECTION)
    gl.pop_matrix()
    gl.matrix_mode(gl.MODELVIEW)
    gl.pop_matrix()
}

fn display() {
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    gl.load_identity()
    
    // Set up 3D Camera Perspective using dynamic Zoom value
    glu.look_at(0.0, -8.0, cam_zoom, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
    
    // Setup light position
    gl.lightfv(gl.LIGHT0, gl.POSITION, 5.0, 15.0, 20.0, 1.0)
    
    // Apply mouse/touch drag rotations
    gl.push_matrix()
    gl.rotatef(cam_rot_x, 1.0, 0.0, 0.0)
    gl.rotatef(cam_rot_y, 0.0, 1.0, 0.0)
    draw_grid_3d()
    gl.pop_matrix()
    
    draw_hud()
    
    glut.swap_buffers()
}

fn reshape(w, h) {
    gl.viewport(0, 0, w, h)
    gl.matrix_mode(gl.PROJECTION)
    gl.load_identity()
    glu.perspective(45.0, float(w)/float(h), 0.1, 100.0)
    gl.matrix_mode(gl.MODELVIEW)
}

fn keyboard(key, x, y) {
    if key == "q" || key == "Q" { os.exit(0) }
    
    // Zoom Controls
    if key == "+" || key == "=" {
        cam_zoom -= 1.0
        return
    }
    if key == "-" || key == "_" {
        cam_zoom += 1.0
        return
    }
    
    if key == "r" || key == "R" {
        i := 0
        for i < GRID_HEIGHT {
            j := 0
            for j < GRID_WIDTH {
                grid[i][j] = 0
                j++
            }
            i++
        }
        score = 0
        level = 1
        lines_cleared = 0
        game_over = false
        cam_zoom = 24.0
        cam_rot_x = 0.0
        cam_rot_y = 0.0
        current_piece = rand_int() % len(SHAPES)
        next_piece = (rand_int() + 1) % len(SHAPES)
        current_rotation = 0
        current_x = GRID_WIDTH / 2 - 1
        current_y = 0
        drop_counter = 0
        drop_interval = 30
        return
    }
    
    if key == " " {
        if !game_over { hard_drop() }
        return
    }
    if key == "w" || key == "W" {
        if !game_over { key_rotate = true }
    }
    if key == "a" || key == "A" { key_left = true }
    if key == "d" || key == "D" { key_right = true }
    if key == "s" || key == "S" { key_down = true }
}

fn keyboard_up(key, x, y) {
    if key == "a" || key == "A" { key_left = false }
    if key == "d" || key == "D" { key_right = false }
    if key == "s" || key == "S" { key_down = false }
}

fn special(key, x, y) {
    if key == glut.KEY_UP {
        if !game_over { key_rotate = true }
    }
    if key == glut.KEY_LEFT { key_left = true }
    if key == glut.KEY_RIGHT { key_right = true }
    if key == glut.KEY_DOWN { key_down = true }
}

fn special_up(key, x, y) {
    if key == glut.KEY_LEFT { key_left = false }
    if key == glut.KEY_RIGHT { key_right = false }
    if key == glut.KEY_DOWN { key_down = false }
}

// Touch / Mouse Callbacks for Orientation
fn mouse(button, state, x, y) {
    if button == glut.LEFT_BUTTON {
        if state == glut.DOWN {
            is_dragging = true
            last_mouse_x = x
            last_mouse_y = y
        } else {
            is_dragging = false
        }
    }
}

fn motion(x, y) {
    if is_dragging {
        dx := x - last_mouse_x
        dy := y - last_mouse_y
        cam_rot_y += float(dx) * 0.5
        cam_rot_x += float(dy) * 0.5
        last_mouse_x = x
        last_mouse_y = y
    }
}

fn timer(val) {
    update()
    glut.post_redisplay()
    glut.timer_func(16, timer, 0)
}

// Main
glut.init()
gl.init()

glut.init_display_mode(glut.RGBA | glut.DOUBLE | glut.DEPTH)
glut.init_window_size(WINDOW_WIDTH, WINDOW_HEIGHT)
glut.init_window_position(100, 100)
glut.create_window("3D Tetris Interactive")

// Enable 3D features
gl.enable(gl.DEPTH_TEST)
gl.enable(gl.LIGHTING)
gl.enable(gl.LIGHT0)
gl.enable(gl.COLOR_MATERIAL)
gl.enable(gl.BLEND)
gl.blend_func(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)

current_piece = rand_int() % len(SHAPES)
next_piece = (rand_int() + 1) % len(SHAPES)

gl.clear_color(0.05, 0.05, 0.08, 1.0)

// Register callbacks
glut.display_func(display)
glut.reshape_func(reshape)
glut.keyboard_func(keyboard)
glut.keyboard_up_func(keyboard_up)
glut.special_func(special)
glut.special_up_func(special_up)
glut.mouse_func(mouse)
glut.motion_func(motion)

// Start game loop
glut.timer_func(16, timer, 0)
glut.main_loop()