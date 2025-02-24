import "os"

export {
	readfile : fn(name) {
		return os.read_file(name)
	},
	writefile : fn(name, str) {
		file := os.create(name)
		file.write(str)
		file.close()
		return file
	},
	appendfile : fn(name, str) {
		file := os.open_file(name, os.o_wronly|os.o_append|os.o_create, 0644)
		file.write_string(str)
		file.close()
		return file
	},
	isdir : fn(name) {
		stat := os.stat(name)
		if stat {
			if stat.directory {
				return true
			}
			return false
		}
		return error("\"" + name + "\" not exists")
	},
	exists : fn(name) {
		if os.stat(name) {
			return true
		}
		return false
	},
	readdir : fn(name) {
		return os.read_dir(name)
	},
	copy : os.copy,
	remove : os.remove,
	remove_all : os.remove_all,
	mkdir_all : fn(name) {
		os.mkdir_all(name, os.mode_perm)
	},
	mkdir : fn(name) {
		os.mkdir(name, 0755)
	}
}