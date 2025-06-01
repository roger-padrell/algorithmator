import drawim

var pixels: seq[seq[bool]];

proc initPixels(x, y: int) = 
    for py in 0..y-1:
        pixels.add(@[])
        for px in 0..x-1:
            pixels[py].add(false);

proc setPixel(x, y: int, val: bool) = 
    try:
        pixels[y][x] = val;
    except:
        discard

proc getPixel(x, y: int): bool = 
    try:
        return pixels[y][x];
    except:
        return false;

proc evalPixel(x, y: int) = 
    # If it has content, skip.
    if pixels[y][x]:
        return;
    # If directly up has content, fall
    elif getPixel(x, y-1):
        setPixel(x, y, true)
        setPixel(x, y-1, false)
        return;
    # If left up has content and left too, fall
    elif getPixel(x-1, y-1) and getPixel(x-1,y):
        setPixel(x, y, true)
        setPixel(x-1, y-1, false)
        return;
    # If right up has content and right too, fall
    elif getPixel(x+1, y-1) and getPixel(x+1, y):
        setPixel(x, y, true)
        setPixel(x+1, y-1, false)
        return; 


proc evalPixels() = 
    for sy in 0..pixels.len()-1:
        let y = pixels.len()-1-sy;
        for sx in 0..pixels[y].len()-1:
            let x = pixels[y].len()-1-sx;
            evalPixel(x, y)

proc draw() = 
    background(0)
    for y in 0..pixels.len()-1:
        for x in 0..pixels[y].len()-1:
            if pixels[y][x]:
                stroke(0,0,0)
            else:
                stroke(255,255,255)
            beginPixels()
            setPixel(x, y)
            endPixels()

proc update() = 
    echo "FPS: " & $(1/deltaTime);
    if isMousePressed(MOUSE_BUTTON_LEFT) or isMousePressed(MOUSE_BUTTON_LEFT):
        setPixel(mouseX(), mouseY(), true)
    evalPixels()
    draw()

proc sand(h, w: int) = 
    initPixels(w, h)
    run(w, h, update, name = "Sand simulation")

if isMainModule:
    sand(100,100)