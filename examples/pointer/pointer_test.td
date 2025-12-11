// example 1
x := 100

p := pointer(x)

debug(p, p.addr, p.val)

debug(deref(p))

set(p,200)

debug(deref(p))
debug(x)


// example 2
arr := [1, 2, 3, 4]

pa := pointer(arr)

pa.val.push(5)
deref(pa).push([40,50,600]...)

debug(arr)