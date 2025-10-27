import "canvas"
import "helper/randint"
import "math"
import "times"

//---------------------------------------
// Canvas & Grid Setup
//---------------------------------------
w := 600
h := 400

canvas.new_window(w, h, "100 Prisoners Simulation", fn(window) {
    ctx := window.new_context(w, h)
    
    // Grid parameters: 10 rows x 10 columns
    margin := 50
    rows := 10
    cols := 10
    box_width := (w - 2 * margin) / cols
    box_height := (h - 2 * margin) / rows
    
    // Helper: Get the center coordinates of a given box number (1-indexed)
    fn get_box_center(box_num) {
       row := (box_num - 1) / cols  // integer division
       col := (box_num - 1) % cols
       x := margin + col * box_width + box_width / 2
       y := margin + row * box_height + box_height / 2
       return [x, y]
    }
    
    // Draw the grid of boxes and label each with its index.
    fn draw_grid() {
       // Fill with a modern background color.
       ctx.hex("#ecf0f1")
       ctx.rect(0, 0, w, h)
       
       // Draw grid lines with a soft grey.
       ctx.hex("#bdc3c7")
       for i in range(1, 101) {
           row := (i - 1) / cols
           col := (i - 1) % cols
           x := margin + col * box_width
           y := margin + row * box_height
           ctx.rect(x, y, box_width, box_height)
           ctx.stroke()
           // Label the box with its index.
           ctx.text(i, x + 5, y + 15)
       }
    }
    
    // Initially draw grid.
    draw_grid()
    window.update(w, h)
    
    //---------------------------------------
    // Generate a Random Permutation for Boxes
    //---------------------------------------
    boxes := {}
    nums := []
    for i in range(1, 101) {
        nums.push(i)
    }
    // Fisher–Yates shuffle.
    for i in range(0, 100) {
        j := randint(i, 99)
        temp := nums[i]
        nums[i] = nums[j]
        nums[j] = temp
    }
    // Assign numbers to boxes (box # -> hidden number)
    for i in range(1, 101) {
        boxes[i] = nums[i - 1]
    }
    
    //---------------------------------------
    // Simulate Prisoners with Graphics (Only Current Chain Visible)
    //---------------------------------------
    prisonersSurvived := true
    // Modern color palette for prisoner paths.
    prisoner_colors := ["#3498db", "#2ecc71", "#e74c3c", "#9b59b6", "#f1c40f", "#1abc9c", "#34495e", "#e67e22", "#ecf0f1", "#95a5a6"]
    
    // For each prisoner, simulate the cycle strategy.
    for prisoner in range(1, 101) {
         // Clear the canvas and re-draw the grid to remove previous chain lines.
         draw_grid()
         
         // Pick a modern color for this prisoner.
         color := prisoner_colors[(prisoner - 1) % prisoner_colors.length]
         currentBox := prisoner
         found := false
         // Save path coordinates (centers of boxes visited).
         path := []
         path.push(get_box_center(currentBox))
         
         // Each prisoner gets up to 50 attempts.
         for attempt in range(1, 51) {
             if boxes[currentBox] == prisoner {
                  found = true
                  break
             }
             currentBox = boxes[currentBox]
             path.push(get_box_center(currentBox))
         }
         
         // Draw the current prisoner's path.
         ctx.hex(color)
         ctx.linewidth(1)
         // Start a new path.
         for i in range(0, path.length) {
              if i == 0 {
                 ctx.move_to(path[i][0], path[i][1])
              } else {
                 ctx.line_to(path[i][0], path[i][1])
              }
         }
         ctx.stroke()
         
         // Mark the final box: soft green if succeeded, modern red if not.
         final_center := path[path.length - 1]
         if found {
             ctx.hex("#2ecc71")
         } else {
             ctx.hex("#e74c3c")
             prisonersSurvived = false
         }
         ctx.arc(final_center[0], final_center[1], 10, 0, 2 * math.pi)
         ctx.fill()
		 ctx.hex("#ffffff")
		 ctx.text(prisoner, final_center[0], final_center[1])
         
         // Update window and delay to animate the current chain.
         window.update(w, h)
         // times.sleep(100000000)  // Delay for 300ms.
    }
    
    //---------------------------------------
    // Display Final Outcome
    //---------------------------------------
    // Clear and re-draw grid for final display.
    draw_grid()
    ctx.hex("#2c3e50")
    if prisonersSurvived {
         ctx.text("All prisoners found their number and escape!", w / 2, h - 20)
    } else {
         ctx.text("At least one prisoner failed. All prisoners are executed.", w / 2, h - 20)
    }
    window.update(w, h)
    
    // Event loop: keep the window open until closed.
    for {
         e := window.next_event()
         if e.type == "size" {
             w = e.width_px
             h = e.height_px
             ctx = window.new_context(w, h)
             window.update(w, h)
         } else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
             break
         }
    }
})
