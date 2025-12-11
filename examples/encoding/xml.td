import "xml"

obj := {
	html: {
		head: {
			title: {
				"#": "No Title"
			}
		},
		body: {
			div: {
				"@id": "myid",
				"#": "Hello World"
			}
		}
	}
}

encoded := xml.encode(obj)
decoded := xml.decode(encoded)


println(string(encoded))
debug(decoded)