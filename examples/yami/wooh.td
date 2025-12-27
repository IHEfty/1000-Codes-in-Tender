import "audio"
import "console"

console.hide()

// Initialize the audio context
audio.init()

// Embed the audio data
var mp3_data = embed("wooh.mp3")

// Create an audio player
var player = audio.player(mp3_data)

// Play the audio
player.play()

for player.is_playing() {}

println("Played!")