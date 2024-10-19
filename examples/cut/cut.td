image := import("image")
canvas := import("canvas")

W := 400
H := 500
im := image.load("gopher.png")

iw := im.bounds().size.width
ih := im.bounds().size.height


dc := canvas.new_context(W, H)
// draw outline
dc.hex("#ff0000")
dc.linewidth(1)
dc.rect(0, 0, W, H)
dc.stroke()
// draw full image
dc.hex("#0000ff")
dc.linewidth(2)
dc.rect(100, 210, iw, ih)
dc.stroke()
dc.drawimage(im.encode("png"), 100, 210)
// draw image with current matrix applied
dc.hex("#0000ff")
dc.linewidth(2)
dc.rotate(canvas.radians(10))
dc.rect(100, 0, iw, ih/2+20.0)
dc.stroke_preserve()
dc.clip()
dc.drawimage(im.encode("png"), 100, 0)
// dc.drawImageAnchored(im, 100, 0, 0.0, 0.0)
dc.save_png("out.png")