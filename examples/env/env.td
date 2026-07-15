import "os"
import "fs"
import "bufio"
import "strings"
import "colors"
import "path"

PATH := os.getenv("path")
PATHS := strings.split(PATH, ";")

all := []

for p in PATHS {
	println()
	if strings.contains(p |> strings.to_upper, "MAHDIN") {
		sysout colors.style(p,{color:"#11ff22"}), "\n"
	}		
	else if strings.contains(p |> strings.to_upper, "PROGRAM FILES") {
		sysout colors.style(p,{color:"#29faff"}), "\n"
	}		
	else if strings.contains(p |> strings.to_upper, "WINDOWS") {
		sysout colors.style(p,{color:"#ff0000"}), "\n"
	}	
	else if strings.has_prefix(p, "C:") {
		sysout colors.style(p,{color:"#ff00ff"}), "\n"
	}	
	else if strings.has_prefix(p, "D:") {
		sysout colors.style(p,{color:"#0000ff"}), "\n"
	}
	dir := fs.readdir(p)
	if is_error(dir) continue
	str := ""
	for f in dir {
		if path.ext(f.name) == ".exe" {
			base := path.base(f.name)
			all.push(base)
			str += base + " "
		}
	}
	println(str)
}


fn query(inp) {
	for a in all {
		if strings.contains(a, inp) {
			str := strings.split(a, inp) 
			sysout strings.join(str, inp.green), "\n"
		} 
	}
	println()
}

for {
	print("Query: ")
	input := bufio.readline() |> strings.trim_space
	query(input)
}