//gob encoding from golang "encoding/gob"

import "gob"

var map = {x:100,y:immutable([1,2,3,5])}

encoded := gob.encode(map)
decoded := gob.decode(encoded)

println(encoded)
println(decoded)