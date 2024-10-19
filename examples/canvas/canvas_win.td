import "canvas"
import "times"

w := 600
h := 400

fn draw(ctx) {
	ctx.hex(`#232323`)
	ctx.clear()
	ctx.hex("#0f0")
	ctx.rect(100, 100, 100, 100)
	ctx.fill()	
}

var opt = {
	width: 600,
	height: 400,
	title: "Wooh",
	fullscreen: false,
	borderless: false,
	top_most: false,
	no_scaling: false,
	x: 200,
	y: 10
}

canvas.new_window(opt, fn(window){
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
		else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
			break
		}
		// times.sleep(times.second)
	}
})