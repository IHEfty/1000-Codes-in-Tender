//---------------------------------------
// Simple Plot Library for Data Analysis
//---------------------------------------
import "canvas"
import "math"
import "console"

console.hide()

// Global window dimensions
w := 600
h := 400

// // Define a dataset structure for the plot
// type Dataset {
    // data,   // array of [x, y] pairs
    // color,  // hex color code (e.g. "#0ff")
    // marker, // "line" or "dot"
    // label   // legend label (not drawn in this simple version)
// }

// // Define the Plot structure to hold plot settings and data
// type Plot {
    // w, h,            // dimensions of the plot area
    // title,           // plot title
    // xlabel, ylabel,  // axis labels
    // datasets,        // array of Dataset objects
    // x_min, x_max,    // data range for x
    // y_min, y_max     // data range for y
// }

// Create a new plot instance
fn new_plot(width, height, title, xlabel, ylabel) {
    return {
        w: width,
        h: height,
        title: title,
        xlabel: xlabel,
        ylabel: ylabel,
        datasets: [],
        x_min: null,
        x_max: null,
        y_min: null,
        y_max: null
    }
}

// Add a dataset to the plot and update the data ranges
fn add_dataset(plot, data, color, marker, label) {
    ds := {data: data, color: color, marker: marker, label: label}
    plot.datasets.push(ds)
    
    // Update the plot's x and y ranges based on the new data points
    for pt in data {
        x := pt[0]
        y := pt[1]
        if plot.x_min == null || x < plot.x_min { plot.x_min = x }
        if plot.x_max == null || x > plot.x_max { plot.x_max = x }
        if plot.y_min == null || y < plot.y_min { plot.y_min = y }
        if plot.y_max == null || y > plot.y_max { plot.y_max = y }
    }
}

// Map a data x value to canvas x coordinate (with margin)
fn map_x(plot, x) {
    margin := 50
    return margin + ((x - plot.x_min) / (plot.x_max - plot.x_min)) * (plot.w - 2 * margin)
}

// Map a data y value to canvas y coordinate (inverting for canvas coordinates)
fn map_y(plot, y) {
    margin := 50
    return plot.h - margin - ((y - plot.y_min) / (plot.y_max - plot.y_min)) * (plot.h - 2 * margin)
}

// Draw the axes and a simple grid on the canvas
fn draw_axes(plot, ctx) {
    margin := 50
    // Draw main axes in white
    ctx.hex("#ffffff")
    ctx.linewidth(1)
    // X-axis (horizontal)
    ctx.move_to(margin, plot.h - margin)
    ctx.line_to(plot.w - margin, plot.h - margin)
    ctx.stroke()
    // Y-axis (vertical)
    ctx.move_to(margin, margin)
    ctx.line_to(margin, plot.h - margin)
    ctx.stroke()
    
    // Draw grid lines (5 divisions)
    grid := 5
    for i := 0; i <= grid; i++ {
         // Vertical grid lines
         x := margin + i * ((plot.w - 2*margin) / grid)
         ctx.hex("#555555")
         ctx.linewidth(1)
         ctx.move_to(x, margin)
         ctx.line_to(x, plot.h - margin)
         ctx.stroke()
         
         // Horizontal grid lines
         y := margin + i * ((plot.h - 2*margin) / grid)
         ctx.move_to(margin, y)
         ctx.line_to(plot.w - margin, y)
         ctx.stroke()
    }
}

// Draw a dataset using the specified marker style
fn draw_dataset(plot, ctx, dataset) {
    ctx.hex(dataset.color)
    ctx.linewidth(1)
    if dataset.marker == "line" {
         // Draw a connected line
         for i, pt in dataset.data {
              x_canvas := map_x(plot, pt[0])
              y_canvas := map_y(plot, pt[1])
              if i == 0 {
                   ctx.move_to(x_canvas, y_canvas)
              } else {
                   ctx.line_to(x_canvas, y_canvas)
              }
         }
         ctx.stroke()
    } else if dataset.marker == "dot" {
         // Draw each point as a small circle
         for pt in dataset.data {
              x_canvas := map_x(plot, pt[0])
              y_canvas := map_y(plot, pt[1])
              ctx.arc(x_canvas, y_canvas, 3, 0, 2 * math.pi)
              ctx.fill()
         }
    }
}

// Draw labels for the title and axes
fn draw_labels(plot, ctx) {
    ctx.hex("#ffffff")
    // Title at top center
    ctx.text(plot.title, plot.w/2, 20)
    // X-axis label at bottom center
    ctx.text(plot.xlabel, plot.w/2, plot.h - 10)
    // Y-axis label at left center
    ctx.text(plot.ylabel, 10, plot.h/2)
}

// Draw the complete plot (axes, datasets, and labels)
fn draw_plot(plot, ctx) {
    draw_axes(plot, ctx)
    for ds in plot.datasets {
         draw_dataset(plot, ctx, ds)
    }
    draw_labels(plot, ctx)
}

//---------------------
// Main Demo Execution
//---------------------

canvas.new_window(w, h, "Data Analysis Plot", fn(window) {
	 ctx := window.new_context(w, h)
	 
	 // Create a new plot instance
	 plot := new_plot(w, h, "Sample Data Plot", "X Axis", "Y Axis")
	 
	 // Generate a sine wave dataset (drawn as a line)
	 sine_data := []
	 for x := -20; x <= 20; x += 0.1 {
		  sine_data.push([x, fn(x){
			  return math.sin(x)
		  }(x)])
	 }
	 add_dataset(plot, sine_data, "#0f0", "line", "Sine Wave")
	 
	 // Generate a cosine dataset (drawn as scatter dots)
	 // cosine_data := []
	 // for x := -10; x <= 10; x += 1 {
		  // cosine_data.push([x, math.cos(x)])
	 // }
	 // add_dataset(plot, cosine_data, "#f00", "dot", "Cosine Points")
	 
	 // Draw the complete plot
	 draw_plot(plot, ctx)
	 window.update(w, h)
	 
	 // Event loop to handle window events (resizing and closure)
	 for {
		  e := window.next_event()
		  if e.type == "size" {
			   w = e.width_px
			   h = e.height_px
			   ctx = window.new_context(w, h)
			   // Update plot dimensions and redraw
			   plot.w = w
			   plot.h = h
			   draw_plot(plot, ctx)
			   window.update(w, h)
		  } else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
			   break  // Exit loop on window close
		  }
	 }
})