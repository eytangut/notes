#import "preamble.typ": *
#show: setup
#import "@preview/cetz:0.5.3": canvas, draw
// END preamble

#figure(
  canvas(length: 1cm, {
    import draw: *
      circle((0,0), radius: 3, fill: gray.lighten(70%), name: "sphere")
    arc((-3, 0), start: 180deg, stop: 360deg, radius: (3, 0.9), stroke: 0.6pt)
    arc((3, 0), start: 0deg, stop: 180deg, radius: (3, 0.9), stroke: (paint: gray, thickness: 0.6pt, dash: "dashed"))
      let wall = (
          (-1.2, 0.2), (0.4, 1.2), (0.9, 1.0), (1.3, -0.2), (0.3, -1.1), (-0.9, -0.9))
      catmull(..wall, close: true, fill: white, stroke: 1pt, name: "cavity")
    circle((0,0), radius: 0.09, fill: red, stroke: none, name: "q")
    content((0.12, -0.12), $+q$, anchor: "north-west")
      for pt in wall {
          line("q", pt, mark: (end: ">", fill: red), stroke: red + 0.6pt)
      }
      for (x,y) in wall {
          content((1.25 * x, 1.25 * y), text(blue)[$-$], frame: none)
      }
      for deg in range(0, 360, step: 40) {
          let a = deg * 1deg
          content((3.25 * calc.cos(a), 3.25 * calc.sin(a)), text(red)[$+$])
      }
      content((2.0, 2.0), [conductor, $E = 0$], anchor: "south-west")
      content((-3.2, -3.3), $R -> infinity$, anchor: "north-east")
})
)
