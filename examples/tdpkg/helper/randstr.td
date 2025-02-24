import "math"
import "rand"

export fn(length) {
    result := ""
	characters := "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"
    characters_length := len(characters)
	for i := 0; i < length; i++ {
		result += characters[int((math.floor(rand.float() * characters_length)))]
	}
	return result
}