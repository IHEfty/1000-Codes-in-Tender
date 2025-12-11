import "colors"

cout := colors.stdout()
cout.write("\x1b[0;32mhello world\x1b[0m\n")

cerr := colors.stderr()
cerr.write("\x1b[0;31mtender script\x1b[0m\n")