import "gui"
 
w := 600
h := 400

win := gui.window("Login Demo", w, h) 
win.set_font(embed("DMMono-Medium.ttf"), 15)

term :=  gui.terminal(10, 10, w-20, h-20)
term.prompt = "$ "
term.line_height = 15

win.add(term)
win.start()
