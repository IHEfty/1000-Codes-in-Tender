
fn bag() {
	items := {}
	
	this := {
		add: fn(x) {
			if items[x] { items[x] += 1 } else { items[x] = 1 }
			return this
		},
		remove: fn(x, n) {
			n = n || 1
			if items[x] {
				items[x] -= n
				if items[x] <= 0 { delete(items, x) }
			}
			return this
		},
		count: fn(x) {
			return items[x] || 0
		},
		has: fn(x) { return items[x] != null },
		unique: fn() {
			out := []
			for k, _ in items { out.push(k) }
			return out
		},
		all: fn() {
			out := []
			for k, v in items {
				for i := 0; i < v; i++ { out.push(k) }
			}
			return out
		},
		clear: fn() { items = {}; return this },
		copy: fn() { 
			b := bag.new()
			for k, v in items { for i := 0; i < v; i++ { b.add(k) } }
			return b
		},
		__print__: fn() { return this.all() }
	}

	return this
}


export bag