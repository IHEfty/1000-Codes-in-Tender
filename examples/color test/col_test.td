import "colors"

 for r in range(0,255) {
	for g in range(0,255) {
		for b in range(0,255) {	
			sysout format("\033[%d;%d;%dm$", r, g, b) + colors.reset
		}
	}
 }
 
 for {}