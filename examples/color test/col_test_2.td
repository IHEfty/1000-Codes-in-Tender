import "colors"
import "helper/randstr"

 for r in range(0,255) {
	for g in range(0,255) {
		for b in range(0,255) {	
			sysout format("\033[%d;%d;%dm"+randstr(1), r, g, b) + colors.reset
			if b%8==0 {
				print(" ")
			}
			if b%16==0 {
				println()
			}	
		}
	}
 }
 
 for {}