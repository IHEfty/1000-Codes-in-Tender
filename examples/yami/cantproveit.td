import "canvas"
import "image"
import "console"

console.hide()

img_data := embed("cantproveit")
img := image.decode(img_data)
b := img.bounds()

w := b.size.width
h := b.size.height

fn draw(ctx) {
	ctx.drawimage(img_data, 0, 0)
	ctx.hex("#fff")
	ctx.text("You know it, but you can't prove it", 50, 300)
}

o := {
    width: w,
    height: h,
    title: "You can't prove it",
    fullscreen: false,
    borderless: false,
    top_most: false,
    no_scaling: false,
    x: 330,
    y: 50
}

canvas.new_window(o, fn(window){
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
	}
})