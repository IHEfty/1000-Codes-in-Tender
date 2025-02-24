json := import("json")
strings := import("strings")

unescape := fn(s) {
    s = strings.replace(s, "&lt;", "<", -1)
    s = strings.replace(s, "&gt;", ">", -1)
    s = strings.replace(s, "&amp;", "&", -1)
    s = strings.replace(s, "&apos;", "'", -1)
    s = strings.replace(s, "&quot;", "\"", -1)
    return s
}

escape := fn(s) {
    s = strings.replace(s, "&", "&amp;", -1)
    s = strings.replace(s, "<", "&lt;", -1)
    s = strings.replace(s, ">", "&gt;", -1)
    s = strings.replace(s, "'", "&apos;", -1)
    s = strings.replace(s, "\"", "&quot;", -1)
    return s
}

// XML Parser Function
parse := fn(xml_string) {
    stack := []
    current_element := {
        tag: "",
        attributes: {},
        content: "",
        children: []
	}
	
    for i := 0; i < len(xml_string); i++ {
        if xml_string[i] == '<' {
            // Start of a new tag
            end_index := i + 1
            for end_index < len(xml_string) && xml_string[end_index] != '>' {
                end_index++
			}
            tag := xml_string[i+1 : end_index]
            if tag[0] == '/' {
                // Closing tag
                current_element.tag = strings.trim_space(xml_string[i+2 : end_index])
                if len(stack) > 0 {
                    parent := stack[len(stack)-1]
                    parent.children = append(parent.children, current_element)
                    current_element = parent
                    stack = stack[:len(stack)-1]
				}
			} 
			else {
				// Opening tag
				new_element := {
					tag: tag,
					attributes: {},
					content: "",
					children: []
				}
				
				// Parse attributes
				for {
					// Skip whitespace
					for i < end_index && (xml_string[i] == ' ' || xml_string[i] == '\t' || xml_string[i] == '\n' || xml_string[i] == '\r') {
						i++
					}
					if i == end_index {
						break
					}
					
					// Read attribute name
					attr_start := i
					for i < end_index && xml_string[i] != '=' && xml_string[i] != ' ' {
						i++
					}
					attr_name := xml_string[attr_start:i]
					
					// Skip to attribute value
					for i < end_index && (xml_string[i] == ' ' || xml_string[i] == '=') {
						i++
					}
					if i == end_index {
						break
					}
					
					// Read attribute value
					if xml_string[i] == '"' {
						i++
						attr_start = i
						for i < end_index && xml_string[i] != '"' {
							i++
						}
						attr_value := xml_string[attr_start:i]
						new_element.attributes[attr_name] = unescape(attr_value)
						i++
					}
				}
				if tag[len(tag)-1] == '/' {   
	                new_element.tag = strings.trim_space(tag[:strings.index(tag, " ")])
					current_element.children = append(current_element.children, new_element)
				}
				else {
					stack = append(stack, current_element)
					current_element = new_element
				}
				
			}
			i = end_index
		} 
		else {
            // Content between tags
            start_index := i
            for i < len(xml_string) && xml_string[i] != '<' {
                i++
			}
            current_element.content = unescape(strings.trim_space(xml_string[start_index:i]))
            i--
		}
	}
	
    return current_element
}


decode := fn(node) {
	result := {}
	
	duplicates := []
	c := []
	
	for children in node.children {
		if includes(c, children.tag) {
			duplicates = append(duplicates, children.tag)
		}
		else {
			c = append(c, children.tag)
		}
	}
	
	
	for k, v in node.attributes {
		result["@" + k] = v
	}
	
	if len(node.children) == 0 && len(node.attributes) == 0 {
		result = node.content
	}
	else if len(node.children) == 0 {
		result["#"] = node.content
	}
	
	for children in node.children {
		if includes(duplicates, children.tag) {
			if !result[children.tag] {
				result[children.tag] = []
			}
			result[children.tag] = append(result[children.tag], decode(children))
		}
		else {
			result[children.tag] = decode(children)
		}
	}
	
	return result
}

stringify := fn(node, depth, d_level) {
	if len(node.children) == 1 {
		node = node.children[0]
	}
	
    result := strings.repeat(" ", depth) + "<" + node.tag
	
    // Encode attributes
    for k, v in node["attributes"] {
        result += " " + k + `="` + escape(v) + `"`
	}
	
    if len(node.children) == 0 {
		result += ">" + escape(node.content) + "</" + node.tag + ">\n"
	} 
	else {
        result += ">\n"
		
        for child in node.children {
            result += stringify(child, depth + d_level, d_level)
		}
		
        result += strings.repeat(" ", depth) + "</" + node.tag + ">\n"
	}
	
    return result
}

encode := fn(k, v, depth, d_level) {
    result := ""
    if is_map(v) || is_immutable_map(v) {
		content := ""
		attrs := ""
		childs := ""
        for kk, vv in v {
			if kk[0] == '@' {
				attrs += " " + kk[1:] + "=\"" + vv + "\""
			}
			else if kk == "#" {
				content = vv
			}
			else {
				childs += encode(kk, vv, depth + d_level, d_level)
			}
		}
		
        result += strings.repeat(" ", depth) + "<" + k + attrs + ">"
		if childs == "" {
			result += content
		}
		else {
			result += "\n"
			result += childs
			result += strings.repeat(" ", depth)
		}
        result += "</" + k + ">\n"
	}
	else if is_array(v) || is_immutable_array(v) {
        for vv in v {
            result += encode(k, vv, depth + d_level, d_level)
		}
	}
	else if is_string(v) || is_int(v) || is_float(v) || is_bool(v) || is_char(v) || is_bytes(v) || is_time(v) {
        result += strings.repeat(" ", depth) + "<" + k + ">" + escape(string(v)) + "</" + k + ">\n"
	}
	else {
        result += strings.repeat(" ", depth) + "<" + k + ">" + "<" + k + "/>\n"
	}
    return result
}


export {
	escape : escape,
	unescape : unescape,
	parse : parse,
	stringify : fn(map, depth) {
		return stringify(map, 0, depth)
	},
	decode : fn(xml_string) {
		d := decode(parse(string(xml_string)))
		if len(d) == 1 {
			if includes(d, "") {
				return d[""]
			}
		}
		return d
	},
	encode : fn(d, depth) {
		if is_map(d) || is_immutable_map(d) {
			if len(d) == 1 {
				for k, v in d {
					return encode(k, v, 0, depth)
				}
			}
			else {
				return encode("", d, 0, depth)
			}
		}
		else {
			return encode("", d, 0, depth)
		}
	}
}