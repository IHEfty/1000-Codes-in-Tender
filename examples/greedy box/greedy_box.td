import "canvas"
import "rand"
import "math"
import "times"

fn random(min, max) {
	return int(math.floor(rand.float() * (max - min + 1)) + min)
}

w := 600
h := 400
grid_size := 20
greedy_box := [{x: 10, y: 10}]
dir := {x: 0, y: 0}
food := {x: random(0, w/grid_size-1), y: random(0, h/grid_size-1)}
greedy_box_length := 1
game_over := false

fn draw(ctx) {
	ctx.hex(`#121212`)
	ctx.clear()

	// debug(greedy_box)
	// Draw Greedy Box
	for part in greedy_box {
		ctx.hex("#0f0")
		ctx.rect(part.x * grid_size, part.y * grid_size, grid_size, grid_size)
		ctx.fill()
	}

	// Draw Food
	ctx.hex("#f00")
	ctx.rect(food.x * grid_size, food.y * grid_size, grid_size, grid_size)
	ctx.fill()

	// Draw border
	ctx.hex("#fff")
	ctx.rect(0, 0, w, h)
	ctx.stroke()
}

fn update_greedy_box() {
	// if game_over {
		// return
	// }
	
	// debug(1)
	
	// Move the greedy_box head
	head := {x: greedy_box[0].x + dir.x, y: greedy_box[0].y + dir.y}
	
	// Check for wall collisions
	if head.x < 0 || head.y < 0 || head.x >= w/grid_size || head.y >= h/grid_size {
		game_over = true
		return
	}

	// Check if the greedy_box bites itself
	for part in greedy_box {
		if head.x == part.x && head.y == part.y {
			game_over = true
			return
		}
	}

	// Add new head to the front
	greedy_box[greedy_box.length-1] = head

	// println(food)
	// Check for food collision
	if head.x == food.x && head.y == food.y {
		// println(1000
		// greedy_box.push(head)
		food = {x: random(0, w/grid_size-1), y: random(0, h/grid_size-1)}
	}
		// greedy_box_length++
		// // food = {x: random(0, w/grid_size-1), y: random(0, h/grid_size-1)}
	// } else {
		// if greedy_box.len > greedy_box_length {
			// // greedy_box.remove_last()
		// }
	// }
}

/*
ctx := canvas.new_context(w, h)
draw(ctx)
ctx.save_png("out.png")
import("os").exit(0)
*/

canvas.new_window(w, h, "Greedy Box", fn(window) {
	ctx := window.new_context(w, h)
	draw(ctx)
	window.update(w, h)
	
	go(fn(){
		for {
			update_greedy_box()
			draw(ctx)
			window.update(w, h)
			times.sleep(times.second/10)
		}
	})

	for {
		e := window.next_event()
		// debug(e)

		if e.type == "size" {
			w = e.width_px 
			h = e.height_px
			ctx = window.new_context(e.width_px, e.height_px)
			draw(ctx)
			window.update(w, h)
		}
		else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
			break
		}
		// println(e.code)

		// Control greedy_box direction
		if e.type == "key";  e.direction == 1 {
			if e.code == 82 {
				dir = {x: 0, y: -1}
			}
			else if e.code == 81 {
				dir = {x: 0, y: 1}
			}
			else if e.code == 79 {
				dir = {x: 1, y: 0}
			}
			else if e.code == 80 {
				dir = {x: -1, y: 0}
			}
		}
	}
})