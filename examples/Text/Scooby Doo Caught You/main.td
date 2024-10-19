times := import("times")
strings := import("strings")
rand := import("rand")
color := import("colors")

scooby := embed("scooby0.txt")

raw := embed("subtitle.txt")
words := strings.split(raw, " ")


store := ""
should_store := false

_print := fn(txt) {
	for t in txt {
		if t == '~' {
			if should_store {
				should_store = false
				color.print(color[store])
				store = ""
			}
			else {
				should_store = true
			}
		}
		else {
			if should_store {
				store += t
			}
			else {
				print(t)
				times.sleep(50000000 - (rand.float()*10000))
			}
			
		}
		// color.println(store)
	}                                   
}

for word in words {
	l := len(word)
	_print(word + " ")
	times.sleep(((times.second / 10)*l) - 50000000*l)
}


println("\n")
color.println(color.ired + scooby + color.reset)


for {}