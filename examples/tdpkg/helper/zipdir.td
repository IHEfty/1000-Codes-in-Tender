import "zip"
import "path"
import "fs"
import "strings"

export fn (dir) {
	if fs.exists(dir) {
		paths := path.walklist(dir)
		var z = zip.writer()
		for _p in paths {
			p := _p[dir.length:]
			if p[0] == '/' || p [0] == '\\' {
				p = p[1:]
			}
			if strings.trim_space(p) != "" && !fs.isdir(_p) {
				z.create(p, fs.readfile(_p))
			}
		}
		z.close()
		return z.bytes()
	}
}