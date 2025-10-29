//---------------------------------------
// Blackjack Game
//---------------------------------------
import "canvas"
import "math"
import "fs"
import "strings"
import "times"
import "os"
import "rand"

// Global window dimensions - increased height to fit all elements
w := 600
h := 650  // Increased from 400 to fit cards and buttons
var font_data = embed("IBMPlexSans-Bold.ttf")

// Card deck and game state
var game_state = {
    deck: [],
    player_hand: [],
    dealer_hand: [],
    player_score: 0,
    dealer_score: 0,
    game_over: false,
    message: "",
    player_money: 1000,
    current_bet: 0,
    betting_phase: true,
    scores: {wins: 0, losses: 0, pushes: 0}
}

// Card suits and values
var suits = ["hearts", "diamonds", "clubs", "spades"]
var values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

fn create_deck() {
    var new_deck = []
    for suit in suits {
        for value in values {
            new_deck.push({suit: suit, value: value})
        }
    }
    return new_deck
}

fn shuffle_deck(deck) {
    for i := deck.length - 1; i > 0; i-- {
        j := int(rand.float() * (i + 1))
        temp := deck[i]
        deck[i] = deck[j]
        deck[j] = temp
    }
    return deck
}

fn calculate_hand_value(hand) {
    var total = 0
    var aces = 0
    
    for card in hand {
        if card.value == "A" {
            aces += 1
            total += 11
        } else if card.value == "J" || card.value == "Q" || card.value == "K" {
            total += 10
        } else {
            total += int(card.value)
        }
    }
    
    // Adjust for aces
    for i := 0; i < aces; i++ {
        if total > 21 {
            total -= 10
        }
    }
    
    return total
}

fn deal_initial_cards() {
    game_state.player_hand = []
    game_state.dealer_hand = []
    
    // Deal two cards to player and dealer
    for i := 0; i < 2; i++ {
        // game_state.player_hand.push(game_state.deck.pop())
        // game_state.dealer_hand.push(game_state.deck.pop())
        game_state.player_hand.push(game_state.deck[len(game_state.deck)-1])
		game_state.deck = game_state.deck[:len(game_state.deck)-1]
        game_state.dealer_hand.push(game_state.deck[len(game_state.deck)-1])
		game_state.deck = game_state.deck[:len(game_state.deck)-1]
    }
    
    game_state.player_score = calculate_hand_value(game_state.player_hand)
    game_state.dealer_score = calculate_hand_value(game_state.dealer_hand)
    
    // Check for blackjack
    if game_state.player_score == 21 {
        game_state.game_over = true
        if game_state.dealer_score == 21 {
            game_state.message = "Both have Blackjack! Push!"
            game_state.player_money += game_state.current_bet
            game_state.scores.pushes += 1
        } else {
            game_state.message = "Blackjack! You win 3:2!"
            game_state.player_money += game_state.current_bet * 2.5
            game_state.scores.wins += 1
        }
    }
}

fn player_hit() {
    if game_state.game_over || game_state.betting_phase { return }
    
    // game_state.player_hand.push(game_state.deck.pop())
	game_state.player_hand.push(game_state.deck[len(game_state.deck)-1])
	game_state.deck = game_state.deck[:len(game_state.deck)-1]
	
    game_state.player_score = calculate_hand_value(game_state.player_hand)
    
    if game_state.player_score > 21 {
        game_state.game_over = true
        game_state.message = "Bust! You lose."
        game_state.scores.losses += 1
    }
}

fn player_stand() {
    if game_state.game_over || game_state.betting_phase { return }
    
    game_state.game_over = true
    
    // Dealer draws until 17 or higher
    for game_state.dealer_score < 17 {
        // game_state.dealer_hand.push(game_state.deck.pop())
        game_state.dealer_hand.push(game_state.deck[len(game_state.deck)-1])
		game_state.deck = game_state.deck[:len(game_state.deck)-1]
		
        game_state.dealer_score = calculate_hand_value(game_state.dealer_hand)
    }
    
    // Determine winner
    if game_state.dealer_score > 21 {
        game_state.message = "Dealer busts! You win!"
        game_state.player_money += game_state.current_bet * 2
        game_state.scores.wins += 1
    } else if game_state.dealer_score > game_state.player_score {
        game_state.message = "Dealer wins!"
        game_state.scores.losses += 1
    } else if game_state.player_score > game_state.dealer_score {
        game_state.message = "You win!"
        game_state.player_money += game_state.current_bet * 2
        game_state.scores.wins += 1
    } else {
        game_state.message = "Push! It's a tie."
        game_state.player_money += game_state.current_bet
        game_state.scores.pushes += 1
    }
}

