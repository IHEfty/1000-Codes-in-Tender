import "colors"
import "fs"

var bb = [7,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107]
 
 for r in bb {
	for g in bb {
		for b in bb {	
			// stt := format(` \033[%d;%d;%dm$`, r,g,b) + colors.reset
			s := format("\033[%d;%d;%dmHello", r, g, b) + colors.reset
			sysout s
			fs.appendfile("out.txt", s)
		}
	}
 }
 
 for {}
 
 