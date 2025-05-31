import drawim, math, std/random

const
    G = 0.981f  # e.g., 6.67430e-11 (SI units) or 1.0 (normalized)
    base_mass = 10
    initial_radius = 100;

setColorMode(ColorMode.RGB)
randomize()

var screenSize = (0,0)

type Body = object
    mass*: float
    x*, y*: float         # Position
    vx*, vy*: float       # Velocity
    ax*, ay*: float       # Acceleration
    color*: array[3, int]
    r*: int

proc initializeBodies(n, R, cx, cy: int): seq[Body] =
    var initbodies: seq[Body] = @[];
    for i in 0..n-1:
        let theta = 2f * PI * (float i) / (float n);  # Equal angular spacing
        
        initbodies.add(Body())
        # Position on circle
        initbodies[i].x = (float cx) + (float initial_radius) * cos(theta);
        initbodies[i].y = (float cy) + (float initial_radius) * sin(theta);
        
        # Set mass (e.g., uniform or variable)
        initbodies[i].mass = base_mass; 
        
        # Velocities
        initbodies[i].vx = float rand(-1..1)  # Tangential direction
        initbodies[i].vy = float rand(-1..1)  
        
        initbodies[i].ax = 0
        initbodies[i].ay = 0

        # Set radius property and random color
        initbodies[i].r = R;
        initbodies[i].color = [rand(0..255), rand(0..255), rand(0..255)]
    return initbodies;

proc resetAccelerations(bodies: var seq[Body]) =
    for i in 0..bodies.len-1:
        bodies[i].ax = 0;
        bodies[i].ay = 0;

proc computeForces(bodies: var seq[Body], G: float) = 
    for i in 0..bodies.len-1:
        for j in 0..bodies.len-1:
            if i == j:
                continue;
            # Calculate distance components
            let dx = bodies[j].x - bodies[i].x
            let dy = bodies[j].y - bodies[i].y
            
            # Compute squared distance with softening
            let r_sq = dx*dx + dy*dy;
            
            # Calculate inverse cube of distance (1/r^3)
            let inv_r3 = 1.0 / (sqrt(r_sq) + 0.1e-5)
            
            # Gravitational force magnitude
            let force_mag = G * (bodies[i].mass * bodies[j].mass) * inv_r3;
            
            # Force components
            let fx = force_mag * dx
            let fy = force_mag * dy
            
            # Update accelerations (F = ma)
            bodies[i].ax += fx / bodies[i].mass
            bodies[i].ay += fy / bodies[i].mass
            bodies[j].ax -= fx / bodies[j].mass
            bodies[j].ay -= fy / bodies[j].mass

proc updateVelocitiesAndPositions(bodies: var seq[Body], DT: float) =
    for i in 0..bodies.len-1:
        # Update velocities (v = v0 + a*dt)
        bodies[i].vx += bodies[i].ax * DT
        bodies[i].vy += bodies[i].ay * DT
        
        # Update positions (x = x0 + v*dt)
        bodies[i].x += bodies[i].vx * DT
        bodies[i].y += bodies[i].vy * DT

        # Bounce of walls
        if (bodies[i].x < 0) or (bodies[i].x > (float screenSize[0])):
            bodies[i].ax = 0 - bodies[i].ax;
            bodies[i].vx = 0 - bodies[i].vx;
        if (bodies[i].y < 0) or (bodies[i].y > (float screenSize[1])):
            bodies[i].ay = 0 - bodies[i].ay;
            bodies[i].vy = 0 - bodies[i].vy;

var bodies: seq[Body] = @[];

proc update*() = 
    echo "FPS: " & $(1f / deltaTime)
    resetAccelerations(bodies)           # Set all accelerations to zero
    computeForces(bodies, G)  # Compute net forces
    updateVelocitiesAndPositions(bodies, deltaTime) # Integrate motion

    # Draw
    background(0)
    for b in bodies:
        fill(b.color[0], b.color[1], b.color[2]);
        circleFill(b.x, b.y, b.r);

proc nBody2D*(n: int, R: int, screen: (int, int)) =
    screenSize = screen;
    let cx = int screen[0]/2;
    let cy = int screen[1]/2;
    bodies = initializeBodies(n, R, cx, cy);
    run(screen[0], screen[1], update, name = "N-Body 2D simulation")

nBody2D(3, 20, (1000, 1000))