fn start_new_round() {
    if game_state.player_money <= 0 {
        game_state.message = "Game Over! No money left."
        return
    }
    
    if game_state.deck.length < 20 {
        game_state.deck = create_deck()
        shuffle_deck(game_state.deck)
    }
    
    game_state.betting_phase = true
    game_state.game_over = false
    game_state.message = "Place your bet!"
    game_state.current_bet = 0
}

fn place_bet(amount) {
    if !game_state.betting_phase { return }
    
    if game_state.player_money >= amount {
        game_state.current_bet = amount
        game_state.betting_phase = false
        game_state.player_money -= amount
        deal_initial_cards()
    }
}

// Drawing functions
fn draw_card(ctx, x, y, card, hidden) {
    // Card background
    ctx.hex("#ffffff")
    ctx.rounderect(x, y, 80, 120, 10)
    ctx.fill()
    
    // ctx.hex("#000000")
    // ctx.rect(x, y, 80, 120)
    // ctx.stroke()
    
    if hidden {
        // Draw card back
        ctx.hex("#8B0000")
        ctx.rounderect(x + 5, y + 5, 70, 110, 10)
        ctx.fill()
      
        return
    }
    
    // Set color based on suit
    if card.suit == "hearts" || card.suit == "diamonds" {
        ctx.hex("#FF0000")
    } else {
        ctx.hex("#000000")
    }
    
    // Draw card value and suit
    var suit_symbol = ""
    // if card.suit == "hearts" { suit_symbol = "♥" }
    // else if card.suit == "diamonds" { suit_symbol = "♦" }
    // else if card.suit == "clubs" { suit_symbol = "♣" }
    // else if card.suit == "spades" { suit_symbol = "♠" }
    if card.suit == "hearts" { suit_symbol = "H" }
    else if card.suit == "diamonds" { suit_symbol = "D" }
    else if card.suit == "clubs" { suit_symbol = "C" }
    else if card.suit == "spades" { suit_symbol = "S" }
    
    // Top left corner
    ctx.text(card.value, x + 8, y + 20)
    ctx.text(suit_symbol, x + 8, y + 35)
    
    // Center (larger)
    ctx.text(suit_symbol, x + 40, y + 70)
    
    // Bottom right (rotated)
    ctx.text(card.value, x + 60, y + 100)
    ctx.text(suit_symbol, x + 60, y + 115)
}

