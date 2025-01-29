import "canvas"
import "image"
import "filters/blackandwhite"
import "filters/grayscale"
import "filters/noise"
import "filters/threshold"
import "filters/brightness"
import "filters/invert"
import "filters/sepia"
import "filters/glitch"
import "filters/blur"

w := 600
h := 400

img := image.load("image.jpg")

var bounds = []

fn draw(ctx) {
	bounds = []
    ctx.hex(`#121212`)
    ctx.clear()
    ctx.hex("#0f0")
    ctx.dash(4)
    
    // Adjust the rect and image positioning dynamically based on updated window dimensions
    rect_x := (w - 100) / 2
    rect_y := (h - 100) / 2
    im_w := img.bounds().size.width
    im_h := img.bounds().size.height
	
    // ctx.rect(rect_x, rect_y, 100, 100)
    // ctx.drawimage(embed("x"), rect_x, rect_y)
	ctx.drawimage(img.encode("png"), (w - im_w)/2, (h - im_h)/2)
    ctx.stroke()    
	
	scale:=30;
	labels := [
		"BNW",
		"Grayscale",
		"Noise",
		"Threshold",
		"Brightness",
		"Invert",
		"Sepia",
		"Glitch",
		"Blur"
	]
	for i := 0; i < labels.length; i++ {
		x := scale
		y := (i+1)*scale
		ctx.linewidth(1)
		kl := ctx.measure_text(labels[i])
		ctx.hex("fff")
		ctx.rect(x, y, scale*3, scale)
		ctx.stroke()	
		ctx.text(labels[i], x - (kl[0]/2) + scale*1.5, y + (kl[1]/2)  + scale/2)
		ctx.fill()	
		bounds.push([x, y, scale*3, scale, i])
	}
}

canvas.new_window(w, h, "Hello Tender", fn(window){
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
		else if e.type == "key" && e.direction == 1 {
			if e.code == 79 {
				noise(img)
				draw(ctx)
				window.update(w, h)
			} 
			else if e.code == 80 {
				sepia(img)
				draw(ctx)
				window.update(w, h)
			}
		}
        else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
            break
        }
		else if e.type == "mouse" && e.direction == 1 {
			for b_index, b in bounds {
				ax := b[0]
				ay := b[1]
				aw := b[2]
				ah := b[3]
				if ax < e.x && ay < e.y && ax + aw > e.x && ay + ah > e.y {
					var id = b[4]
					if id >= 0 && id <= 10 {
						ctx.hex("#00ff0025")
						ctx.rect(b[0], b[1], b[2], b[3])
						ctx.fill()
						window.update(w, h)
					}
					if id == 0 {
						blackandwhite(img)
						draw(ctx)
						window.update(w, h)
					}
					else if id == 1 {
						grayscale(img)
						draw(ctx)
						window.update(w, h)
					}
					else if id == 2 {
						noise(img)
						draw(ctx)
						window.update(w, h)
					}
					else if id == 3 {
						threshold(img, 50)
						draw(ctx)
						window.update(w, h)
					}	
					else if id == 4 {
						brightness(img, 10)
						draw(ctx)
						window.update(w, h)
					}
					else if id == 5 {
						invert(img)
						draw(ctx)
						window.update(w, h)
					}	
					else if id == 6 {
						sepia(img)
						draw(ctx)
						window.update(w, h)
					}	
					else if id == 7 {
						glitch(img)
						draw(ctx)
						window.update(w, h)
					}	
					else if id == 8 {
						blur(img)
						draw(ctx)
						window.update(w, h)
					}
				}
			}
		}
    }
})
