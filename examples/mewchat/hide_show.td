import "times"
import "console"
import "ansi"
import "colors"

println("tender: hide / show console test...")
println("")

i := 5
for {
	times.sleep(times.second)
	if i == 0 {
		colors.print(ansi.PREVIOUS_LINE(1))
		println("")
		break
	}
	colors.print(ansi.PREVIOUS_LINE(1))
	println("Hiding in...", i)
	i--
}
console.hide()
times.sleep(times.second*2)
console.show()
i = 5
for {
	times.sleep(times.second)
	if i == 0 {
		break
	}
	colors.print(ansi.PREVIOUS_LINE(1))
	println("Closing in...", i)
	i--
}