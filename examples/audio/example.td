import "audio"

// Initialize the audio context
audio.init()

// Embed the audio data
var mp3_data = embed("myaudio.mp3")

// Create an audio player
var player = audio.player(mp3_data)

// Play the audio
player.play()

for player.is_playing() {}

println("Played!")