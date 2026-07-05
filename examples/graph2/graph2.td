import "canvas"
import "math"
import "mathf"

w := 600
h := 400

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
    ctx.linewidth(1)
    ctx.move_to(margin, plot.h - margin)
    ctx.line_to(plot.w - margin, plot.h - margin)
    ctx.stroke()
    ctx.move_to(margin, margin)
    ctx.line_to(margin, plot.h - margin)
    ctx.stroke()
    grid := 5
    for i := 0; i <= grid; i++ {
        x := margin + i * ((plot.w - 2*margin) / grid)
        ctx.hex("#333333")
        ctx.linewidth(0.5)
        ctx.move_to(x, margin)
        ctx.line_to(x, plot.h - margin)
        ctx.stroke()
        y := margin + i * ((plot.h - 2*margin) / grid)
        ctx.move_to(margin, y)
        ctx.line_to(plot.w - margin, y)
        ctx.stroke()
    }
}

fn draw_dataset(plot, ctx, dataset) {
    ctx.hex(dataset.color)
    if dataset.marker == "line" {
        ctx.linewidth(1.5)
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
        ctx.linewidth(0)
        for pt in dataset.data {
            x_canvas := map_x(plot, pt[0])
            y_canvas := map_y(plot, pt[1])
            ctx.arc(x_canvas, y_canvas, 2, 0, 2 * math.pi)
            ctx.fill()
        }
    } else if dataset.marker == "diff_line" {
        ctx.linewidth(2)
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
        ctx.linewidth(0)
        step := 1
        if len(dataset.data) > 30 {
            step = len(dataset.data) / 30
        }
        for i := 0; i < len(dataset.data); i += step {
            pt := dataset.data[i]
            x_canvas := map_x(plot, pt[0])
            y_canvas := map_y(plot, pt[1])
            ctx.arc(x_canvas, y_canvas, 1.5, 0, 2 * math.pi)
            ctx.fill()
        }
    }
}

fn draw_labels(plot, ctx) {
    ctx.hex("#ffffff")
    ctx.text(plot.title, plot.w/2, 25)
    ctx.text(plot.xlabel, plot.w/2, plot.h - 10)
    ctx.push()
    ctx.translate(15, plot.h/2)
    ctx.rotate(-math.pi / 2)
    ctx.text(plot.ylabel, 0, 0)
    ctx.pop()
    
    legend_x := plot.w - 150
    legend_y := 40
    ctx.hex("#00000070")
    ctx.rect(legend_x - 10, legend_y - 10, 160, 100)
    y_offset := 0
    for ds in plot.datasets {
        if ds.label != "__hidden__" {
            ctx.hex(ds.color)
            ctx.linewidth(2)
            ctx.move_to(legend_x, legend_y + y_offset + 5)
            ctx.line_to(legend_x + 20, legend_y + y_offset + 5)
            ctx.stroke()
            ctx.hex("#ffffff")
            ctx.text(ds.label, legend_x + 25, legend_y + y_offset + 9)
            y_offset += 20
        }
    }
}

fn draw_plot(plot, ctx) {
    draw_axes(plot, ctx)
    for ds in plot.datasets {
        if ds.label != "__hidden__" {
            draw_dataset(plot, ctx, ds)
        }
    }
    for ds in plot.datasets {
        if ds.label == "__hidden__" {
            draw_dataset(plot, ctx, ds)
        }
    }
    draw_labels(plot, ctx)
}

canvas.new_window(w, h, "InvSqrt Comparison", fn(window) {
    ctx := window.new_context(w, h)
    
    plot1 := new_plot(w, h, "1/√x vs mathf.inv_sqrt(x)", "x", "y")
    
    data1 := []
    data2 := []
    diff_data := []
    rel_error_data := []
    
    for x := 0.1; x <= 10; x += 0.05 {
        exact := 1 / math.sqrt(x)
        approx := mathf.inv_sqrt(x)
        data1.push([x, exact])
        data2.push([x, approx])
        diff_data.push([x, (approx - exact) * 1000])
        rel_error_data.push([x, math.abs(approx - exact) / exact * 100])
    }
    
    max_diff := 0.0
    for pt in diff_data {
        if math.abs(pt[1]) > max_diff {
            max_diff = math.abs(pt[1])
        }
    }
    scale := 1.0
    if max_diff > 0 {
        target_max := 2.0
        scale = target_max / max_diff
        for i, pt in diff_data {
            diff_data[i] = [pt[0], pt[1] * scale]
        }
    }
    
    zero_data := []
    for x := 0.1; x <= 10; x += 0.05 {
        zero_data.push([x, 0])
    }
    
    add_dataset(plot1, data1, "#00ff00", "line", "1/√x (exact)")
    add_dataset(plot1, data2, "#ff0000", "dot", "mathf.inv_sqrt (approx)")
    
    plot2 := new_plot(w, h, "Difference Magnified (approx - exact) × 1000", "x", "difference × 1000")
    add_dataset(plot2, diff_data, "#ff8800", "diff_line", "diff × 1000")
    add_dataset(plot2, zero_data, "#444444", "line", "zero reference")
    
    plot3 := new_plot(w, h, "Relative Error (%)", "x", "error %")
    add_dataset(plot3, rel_error_data, "#ff00ff", "line", "relative error %")
    
    current_plot := plot1
    draw_plot(current_plot, ctx)
    window.update(w, h)
    
    for {
        e := window.next_event()
        if e["type"] == "key" && e["action"] == "press" {
            key := e["key"]
            if key == "1" {
                current_plot = plot1
                draw_plot(plot1, ctx)
                window.update(w, h)
            } else if key == "2" {
                current_plot = plot2
                draw_plot(plot2, ctx)
                window.update(w, h)
            } else if key == "3" {
                current_plot = plot3
                draw_plot(plot3, ctx)
                window.update(w, h)
            }
        } else if e["type"] == "size" {
            w = e.width_px
            h = e.height_px
            ctx = window.new_context(w, h)
            current_plot.w = w
            current_plot.h = h
            draw_plot(current_plot, ctx)
            window.update(w, h)
        } else if e["type"] == "lifecycle" && e["from"] == 3 && e["to"] == 0 {
            break
        }
    }
})