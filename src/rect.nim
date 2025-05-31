import drawim

proc draw() =
  background(0)
  fill(255, 0, 0)
  translate(int(width / 2), int(height / 2))
  rectFill(-100,-100,100,100)

run(600, 400, draw, name = "Drawim example")