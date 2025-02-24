import "rand"
import "math"

export fn(min, max) {
	return int(math.floor(rand.float() * (max - min + 1)) + min)
}