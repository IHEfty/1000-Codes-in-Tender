// tender@v0.0.9
import "runtime"
import "sync"
import "image"
import "times"
import "rand"

start := times.now()

w, h := 255, 255
img := image.new(w, h)

num_workers := runtime.num_cpu()
var wg = sync.wait_group()
wg.add(num_workers)

// each worker processes a chunk of rows
rows_per_worker := h / num_workers
debug(rows_per_worker)

for worker := 0; worker < num_workers; worker++ {
	go fn(worker_id) {
		defer wg.done()
		
		start_y := worker_id * rows_per_worker
		end_y := start_y + rows_per_worker
		if worker_id == num_workers-1 {
			end_y = h
		}
		
		// direct pixel access - much faster than set()
		for y := start_y; y < end_y; y++ {
			for x := 0; x < w; x++ {
				color := [rand.intn(255), rand.intn(255), rand.intn(255), rand.intn(255)]
				img.set(x, y, color)
			}
		}
	}(worker)
}

wg.wait()

// img.save("out.png", "png")

end := times.since(start)

println(end, "ms")
println(float(end)/times.second, "sec")