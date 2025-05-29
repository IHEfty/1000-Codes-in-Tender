import "io"
import "canvas"
import "json"
import "math"

var data = json.decode(embed("bacteria_go_dataset_augmented.json"))

var categories = [
  { key: "bacteria", prefix: "bacteria" },
  { key: "viruses", prefix: "virus" },
  { key: "algae",    prefix: "algae" }
]

var canvasWidth  = 2000
var canvasHeight = 2000
var margin       = 20
var spacingY     = 100

// Draw flagella
fn draw_flagella(ctx, x, y, shape, pos) {
  ctx.hex("#555555")
  if pos == "polar" || pos == "both" {
    ctx.line(x - 40, y, x - 70, y - 20)
    ctx.line(x + 40, y, x + 70, y + 20)
  } else if pos == "peritrichous" {
    for i in [-30, 0, 30] {
      ctx.line(x + i, y - 20, x + i - 10, y - 40)
      ctx.line(x + i, y + 20, x + i + 10, y + 40)
    }
  }
  ctx.stroke()
}

// Draw pili
fn draw_pili(ctx, x, y, shape, details) {
  ctx.hex("#999999")
  var count = 6
  for i in range(0, count) {
    var angle = 360 / count * i
    var px = x + math.cos(angle) * (details.width / 2 + 5)
    var py = y + math.sin(angle) * (details.height / 2 + 5)
    ctx.line(x, y, px, py)
  }
  ctx.stroke()
}

// Draw shape with optional details
fn draw_shape(ctx, item, x, y) {
  var shape = item.shape
  var d = item.shape_details

  // ctx.push()
  if shape == "circle" {
    ctx.circle(x, y, d.radius)
  }
  else if shape == "ellipse" {
    ctx.ellipse(x, y, d.width, d.height)
  }
  else if shape == "rod" {
    ctx.rounderect(x - d.width/2, y - d.height/2, d.width, d.height, 10)
  }
  else if shape == "spiral" {
    var r = d.radius
    for angle in range(0, 720, 20) {
      var rad = angle * 3.14 / 180
      var px = x + rad * math.cos(rad)
      var py = y + rad * math.sin(rad)
      ctx.circle(px, py, 1)
    }
  }
  else if shape == "comma" {
    ctx.arc(x, y, d.radius, 45, 270)
  }
  else if shape == "star" {
    ctx.polygon(5, x, y, d.radius, 0)
  }
  else {
    ctx.circle(x, y, 20)
  }

  ctx.fill()

  // Draw flagella if present
  if item.flagella == true && item.flagella_position != null {
    draw_flagella(ctx, x, y, shape, item.flagella_position)
  }

  // Draw pili if present
  if item.pili == true {
    draw_pili(ctx, x, y, shape, d)
  }
}

for cat in categories {
  var items = data[cat.key]
  var pageIndex = 1
  var x = margin
  var y = margin
  var ctx = canvas.new_context(canvasWidth, canvasHeight)

  for item in items {
    if y + spacingY > canvasHeight {
      ctx.save_png(cat.prefix + "_" + pageIndex + ".png")
      pageIndex += 1
      ctx = canvas.new_context(canvasWidth, canvasHeight)
      y = margin
    }

    // Draw organism shape
    ctx.hex(item.color)
    draw_shape(ctx, item, x + 40, y + 30)

    // Annotate
    ctx.hex("#FFFFFF")
    ctx.text(item.name, x + 100, y)
    ctx.text("Type: " + item.type, x + 100, y + 20)
    ctx.text("Shape: " + item.shape, x + 100, y + 40)
    ctx.text("Size: " + item.size, x + 100, y + 60)
    ctx.text("Density: " + item.density, x + 100, y + 80)
    if item.flagella == true {
      ctx.text("Flagella: " + item.flagella_position, x + 400, y + 20)
    }
    if item.pili == true {
      ctx.text("Pili: " + item.pili_type, x + 400, y + 40)
    }

    y += spacingY
  }

  ctx.save_png(cat.prefix + "_" + pageIndex + ".png")
}

