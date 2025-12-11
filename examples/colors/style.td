import "colors"

// Create red text
red_text := colors.style("Warning!", {color: "#f00", bold: true})

// Create bordered panel
panel := colors.style("Content", {
  border: "rounded",
  padding: 2,
  color: "#00FF22",
  background: "#222222"
})

// Print to colorable stdout
println(red_text)
println(panel)