import "fmt"
import "colors"
import "os"

fmt.fprint(colors.stdout(), "Hello".red, "World".green, "\n")

fmt.fprintln(colors.stderr(), "Hello".red, "World".green)

fmt.fprintln(os.stdout(), "Hello".red, "World".green, "\n")