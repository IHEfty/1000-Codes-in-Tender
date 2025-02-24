is_enumerable := fn(x) {
	return is_array(x) || is_map(x) || is_immutable_array(x) || is_immutable_map(x)
}

is_array_like := fn(x) {
	return is_array(x) || is_immutable_array(x)
}

export {
	// all returns true if the given fntion `fun` evaluates to a truthy value on
	// all of the items in `x`. It returns null if `x` is not enumerable.
	all: fn(x, fun) {
		if !is_enumerable(x) { return null }
		
		for k, v in x {
			if !fun(k, v) { return false }
		}
		
		return true
	},
	// any returns true if the given fntion `fun` evaluates to a truthy value on
	// any of the items in `x`. It returns null if `x` is not enumerable.
	any: fn(x, fun) {
		if !is_enumerable(x) { return null }
		
		for k, v in x {
			if fun(k, v) { return true }
		}
		
		return false
	},
	// chunk returns an array of elements split into groups the length of size.
	// If `x` can't be split evenly, the final chunk will be the remaining elements.
	// It returns null if `x` is not array.
	chunk: fn(x, size) {
		if !is_array_like(x) || !size { return null }
		
		numElements := len(x)
		if !numElements { return [] }
		
		res := []
		idx := 0
		for idx < numElements {
			res = append(res, x[idx:idx+size])
			idx += size
		}
		
		return res
	},
	// at returns an element at the given index (if `x` is array) or
	// key (if `x` is map). It returns null if `x` is not enumerable.
	at: fn(x, key) {
		if !is_enumerable(x) { return null }
		
		if is_array_like(x) {
		if !is_int(key) { return null }
		} else {
			if !is_string(key) { return null }
		}
		
		return x[key]
	},
	// each iterates over elements of `x` and invokes `fun` for each element. `fun` is
	// invoked with two arguments: `key` and `value`. `key` is an int index
	// if `x` is array. `key` is a string key if `x` is map. It does not iterate
	// and returns null if `x` is not enumerable.
	each: fn(x, fun) {
		if !is_enumerable(x) { return null }
		
		for k, v in x {
			fun(k, v)
		}
	},
	// filter iterates over elements of `x`, returning an array of all elements `fun`
	// returns truthy for. `fun` is invoked with two arguments: `key` and `value`.
	// `key` is an int index if `x` is array. It returns null if `x` is not array.
	filter: fn(x, fun) {
		if !is_array_like(x) { return null }
		
		dst := []
		for k, v in x {
			if fun(k, v) { dst = append(dst, v) }
		}
		
		return dst
	},
	// find iterates over elements of `x`, returning value of the first element `fun`
	// returns truthy for. `fun` is invoked with two arguments: `key` and `value`.
	// `key` is an int index if `x` is array. `key` is a string key if `x` is map.
	// It returns null if `x` is not enumerable.
	find: fn(x, fun) {
		if !is_enumerable(x) { return null }
		
		for k, v in x {
			if fun(k, v) { return v }
		}
	},
	// find_key iterates over elements of `x`, returning key or index of the first
	// element `fun` returns truthy for. `fun` is invoked with two arguments: `key`
	// and `value`. `key` is an int index if `x` is array. `key` is a string key if
	// `x` is map. It returns null if `x` is not enumerable.
	find_key: fn(x, fun) {
		if !is_enumerable(x) { return null }
		
		for k, v in x {
			if fun(k, v) { return k }
		}
	},
	// map creates an array of values by running each element in `x` through `fun`.
	// `fun` is invoked with two arguments: `key` and `value`. `key` is an int index
	// if `x` is array. `key` is a string key if `x` is map. It returns null
	// if `x` is not enumerable.
	map: fn(x, fun) {
		if !is_enumerable(x) { return null }
		
		dst := []
		for k, v in x {
			dst = append(dst, fun(k, v))
		}
		
		return dst
	},
	// key returns the first argument.
	key: fn(k, _) { return k },
	// value returns the second argument.
	value: fn(_, v) { return v }
}