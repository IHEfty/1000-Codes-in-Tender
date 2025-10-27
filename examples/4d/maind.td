import "canvas"
import "math"

// Global window dimensions
w := 600
h := 400

// Compute the 16 vertices of a 4D hypercube (tesseract)
// Each coordinate is either -1 or 1
vertices := []
for x in [-1, 1] {
    for y in [-1, 1] {
        for z in [-1, 1] {
            for w_coord in [-1, 1] {
                vertices.push([x, y, z, w_coord])
            }
        }
    }
}

// Determine edges: two vertices are connected if they differ in exactly one coordinate.
edges := []
for i, v in vertices {
    for j, u in vertices {
         if j > i {
             diff := 0
             for k, coord in v {
                if math.abs(coord - u[k]) > 0.001 {
                    diff = diff + 1
                }
             }
             if diff == 1 {
                 edges.push([i, j])
             }
         }
    }
}

// 4D rotation function: rotate in the x-w and y-z planes
fn rotate4d(v, angle) {
    // v is [x, y, z, w]
    x := v[0]
    y := v[1]
    z := v[2]
    w_coord := v[3]
    
    // Rotate in x-w plane
    new_x := x * math.cos(angle) + w_coord * math.sin(angle)
    new_w := -x * math.sin(angle) + w_coord * math.cos(angle)
    
    // Rotate in y-z plane
    new_y := y * math.cos(angle) + z * math.sin(angle)
    new_z := -y * math.sin(angle) + z * math.cos(angle)
    
    return [new_x, new_y, new_z, new_w]
}

// Perspective projection from 4D to 2D:
// First, project from 4D to 3D; then from 3D to 2D.
fn project4dto2d(v) {
    // v is [x, y, z, w]
    // 4D → 3D projection:
    distance4d := 3  // viewer distance in 4D
    factor4 := distance4d / (distance4d - v[3])
    x3 := v[0] * factor4
    y3 := v[1] * factor4
    z3 := v[2] * factor4
    
    // 3D → 2D projection:
    distance3d := 3  // viewer distance in 3D
    factor3 := distance3d / (distance3d - z3)
    x2 := x3 * factor3
    y2 := y3 * factor3
    
    return [x2, y2]
}

// Map the projected 2D point to canvas coordinates (centered and scaled)
fn mapToCanvas(pt) {
    x := pt[0]
    y := pt[1]
    scale := 100   // scaling factor for visibility
    canvas_x := w/2 + x * scale
    canvas_y := h/2 - y * scale  // invert y-axis for canvas coordinates
    return [canvas_x, canvas_y]
}

//---------------------------------------
// Create the canvas window and animate the tessaract
canvas.new_window(w, h, "4D Tesseract Projection", fn(window) {
     ctx := window.new_context(w, h)
     angle := 0.0
     
     // Animation loop
     for {
         // Clear canvas with a black background
         ctx.hex("#000000")
         ctx.rect(0, 0, w, h)
         ctx.fill()
         
         // Compute rotated and projected vertices
         projected := []
         for v in vertices {
             rv := rotate4d(v, angle)
             proj := project4dto2d(rv)
             canvasPt := mapToCanvas(proj)
             projected.push(canvasPt)
         }
         
         // Draw all edges in white
         ctx.hex("#ffffff")
         ctx.linewidth(1)
         for edge in edges {
             idx1 := edge[0]
             idx2 := edge[1]
             pt1 := projected[idx1]
             pt2 := projected[idx2]
             ctx.move_to(pt1[0], pt1[1])
             ctx.line_to(pt2[0], pt2[1])
             ctx.stroke()
         }
         
         // Increment rotation angle for animation
         angle = angle + 0.01
         
         window.update(w, h)
         
         // Handle events (resize and window closure)
         e := window.next_event()
         if e.type == "size" {
              w = e.width_px
              h = e.height_px
              ctx = window.new_context(w, h)
         } else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
              break  // Exit loop when window closes
         }
     }
})
