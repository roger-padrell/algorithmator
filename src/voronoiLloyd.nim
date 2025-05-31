## This is a simple and unoptimized verison for visualization of Voronoi's diagram with Lloyd's relaxation
## This is made in nim
import drawim, std/random, math

randomize()

proc voronoirLloyd(width, height, nSites, iterations: int) = 
    var sites: seq[(int, int)] = @[];
    while sites.len < nSites:
        sites.add((rand(0..width), rand(0..height)))
    var endVoronoi: seq[seq[int]] = @[];
    var iter = -1;
    while iter < iterations:
        # 1. GENERATE VORONOI DIAGRAM

        iter = iter + 1;
        var voronoi: seq[seq[int]] = @[];
        var dist: seq[seq[int]] = @[];

        for y in 0..height-1:
            voronoi.add(@[]);
            dist.add(@[]);
            for x in 0..width-1:
                voronoi[y].add(0);
                dist[y].add(width*height);

        var site_index = -1;
        for (sx, sy) in sites:
            site_index = site_index + 1;
            for y_pixel in 0..height-1:
                for x_pixel in 0..width-1:
                    let d = (x_pixel - sx)^2 + (y_pixel - sy)^2

                    if d < dist[y_pixel][x_pixel]:
                        dist[y_pixel][x_pixel] = d
                        voronoi[y_pixel][x_pixel] = site_index

        # 2. COMPUTE CENTROIDS (CELL AVERAGES)
        var sum_x: seq[int] = @[];
        var sum_y: seq[int] = @[];
        var counts: seq[int] = @[];
        for n in 0..nSites-1:
            sum_x.add 0;
            sum_y.add 0;
            counts.add 0;
        
        for y in 0..height-1:
            for x in 0..width-1:
                let site_idx = voronoi[y][x];
                sum_x[site_idx] += x;
                sum_y[site_idx] += y;
                counts[site_idx] += 1;

        # 3. UPDATE SITE POSITIONS
        var new_sites: seq[(int, int)] = @[];
        for site_idx in 0..nSites-1:
            if counts[site_idx] > 0:
                let centroid_x = sum_x[site_idx] / counts[site_idx];
                let centroid_y = sum_y[site_idx] / counts[site_idx];
                new_sites.add((int(centroid_x), int(centroid_y)));
            else:
                new_sites.add(sites[site_idx])

        sites = new_sites;
        endVoronoi = voronoi;

    # Draw
    var colors: seq[array[3, int]] = @[];
    for n in 0..nSites:
        colors.add([rand(0..255), rand(0..255), rand(0..255)])
    background(0)
    # Draw voronoi
    for y in 0..height-1:
        for x in 0..width-1:
            let site_idx = endVoronoi[y][x];
            stroke(colors[site_idx][0], colors[site_idx][1], colors[site_idx][2])
            beginPixels()
            setPixel(x, y)
            endPixels()
    # Draw dots
    fill(0,0,0)
    stroke(0,0,0)
    for s in sites:
        circleFill(s[0], s[1], 5)

proc draw = voronoirLloyd(300, 300, 20, 5)
setColorMode(ColorMode.RGB)
run(300, 300, draw, name = "Voronoi's diagram with Lloyd's relaxation")