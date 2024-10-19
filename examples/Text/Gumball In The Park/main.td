times := import("times")
strings := import("strings")
rand := import("rand")

raw := embed("dialogue.txt")
words := strings.split(raw, " ")


_print := fn(txt) {
	for t in txt {
		print(t)
		times.sleep(100000000 - (rand.float()*10000))
	}
}

for word in words {
	l := len(word)
	_print(word + " ")
	times.sleep(((times.second / 10)*l) - 100000000*l)
}
