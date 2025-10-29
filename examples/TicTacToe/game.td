//---------------------------------------
// Tic Tac Toe Game
//---------------------------------------
import "canvas"
import "math"
import "fs"
import "strings"
import "times"
import "os"
import "rand"


// Global window dimensions
w := 400
h := 450
var font_data = embed("IBMPlexSans-Bold.ttf")

// Game state
var game_state = {
    board: ["", "", "", "", "", "", "", "", ""], // 3x3 board
    current_player: "X",
    game_over: false,
    winner: null,
    winning_line: null,
    scores: {X: 0, O: 0, ties: 0},
    difficulty: "easy" // easy, medium, hard
}

fn find_winning_move(player) {
    // Check rows, columns, diagonals for winning move
    var lines = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
        [0, 4, 8], [2, 4, 6]             // diagonals
    ]
    
    for line in lines {
        var values = [game_state.board[line[0]], game_state.board[line[1]], game_state.board[line[2]]]
        var empty_index = null
        var count = 0
        
        for i, val in values {
            if val == player {
                count += 1
            } else if val == "" {
                empty_index = line[i]
            }
        }
        
        if count == 2 && empty_index != null {
            return empty_index
        }
    }
    return null
}


fn find_best_move() {
    // Prefer center, then corners, then edges
    var center = 4
    if game_state.board[center] == "" {
        return center
    }
    
    var corners = [0, 2, 6, 8]
    for corner in corners {
        if game_state.board[corner] == "" {
            return corner
        }
    }
    
    var edges = [1, 3, 5, 7]
    for edge in edges {
        if game_state.board[edge] == "" {
            return edge
        }
    }
    
    return null
}


fn check_game_state() {
    // Check all winning lines
    var lines = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
        [0, 4, 8], [2, 4, 6]             // diagonals
    ]
    
    for line in lines {
        var a = game_state.board[line[0]]
        var b = game_state.board[line[1]]
        var c = game_state.board[line[2]]
        
        if a != "" && a == b && b == c {
            game_state.winner = a
            game_state.winning_line = line
            game_state.game_over = true
            game_state.scores[a] += 1
            return
        }
    }
    
    // Check for tie
    var is_tie = true
    for cell in game_state.board {
        if cell == "" {
            is_tie = false
            break
        }
    }
    
    if is_tie {
        game_state.game_over = true
        game_state.winner = "tie"
        game_state.scores.ties += 1
    }
}

fn reset_game() {
    game_state.board = ["", "", "", "", "", "", "", "", ""]
    game_state.current_player = "X"
    game_state.game_over = false
    game_state.winner = null
    game_state.winning_line = null
}


// AI move function based on difficulty
fn ai_move() {
    if game_state.game_over { return }
    
    available_moves := []
    for i, cell in game_state.board {
        if cell == "" {
            available_moves.push(i)
        }
    }
    
    if available_moves.length == 0 { return }
    
    var move = null
    
    if game_state.difficulty == "easy" {
		// Random move
		move = available_moves[int(rand.float() * available_moves.length)]
    }
    else if game_state.difficulty == "medium" {
		// Sometimes block or win, sometimes random
		if rand.float() < 0.6 {
			move = find_winning_move("O") || find_winning_move("X") || available_moves[int(rand.float() * available_moves.length)]
		} 
		else {
			move = available_moves[int(rand.float() * available_moves.length)]
		}
	}
    if game_state.difficulty == "hard" {
        // Try to win, then block, then use strategy
        move = find_winning_move("O") || find_winning_move("X") || find_best_move()
    }
    
    if move == null {
        move = available_moves[int(rand.float() * available_moves.length)]
    }
    
    game_state.board[move] = "O"
    check_game_state()
    game_state.current_player = "X"
}

fn make_move(index) {
    if game_state.game_over || game_state.board[index] != "" {
        return false
    }
    
    game_state.board[index] = game_state.current_player
    check_game_state()
    
    if !game_state.game_over {
        game_state.current_player = "O"
        // AI move after a short delay
        times.sleep(300)
		ai_move()
    }
    
    return true
}

// Drawing functions
fn draw_board(ctx) {
    var board_size = 200
    var cell_size = board_size / 3
    var start_x = (w - board_size) / 2
    var start_y = 100
    
    // Draw grid
    ctx.hex("#34495e")
    ctx.linewidth(3)
    
    // Vertical lines
    for i := 1; i <= 2; i++ {
        ctx.move_to(start_x + i * cell_size, start_y)
        ctx.line_to(start_x + i * cell_size, start_y + board_size)
    }
    
    // Horizontal lines
    for i := 1; i <= 2; i++ {
        ctx.move_to(start_x, start_y + i * cell_size)
        ctx.line_to(start_x + board_size, start_y + i * cell_size)
    }
    
    ctx.stroke()
    
    // Draw X's and O's
    for i := 0; i < 9; i++ {
        var row = math.floor(i / 3)
        var col = i % 3
        var x = start_x + col * cell_size + cell_size / 2
        var y = start_y + row * cell_size + cell_size / 2
        
        if game_state.board[i] == "X" {
            ctx.hex("#e74c3c")
            ctx.linewidth(4)
            var offset = cell_size * 0.3
            ctx.move_to(x - offset, y - offset)
            ctx.line_to(x + offset, y + offset)
            ctx.move_to(x + offset, y - offset)
            ctx.line_to(x - offset, y + offset)
            ctx.stroke()
        } else if game_state.board[i] == "O" {
            ctx.hex("#3498db")
            ctx.linewidth(4)
            ctx.circle(x, y, cell_size * 0.3)
            ctx.stroke()
        }
    }
    
    // Highlight winning line
    if game_state.winning_line != null {
        ctx.hex("#f1c40f")
        ctx.linewidth(6)
        
        var line = game_state.winning_line
        var start_cell = line[0]
        var end_cell = line[2]
        
        var start_row = math.floor(start_cell / 3)
        var start_col = start_cell % 3
        var end_row = math.floor(end_cell / 3)
        var end_col = end_cell % 3
        
        var start_x_line = start_x + start_col * cell_size + cell_size / 2
        var start_y_line = start_y + start_row * cell_size + cell_size / 2
        var end_x_line = start_x + end_col * cell_size + cell_size / 2
        var end_y_line = start_y + end_row * cell_size + cell_size / 2
        
        ctx.move_to(start_x_line, start_y_line)
        ctx.line_to(end_x_line, end_y_line)
        ctx.stroke()
    }
}