fn draw_ui(ctx) {
    // Draw title
    ctx.hex("#ffffff")
    ctx.text("Blackjack", 30, 40)
    
    // Draw money and bet info
    ctx.hex("#bdc3c7")
    ctx.text(format("Money: $%d", game_state.player_money), 30, 70)
    ctx.text(format("Current Bet: $%d", game_state.current_bet), 30, 90)
    
    // Draw scores
    ctx.text(format("Wins: %d  Losses: %d  Pushes: %d", 
                   game_state.scores.wins, game_state.scores.losses, game_state.scores.pushes), 
             30, 110)
    
    // Draw game message
    ctx.hex("#f39c12")
    ctx.text(game_state.message, w/2, 130)
    
    // Draw scores - MOVED TO BETTER POSITIONS
    if !game_state.betting_phase {
        ctx.hex("#ffffff")
        ctx.text(format("Your Score: %d", game_state.player_score), w-130, 70)
        if game_state.game_over {
            ctx.text(format("Dealer Score: %d", game_state.dealer_score), w-130, 90)
        } else {
            ctx.text("Dealer Score: ?", 30, w-130)
        }
    }
    
    // Draw betting buttons - MOVED TO VISIBLE AREA
    if game_state.betting_phase {
        var bet_amounts = [10, 25, 50, 100]
        var button_width = 70
        var start_x = (w - (button_width * 4 + 30)) / 2
        
        for i, amount in bet_amounts {
            var x = start_x + i * (button_width + 10)
            var y = 450  // Changed from 550 to 450
            
            if game_state.player_money >= amount {
                ctx.hex("#2ecc71")
            } else {
                ctx.hex("#7f8c8d")
            }
            
            ctx.rect(x, y, button_width, 40)
            ctx.fill()
            
            ctx.hex("#ffffff")
            // FIXED: Use string() instead of str()
            ctx.text("$" + string(amount), x + 15, y + 25)
        }
    } else {
        // Draw game action buttons - MOVED TO VISIBLE AREA
        var buttons = [
            {text: "Hit", x: w/2 - 90, y: 450, width: 80, height: 40},  // Changed from 550 to 450
            {text: "Stand", x: w/2, y: 450, width: 80, height: 40}      // Changed from 550 to 450
        ]
        
        for btn in buttons {
            if !game_state.game_over {
                ctx.hex("#3498db")
            } else {
                ctx.hex("#7f8c8d")
            }
            
            ctx.rect(btn.x, btn.y, btn.width, btn.height)
            ctx.fill()
            
            ctx.hex("#ffffff")
            ctx.text(btn.text, btn.x + 20, btn.y + 25)
        }
    }
    
    // Draw new game/reset button - MOVED TO VISIBLE AREA
    var reset_x = w/2 - 40
    var reset_y = 500  // Changed from 600 to 500
    ctx.hex("#e74c3c")
    ctx.rect(reset_x, reset_y, 80, 40)
    ctx.fill()
    
    ctx.hex("#ffffff")
    ctx.text("New Round", reset_x + 8, reset_y + 25)
}

fn draw_game(ctx) {
    // Clear with dark background
    ctx.hex("#2c3e50")
    ctx.clear()
    ctx.fontface(font_data, 12)
    
    // Draw dealer's hand - ADJUSTED POSITIONS
    ctx.hex("#ffffff")
    ctx.text("Dealer's Hand:", 30, 160)
    for i, card in game_state.dealer_hand {
        var x = 30 + i * 90
        var hidden = (i == 1 && !game_state.game_over && !game_state.betting_phase)
        draw_card(ctx, x, 180, card, hidden)
    }
    
    // Draw player's hand - ADJUSTED POSITIONS
    ctx.hex("#ffffff")
    ctx.text("Your Hand:", 30, 320)  // Changed from 340 to 320
    for i, card in game_state.player_hand {
        var x = 30 + i * 90
        draw_card(ctx, x, 340, card, false)  // Changed from 360 to 340
    }
    
    draw_ui(ctx)
}

fn handle_click(x, y) {
    if game_state.betting_phase {
        // Betting buttons - UPDATED COORDINATES
        var bet_amounts = [10, 25, 50, 100]
        var button_width = 70
        var start_x = (w - (button_width * 4 + 30)) / 2
        
        for i, amount in bet_amounts {
            var btn_x = start_x + i * (button_width + 10)
            var btn_y = 450  // Changed from 550 to 450
            
            if x >= btn_x && x <= btn_x + button_width && 
               y >= btn_y && y <= btn_y + 40 &&
               game_state.player_money >= amount {
                place_bet(amount)
                return
            }
        }
    } else {
        // Game action buttons - UPDATED COORDINATES
        if !game_state.game_over {
            // Hit button
            if x >= w/2 - 90 && x <= w/2 - 10 && y >= 450 && y <= 490 {  // Changed from 550-590 to 450-490
                player_hit()
                return
            }
            
            // Stand button
            if x >= w/2 && x <= w/2 + 80 && y >= 450 && y <= 490 {  // Changed from 550-590 to 450-490
                player_stand()
                return
            }
        }
    }
    
    // New round button - UPDATED COORDINATES
    var reset_x = w/2 - 40
    var reset_y = 500  // Changed from 600 to 500
    if x >= reset_x && x <= reset_x + 80 && y >= reset_y && y <= reset_y + 40 {
        start_new_round()
        return
    }
}

// Initialize game
fn init_game() {
    game_state.deck = create_deck()
    shuffle_deck(game_state.deck)
    game_state.betting_phase = true
    game_state.message = "Place your bet!"
}

// Main application
canvas.new_window(w, h, "Blackjack", fn(window) {
    ctx := window.new_context(w, h)
    
    init_game()
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
