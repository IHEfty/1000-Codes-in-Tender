import "canvas"

w := 300
h := 400
input := ""
result := 0
buttons := [
	"7", "8", "9", "/",
	"4", "5", "6", "*",
	"1", "2", "3", "-",
	"0", ".", "=", "+"
]

fn draw(ctx) {
	ctx.hex(`#ffffff`)
	ctx.clear()

	// Draw the display
	ctx.hex("#000")
	ctx.rect(10, 10, w-20, 60)
	ctx.fill()

	ctx.hex("#fff")
//	ctx.font("30px Arial")
//	ctx.text_align("right")
	ctx.text(input, w-30, 50)

	// Draw buttons
	x_offset := 10
	y_offset := 90
	btn_w := 60
	btn_h := 60
	spacing := 10

	for i, btn in buttons {
		x := x_offset + (i % 4) * (btn_w + spacing)
		y := y_offset + (i / 4) * (btn_h + spacing)

		ctx.hex("#333")
		ctx.rect(x, y, btn_w, btn_h)
		ctx.fill()

		ctx.hex("#fff")
	//	ctx.font("24px Arial")
	//	ctx.text_align("center")
		ctx.text(btn, x + btn_w / 2, y + btn_h / 2 + 10)
	}
}

fn eval(s) {
  return 0
}

fn calculate() {
	result = eval(input)
	input = result
}

fn handle_click(x, y) {
	x_offset := 10
	y_offset := 90
	btn_w := 60
	btn_h := 60
	spacing := 10

	// Check if any button was clicked
	for i, btn in buttons {
		btn_x := x_offset + (i % 4) * (btn_w + spacing)
		btn_y := y_offset + (i / 4) * (btn_h + spacing)

		if x > btn_x && x < btn_x + btn_w && y > btn_y && y < btn_y + btn_h {
			if btn == "=" {
				calculate()
			} else if btn == "C" {
				input = ""
			} else {
				input += btn
			}
			break
		}
	}
}

/*
ctx := canvas.new_context(w, h)
draw(ctx)
ctx.save_png("out.png")

import("os").exit(0)
*/

canvas.new_window(w, h, "Calculator", fn(window) {
	ctx := window.new_context(w, h)
	draw(ctx)
	window.update(w, h)

	for {
		e := window.next_event()

		if e.type == "size" {
			w = e.width_px 
			h = e.height_px
			ctx = window.new_context(e.width_px, e.height_px)
			draw(ctx)
			window.update(w, h)
		}
		else if e.type == "mouse" && e.button == "left" && e.action == "click" {
			handle_click(e.x, e.y)
			draw(ctx)
			window.update(w, h)
		}
		else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
			break
		}
	}
})