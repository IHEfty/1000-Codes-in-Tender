import "wui"

game_window := wui.new_window()
game_window.set_title("Simple Game")
game_window.set_size(500, 600)

// Game area
game_panel := wui.new_panel()
game_panel.set_bounds(10, 10, 380, 350)

// Score display
score_label := wui.new_label()
score_label.set_text("Score: 0")
score_label.set_bounds(10, 370, 100, 25)

// Level display
level_label := wui.new_label()
level_label.set_text("Level: 1")
level_label.set_bounds(120, 370, 100, 25)

// Progress bar for health
health_label := wui.new_label()
health_label.set_text("Health:")
health_label.set_bounds(10, 400, 60, 25)

health_bar := wui.new_progress_bar()
// health_bar.set_min(0)
// health_bar.set_max(100)
// health_bar.set_value(100)
health_bar.set_bounds(80, 400, 200, 25)

// Control buttons
start_btn := wui.new_button()
start_btn.set_text("Start Game")
start_btn.set_bounds(10, 440, 100, 30)

pause_btn := wui.new_button()
pause_btn.set_text("Pause")
pause_btn.set_bounds(120, 440, 100, 30)

reset_btn := wui.new_button()
reset_btn.set_text("Reset")
reset_btn.set_bounds(230, 440, 100, 30)

// Add all controls
game_window.add(game_panel)
game_window.add(score_label)
game_window.add(level_label)
game_window.add(health_label)
game_window.add(health_bar)
game_window.add(start_btn)
game_window.add(pause_btn)
game_window.add(reset_btn)

// Game logic variables
score := 0
level := 1
health := 100

// Update display function
update_display := fn() {
    score_label.set_text("Score: " + string(score))
    level_label.set_text("Level: " + string(level))
    health_bar.set_value(health)
}

// Button click handlers (simplified - would need event system)
game_window.show()
update_display()