import "audio"
import "times"
import "fs"

audio.init()

fn play(src) {
	println(src)
	au := audio.player(fs.readfile(src))
	
	
	
	au.play()
	
	s := int(float(au.decoder.length()) / float(au.decoder.sample_rate()*4))
	for au.is_playing() {
		println(s, "Seconds")
		times.sleep(times.second)
		s--
	}
	
	// println(audio.close())
}
// go(fn(){
	// play("1234.mp3")
// })
play("audio.mp3")