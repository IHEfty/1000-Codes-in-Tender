//---------------------------------------
// Average Marks Bar Chart for Scraped Data
//---------------------------------------
import "canvas"
import "math"

// Global window dimensions
w := 600
h := 400

//---------------------------------------
// Simple Plot Library for Data Analysis
//---------------------------------------
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

fn map_x(plot, x) {
    margin := 50
    return margin + ((x - plot.x_min) / (plot.x_max - plot.x_min)) * (plot.w - 2 * margin)
}

fn map_y(plot, y) {
    margin := 50
    return plot.h - margin - ((y - plot.y_min) / (plot.y_max - plot.y_min)) * (plot.h - 2 * margin)
}

fn draw_axes(plot, ctx) {
    margin := 50
    ctx.hex("#ffffff")
    ctx.linewidth(2)
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

fn draw_dataset(plot, ctx, dataset) {
    ctx.hex(dataset.color)
    ctx.linewidth(2)
    if dataset.marker == "line" {
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
         for pt in dataset.data {
              x_canvas := map_x(plot, pt[0])
              y_canvas := map_y(plot, pt[1])
              ctx.arc(x_canvas, y_canvas, 3, 0, 2 * math.pi)
              ctx.fill()
         }
    } else if dataset.marker == "bar" {
         margin := 50
         total_bars := dataset.data.length
         // Each bar gets a slot; 80% of the slot is used for the bar width.
         slot_width := (plot.w - 2 * margin) / total_bars
         bar_width := slot_width * 0.8
         for i, pt in dataset.data {
              // Compute the center x position based on the bar slot.
              center_x := margin + i * slot_width + slot_width/2
              // Bar height determined by average mark value.
              bar_top := map_y(plot, pt[1])
              // The bottom of the bar is the x-axis.
              bar_bottom := plot.h - margin
              height := bar_bottom - bar_top
              x_rect := center_x - bar_width / 2
              ctx.rect(x_rect, bar_top, bar_width, height)
              ctx.fill()
         }
    }
}

fn draw_labels(plot, ctx) {
    ctx.hex("#ffffff")
    // Title at top center
    ctx.text(plot.title, plot.w/2, 20)
    // X-axis label at bottom center
    ctx.text(plot.xlabel, plot.w/2, plot.h - 10)
    // Y-axis label at left center
    ctx.text(plot.ylabel, 10, plot.h/2)
}

fn draw_plot(plot, ctx) {
    draw_axes(plot, ctx)
    for ds in plot.datasets {
         draw_dataset(plot, ctx, ds)
    }
    draw_labels(plot, ctx)
}

//---------------------------------------
// Data Processing for Averages
//---------------------------------------


// Process the scraped data to compute average marks per subject.
// With the updated data structure, every row is a subject row.
fn compute_subject_averages(data) {
    avg := {}  // subject -> {sum, count}
    // Iterate over each student
    for student_id, rows in data {
        // Process every row
        for i := 0; i < rows.length; i++ {
            row := rows[i]
            if row.length < 2 { continue }
            subject := row[0]
            marks := float(row[1])
            if subject != null && marks != null {
                if avg[subject] == null {
                    avg[subject] = {sum: marks, count: 1}
                } else {
                    avg[subject].sum += marks
                    avg[subject].count += 1
                }
            }
        }
    }
    // Prepare dataset for plotting:
    points := []    // Will hold [index, average] pairs.
    subjects := []  // To store subject names in the order encountered.
    index := 1
    for subj, entry in avg {
        average := entry.sum / entry.count
        points.push([index, average])
        subjects.push(subj)
        index += 1
    }
    return {data_points: points, subjects: subjects}
}

// Draw subject labels (category names) along the x-axis below the tick marks.
fn draw_x_labels(plot, ctx, subjects) {
    margin := 50
    n := subjects.length
    slot_width := (plot.w - 2 * margin) / n
    for i, subj in subjects {
        x_canvas := margin + i * slot_width + slot_width/2
        ctx.text(subj, x_canvas, plot.h - margin + 15)
    }
}

//---------------------------------------
// Scraped Data Example
//---------------------------------------
data := {
    "231002": [
        ["BAN-I",    "26", "15", "-",  "41", "41", "41", "2",   "C",  "86"],
        ["ENG-I",    "40", "-",  "-",  "40", "40", "40", "2",   "C",  "81"],
        ["ICT",      "17", "16", "15", "48", "48", "48", "2",   "C",  "96"],
        ["PHY-I",    "17", "14", "20", "51", "51", "51", "3",   "B",  "98"],
        ["CHE-I",    "30", "12", "20", "62", "62", "62", "3.5", "A-", "91"],
        ["HMM-I",    "4",  "15", "20", "39", "39", "39", "0",   "F",  "93"],
        ["BIO-I",    "2",  "10", "20", "32", "32", "32", "0",   "F",  "93"]
    ]
    // ... additional student records could be added here.
}

//---------------------------------------
// Main Plotting Execution
//---------------------------------------
canvas.new_window(w, h, "Average Marks Bar Chart", fn(window) {
    ctx := window.new_context(w, h)
    
    // Process the data to compute average marks per subject.
    computed := compute_subject_averages(data)
    avg_data := computed.data_points    // Array of [index, average marks] pairs.
    subjects := computed.subjects         // Array of subject names.
    
    // Create a new plot instance.
    // For this plot, we set x_min = 1 and x_max = number of subjects.
    plot := new_plot(w, h, "Average Marks per Subject", "Subjects", "Average Marks")
    plot.x_min = 1
    plot.x_max = subjects.length
    
    // Compute y-range from the average marks data.
    y_values := []
    for pt in avg_data {
        y_values.push(pt[1])
    }
    min_val := y_values[0]
    max_val := y_values[0]
    for i := 1; i < y_values.length; i += 1 {
        current := y_values[i]
        min_val = math.min(min_val, current)
        max_val = math.max(max_val, current)
    }
    plot.y_min = min_val
    plot.y_max = 100
	
    // Add the average dataset as a bar chart.
    add_dataset(plot, avg_data, "#0ff", "bar", "Avg Marks")
	
	debug(plot)
    
    // Draw the plot and add custom x-axis labels.
    draw_plot(plot, ctx)
    draw_x_labels(plot, ctx, subjects)
    
    window.update(w, h)
    
    // Event loop to handle window resizing and closure.
    for {
        e := window.next_event()
        if e.type == "size" {
            w = e.width_px
            h = e.height_px
            ctx = window.new_context(w, h)
            plot.w = w
            plot.h = h
            draw_plot(plot, ctx)
            draw_x_labels(plot, ctx, subjects)
            window.update(w, h)
        } else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
            break
        }
    }
})
