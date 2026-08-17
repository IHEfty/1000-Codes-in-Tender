import "os"
import "fs"
import "bufio"
import "strings"
import "console"
import "path"

PATH := os.getenv("path")
PATHS := strings.split(PATH, ";")

all := []

for p in PATHS {
	println()
	if strings.contains(p |> strings.to_upper, "WOOH") {
		sysout console.style(p,{color:"#11ff22"}), "\n"
	}		
	else if strings.contains(p |> strings.to_upper, "PROGRAM FILES") {
		sysout console.style(p,{color:"#29faff"}), "\n"
	}		
	else if strings.contains(p |> strings.to_upper, "WINDOWS") {
		sysout console.style(p,{color:"#ff0000"}), "\n"
	}	
	else if strings.has_prefix(p, "C:") {
		sysout console.style(p,{color:"#ff00ff"}), "\n"
	}	
	else if strings.has_prefix(p, "D:") {
		sysout console.style(p,{color:"#0000ff"}), "\n"
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


fn get_rnd_col(inp) {
	import "helper/randint"
	return console.style(inp, {
		color: [
		  "#ff0000", "#00ff00", "#0000ff", "#ffff00", "#00ffff", "#ff00ff",
		  "#ff6600", "#66ff00", "#00ff66", "#0066ff", "#6600ff", "#ff0066",
		  "#ff3300", "#33ff00", "#00ff33", "#0033ff", "#3300ff", "#ff0033",
		  "#ff9900", "#99ff00", "#00ff99", "#0099ff", "#9900ff", "#ff0099",
		  "#ffcc00", "#ccff00", "#00ffcc", "#00ccff", "#cc00ff", "#ff00cc",
		  "#ff5500", "#55ff00", "#00ff55", "#0055ff", "#5500ff", "#ff0055",
		  "#ff8800", "#88ff00", "#00ff88", "#0088ff", "#8800ff", "#ff0088",
		  "#ffaa00", "#aaff00", "#00ffaa", "#00aaff", "#aa00ff", "#ff00aa",
		  "#ffdd00", "#ddff00", "#00ffdd", "#00ddff", "#dd00ff", "#ff00dd",
		  "#ff4444", "#44ff44", "#4444ff", "#ffff44", "#44ffff", "#ff44ff",
		  "#ff7777", "#77ff77", "#7777ff", "#ffff77", "#77ffff", "#ff77ff",
		  "#ff1111", "#11ff11", "#1111ff", "#ffff11", "#11ffff", "#ff11ff",
		  "#ff2222", "#22ff22", "#2222ff", "#ffff22", "#22ffff", "#ff22ff",
		  "#ff5555", "#55ffff", "#55ff55", "#5555ff", "#ffff55", "#ff55ff",
		  "#ffaaaa", "#aaffaa", "#aaaaff", "#ffffaa", "#aaffff", "#ffaaff",
		  "#e60000", "#00e600", "#0000e6", "#e6e600", "#00e6e6", "#e600e6",
		  "#ff1493", "#39ff14", "#00bfff", "#ffd700", "#9400d3", "#ff4500",
		  "#7fff00", "#00fa9a", "#1e90ff", "#ff1493", "#adff2f", "#00ced1",
		  "#ff6347", "#7cfc00", "#20b2aa", "#4169e1", "#da70d6", "#ff69b4",
		  "#ff1744", "#00e5ff", "#76ff03", "#ffc400", "#d500f9", "#ff6d00",
		  "#f50057", "#00c853", "#2979ff", "#ffea00", "#651fff", "#00b8d4",
		  "#c6ff00", "#ff3d00", "#00ffea", "#d50000", "#304ffe", "#aaff00",
		  "#ff9100", "#00e676", "#6200ea", "#ff4081", "#18ffff", "#64dd17",
		  "#b388ff", "#69f0ae", "#40c4ff", "#ffd740", "#ff5252", "#e040fb",
		  "#84ffff", "#eeff41", "#ffab40", "#ff80ab", "#82b1ff", "#b9f6ca",
		  "#00ff7f", "#7df9ff", "#ff073a", "#f8ff13", "#bc13fe", "#fe019a",
		  "#08f7fe", "#09fbd3", "#f5d300", "#ff206e", "#00f5d4", "#ffea17",
		  "#ff1d58", "#00f0ff", "#39ff14", "#ff9f1c", "#8338ec", "#3a86ff",
		  "#fb5607", "#ffbe0b", "#06ffa5", "#00bbf9", "#ff006e", "#8338ec",
		  "#3cff00", "#ff2d00", "#00ffd5", "#ffd300", "#e100ff", "#00a2ff"
		][randint(0, 155)]
	})
}

fn query(inp) {
	for a in all {
		if strings.contains(a, inp) {
			str := strings.split(a, inp) 
			sysout strings.join(str, get_rnd_col(inp)), "\n"
		} 
	}
	println()
}

for {
	print("Query: ")
	input := bufio.readline() |> strings.trim_space
	query(input)
}