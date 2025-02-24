import "strings"

fn parse_val(v) {
	if v == "true" {
		return true
	}
	else if v == "false" {
		return false
	}
	else if v == "null" {
		return null
	}
	else if v[0] == '"' && v[len(v)-1:] == "\"" {
		return strings.unquote(v)
	}
	else if v[0] == '\'' && v[len(v)-1:] == "'" {
		return char(v[1]) || v
	}
	else if strings.contains("0123456789", v[0]) {
		if strings.contains(v, ".") {
			return float(v) || v
		}
		return int(v) || v
	}
	return v
}

fn push(keys, value, obj) {
	k := keys[0]
	if len(keys) == 1 {
		obj[k] = value
	}
	else {
		if obj[k] == null {
			obj[k] = {}
			push(splice(keys, 1), value, obj[keys[0]])
		}
		else {
			push(splice(keys, 1), value, obj[keys[0]])
		}
	}	
}

fn decode(str) {
	arr := strings.split(str, "\n")
	map := {}
	for elm in arr {
		elm = strings.trim_space(elm)
		i :=  strings.index(elm, "=")
		if elm[0] == '#' {
			// ignore
		}
		else if i > -1 {
			a := strings.trim_space(elm[:i])
			b := parse_val(strings.trim_space(elm[i+1:]))
			arra := strings.split(a, ":")
			if len(arra) == 1 {
				map[a] = b
			}
			else {
				push(arra, b, map)
			}
		}
	}
	return map
}

fn encode_val(v) {
	if is_string(v) {
		return strings.quote(v)
	}
	else {
		return string(v)
	}
}


str := ""
fn _encode(data, pref) {
	if is_map(data) || is_immutable_map(data) {
		for k, v in data {
			pre := ""
			if pref == null {
				pre = k
			}
			else {
				pre += pref + ":" + k
			}
			if is_array(v) || is_immutable_array(v) {
				_encode(v, pre)
			}
			else if is_map(v) || is_immutable_map(v) {
				_encode(v, pre)
			}
			else {
				str += pre + " = " + encode_val(v) + "\n"
			}
		}
	}
	else if is_array(data) || is_immutable_array(data) {
		for k, v in data {
			k = string(k)
			pre := ""
			if pref == null {
				pre = k
			}
			else {
				pre += pref + ":" + k
			}
			if is_array(v) || is_immutable_array(v) {
				_encode(v, pre)
			}
			else if is_map(v) || is_immutable_map(v) {
				_encode(v, pre)
			}
			else {
				str += pre + " = " + encode_val(v) + "\n"
			}
		}
	}
}


fn encode(data) {
	str = ""
	_encode(data, null)
	return str
}

export {
	"decode" : decode,
	"encode" : encode
}