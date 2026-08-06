// tender@v0.0.9
import "graphics"
import "os"

win := graphics.new_window(400, 400, "hello")


var mx, my = 0, 0

win.on_mousemove(fn(x, y){
	mx, my = x, y
})

// debug(win)
win.load_font("IBMPlexSans-Bold.ttf", 24)
win.on_draw(fn(){
	win.hex("#00ff0050")
	win.rgba(1,0,0,0.5)
	win.rect(10,10,100,100)
	win.fill()	
	
	win.rgba(0,1,0,0.5)
	win.rect(50,50,100,100)
	win.fill()
	
	win.set_font_size(25)
	win.hex("#ffffff80")
	win.text(10,100,"hello world     huge space")
	win.fill()	
	
	win.set_font_size(11)
	// win.hex("#ffffff80")
	win.rgba255(mx,my,0,255)
	win.text(mx, my, `X:${mx} Y:${my}`)
	win.fill()
	// win.get_image().save("out.bmp","bmp")
	// os.exit(0)
})

win.on_keyhold(fn(k){
	debug(k)
})


win.run()