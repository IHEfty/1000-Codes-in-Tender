import "canvas"

ctx := canvas.new_context(200, 200)

ctx.hex(`#121212`)
ctx.clear()
ctx.hex("#0f0")
ctx.dash(4)
ctx.rect(50, 50, 100, 100)
ctx.stroke()	

ctx.save_png("output.png")