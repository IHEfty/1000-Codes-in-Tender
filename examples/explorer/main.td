import "canvas"
import "fs"
import "image"
import "path"

w := 600
h := 400
scroll_offset := 0 // Track vertical scroll position
line_height := 24  // Height of each line for drawing text

img_fi := image.load("res/file.svg.png")
img_fo := image.load("res/folder.svg.png")

dir := "."

files := fs.readdir(dir)  // Read files once at start
fontdata := embed("res/SourceCodePro-Medium.ttf")

var bounds = []

fn draw(ctx, files) {
	bounds = []
	ctx.fontface(fontdata, 15)
	ctx.hex(`#121212`)
	ctx.clear()

	// Draw the text with respect to the scroll offset
	visible_lines := h / line_height

	for i, file in files {
		y := i * line_height - scroll_offset
		if y >= 0 && y < h {
			mt := ctx.measure_text(file.name)
			Y := y + ctx.fontheight() + mt[1]/2 + 12
			X := 44
			if file.is_dir {
				ctx.hex("#0f0")
				ctx.drawimage(img_fo.encode("png"), 10, y + ctx.fontheight())
				ctx.text(file.name, X, Y)
				ctx.fill()
				ctx.fill()
				bounds.push([X, Y-10, mt[0], mt[1], file.name])
			} 
			else {
				ctx.hex("#0a0")
				ctx.drawimage(img_fi.encode("png"), 10, y + ctx.fontheight())
				ctx.text(file.name, X, Y)
				ctx.fill()
			}
		}
	}

	// Draw scrollbar
	scrollbar_height := (float(visible_lines) / len(files)) * h
	scrollbar_y := (float(scroll_offset) / (len(files) * line_height)) * h
	ctx.hex("#0b0")
	ctx.rect(w - 10, scrollbar_y, 10, scrollbar_height) // Scrollbar width = 8
	ctx.fill()
}

canvas.new_window(w, h, "File Viewer", fn(window) {
	ctx := window.new_context(w, h)

	draw(ctx, files)
	window.update(w, h)

	for {
		e := window.next_event()
		
		if e.type == "size" {
			// Update window size and re-draw
			w = e.width_px 
			h = e.height_px
			ctx = window.new_context(w, h)
			draw(ctx, files)
			window.update(w, h)

		} 
		else if e.type == "mouse" && e.direction == 1 {
			for b_index, b in bounds {
				ax := b[0]
				ay := b[1]
				aw := b[2]
				ah := b[3]
				if ax < e.x && ay < e.y && ax + aw > e.x && ay + ah > e.y {
					dir = path.join(dir, b[4])
					files = fs.readdir(dir)
					scroll_offset = 0
					draw(ctx, files)
					window.update(w, h)
				}
			}
		}
		else if e.type == "key"; e.direction == 1 {
			// Scroll based on mouse wheel events
			if e.code == 81 {
				scroll_offset += line_height
			}
			else if e.code == 82 {
				scroll_offset -= line_height
			}	
			else if e.code == 42 {
				scroll_offset = 0
				dir = path.join(dir, "..")
				files = fs.readdir(dir)
			}
			draw(ctx, files)
			window.update(w, h)

		} 
		else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
			break
		}
	}
})