fn draw_ui(ctx) {
    // Draw title
    ctx.hex("#ffffff")
    ctx.text("Tic Tac Toe", 30, 40)
    
    // Draw current player indicator
    if !game_state.game_over {
        ctx.hex(game_state.current_player == "X" ? "#e74c3c" : "#3498db")
        ctx.text("Current Player: " + game_state.current_player, 30, 70)
    }
    
    // Draw game status
    if game_state.game_over {
        if game_state.winner == "tie" {
            ctx.hex("#f39c12")
            ctx.text("Game Over - It's a Tie!", 30, 70)
        } else {
            ctx.hex(game_state.winner == "X" ? "#e74c3c" : "#3498db")
            ctx.text("Game Over - " + game_state.winner + " Wins!", w/2, 70)
        }
    }
    
    // Draw scores
    ctx.hex("#bdc3c7")
    ctx.text(format("X: %d  O: %d  Ties: %d", game_state.scores.X, game_state.scores.O, game_state.scores.ties), w/2, 320)
    
    // Draw difficulty buttons
    var difficulties = ["easy", "medium", "hard"]
    var button_width = 80
    var button_height = 30
    var start_x = (w - (button_width * 3 + 20)) / 2
    
    for i, diff in difficulties {
        var x = start_x + i * (button_width + 10)
        var y = 350
        
        if game_state.difficulty == diff {
            ctx.hex("#2ecc71")
        } else {
            ctx.hex("#7f8c8d")
        }
        
        ctx.rect(x, y, button_width, button_height)
        ctx.fill()
        
        ctx.hex("#ffffff")
        ctx.text(strings.to_upper(diff), x + 15, y + button_height/2 + 5)
    }
    
    // Draw reset button
    var reset_x = w/2 - 40
    var reset_y = 390
    ctx.hex("#e74c3c")
    ctx.rect(reset_x, reset_y, 80, 30)
    ctx.fill()
    
    ctx.hex("#ffffff")
    ctx.text("New Game", reset_x + 6, reset_y + 20)
}

fn draw_game(ctx) {
    // Clear with dark background
    ctx.hex("#2c3e50")
    ctx.clear()
	ctx.fontface(font_data, 13)
    
    draw_board(ctx)
    draw_ui(ctx)
}

fn get_cell_from_coords(x, y) {
    var board_size = 200
    var cell_size = board_size / 3
    var start_x = (w - board_size) / 2
    var start_y = 100
    
    if x < start_x || x > start_x + board_size || y < start_y || y > start_y + board_size {
        return null
    }
    
    var col = math.floor((x - start_x) / cell_size)
    var row = math.floor((y - start_y) / cell_size)
    
    return int(row * 3 + col)
}

fn handle_click(x, y) {
    // Check difficulty buttons
    var difficulties = ["easy", "medium", "hard"]
    var button_width = 80
    var button_height = 30
    var start_x = (w - (button_width * 3 + 20)) / 2
    
    for i, diff in difficulties {
        var btn_x = start_x + i * (button_width + 10)
        var btn_y = 350
        
        if x >= btn_x && x <= btn_x + button_width && y >= btn_y && y <= btn_y + button_height {
            game_state.difficulty = diff
            reset_game()
            return
        }
    }
    
    // Check reset button
    var reset_x = w/2 - 40
    var reset_y = 390
    if x >= reset_x && x <= reset_x + 80 && y >= reset_y && y <= reset_y + 30 {
        reset_game()
        return
    }
    
    // Check board cells
    if game_state.current_player == "X" && !game_state.game_over {
        var cell_index = get_cell_from_coords(x, y)
        if cell_index != null {
            make_move(cell_index)
        }
    }
}

// Main application
canvas.new_window(w, h, "Tic Tac Toe", fn(window) {
    ctx := window.new_context(w, h)
    
    draw_game(ctx)
    window.update(w, h)
    
    // Event loop
    for {
        e := window.next_event()
        if e.type == "size" {
            w = e.width_px
            h = e.height_px
            ctx = window.new_context(w, h)
            draw_game(ctx)
            window.update(w, h)
        } else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
            break
        } else if e.type == "mouse" && e.direction == 1 {
            handle_click(e.x, e.y)
            draw_game(ctx)
            window.update(w, h)
        }
    }
})
