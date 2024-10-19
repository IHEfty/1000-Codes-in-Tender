import "colors"

if colors.on_green != null {
    sysout colors.on_green + "Hello, World!" + colors.reset + "\n"
} else {
    sysout "Hello, World!\n"
}
