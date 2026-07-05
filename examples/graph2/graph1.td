import "canvas"
import "math"
import "mathf"

w := 600
h := 400

type new_plot struct {
    w int
    h int
    title string
    xlabel string
    ylabel string
    datasets array
    x_min float
    x_max float
    y_min float
    y_max float
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
        ctx.hex("#555555")
        ctx.linewidth(1)
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
    ctx.linewidth(1)
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
    }
}

fn draw_labels(plot, ctx) {
    ctx.hex("#ffffff")
    ctx.text(plot.title, plot.w/2, 20)
    ctx.text(plot.xlabel, plot.w/2, plot.h - 10)
    ctx.text(plot.ylabel, 10, plot.h/2)
}

fn draw_plot(plot, ctx) {
    draw_axes(plot, ctx)
    for ds in plot.datasets {
        draw_dataset(plot, ctx, ds)
    }
    draw_labels(plot, ctx)
}

canvas.new_window(w, h, "InvSqrt Comparison", fn(window) {
    ctx := window.new_context(w, h)
    plot := new_plot(w, h, "1/√x vs mathf.inv_sqrt(x)", "x", "y")

    data1 := []
    data2 := []
    for x := 0.1; x <= 10; x += 0.05 {
        data1.push([x, 1 / math.sqrt(x)])
        data2.push([x, mathf.inv_sqrt(x)])
    }
    add_dataset(plot, data1, "#0f0", "line", "1/√x")
    add_dataset(plot, data2, "#f00", "dot", "mathf.inv_sqrt")

    draw_plot(plot, ctx)
    window.update(w, h)

    for {
        e := window.next_event()
        if e["type"] == "size" {
            w = e.width_px
            h = e.height_px
            ctx = window.new_context(w, h)
            plot.w = w
            plot.h = h
            draw_plot(plot, ctx)
            window.update(w, h)
        } else if e["type"] == "lifecycle" && e["from"] == 3 && e["to"] == 0 {
            break
        }
    }
})