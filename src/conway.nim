import drawim, math

var grid: seq[seq[bool]];

const cellSize = 10;

setColorMode(ColorMode.RGB)

proc initCells(cells: var seq[seq[bool]], x, y: int) = 
    for py in 0..y-1:
        cells.add(@[])
        for px in 0..x-1:
            cells[py].add(false);

proc setCell(cells: var seq[seq[bool]], x, y: int, val: bool) = 
    try:
        cells[y][x] = val;
    except:
        discard

proc getCell(cells: seq[seq[bool]], x, y: int): bool = 
    try:
        return cells[y][x];
    except:
        return false;

proc getSurroundingCells(cells: seq[seq[bool]], x, y: int): int =
    var s = 0;

    # Top Middle
    if cells.getCell(x,y-1):
        s = s + 1;
    # Top Right
    if cells.getCell(x+1,y-1):
        s = s + 1;
    # Middle Right
    if cells.getCell(x+1,y):
        s = s + 1;
    # Bottom Right
    if cells.getCell(x+1,y+1):
        s = s + 1;
    # Bottom Middle
    if cells.getCell(x,y+1):
        s = s + 1;
    # Bottom Left
    if cells.getCell(x-1,y+1):
        s = s + 1;
    # Middle Left
    if cells.getCell(x-1,y):
        s = s + 1;
    # Top Left
    if cells.getCell(x-1,y-1):
        s = s + 1;

    return s;

proc evalCell(tempCells: seq[seq[bool]], x, y: int) =
    let n = tempCells.getSurroundingCells(x, y);
    # Any live cell with fewer than two live neighbours dies
    if n < 2:
        grid.setCell(x, y, false);
    # Any live cell with more than three live neighbours dies
    elif n > 3:
        grid.setCell(x, y, false);
    # Any live cell with two or three live neighbours lives, unchanged, to the next generation
    elif (n == 2 or n == 3) and tempCells.getCell(x, y):
        grid.setCell(x, y, true)
    # Any dead cell with exactly three live neighbours comes to life.
    elif (n == 3) and (not tempCells.getCell(x, y)):
        grid.setCell(x, y, true)

proc evalGrid() = 
    let tempCells = grid;
    for y in 0..grid.len()-1:
        for x in 0..grid[0].len()-1:
            tempCells.evalCell(x, y);

proc draw() = 
    background(0);
    for y in 0..grid.len()-1:
        for x in 0..grid[0].len()-1:
            if grid.getCell(x, y):
                fill(255, 255, 255)
                rectFill(x*cellSize,y*cellSize,x*cellSize+cellSize,y*cellSize+cellSize);
            else:
                fill(0, 0, 0)
                rectFill(x*cellSize,y*cellSize,x*cellSize+cellSize,y*cellSize+cellSize);

var running = false;
proc update() = 
    echo "FPS: " & $(1/deltaTime)
    # Detect input
    if not running:
        if isMousePressed(MOUSE_BUTTON_LEFT):
            let cellX: int = int floor mouseX()/cellSize;
            let cellY: int = int floor mouseY()/cellSize;
            grid.setCell(cellX, cellY, true);
        elif isMousePressed(MOUSE_BUTTON_RIGHT):
            let cellX: int = int floor mouseX()/cellSize;
            let cellY: int = int floor mouseY()/cellSize;
            grid.setCell(cellX, cellY, false);
    if isKeyPressed(KEY_SPACE):
        running = not running;
    # Run
    if running:
        evalGrid()
    draw()

proc conway*(w, h: int) = 
    grid.initCells(int floor w/cellSize, int floor h/cellSize)
    run(w, h, update, name = "Conway's Game of Life")

if isMainModule:
    conway(500, 500)