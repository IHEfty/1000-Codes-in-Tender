// 2D Physics Engine – Enriched Version

import "math"
import "vec2"

// --- HELPER FUNCTIONS ---

// 2D cross product returning a scalar (for two vectors).
fn cross_scalar(a, b) {
    return a.x * b.y - a.y * b.x
}

// 2D cross product: scalar x vector => vector.
fn cross_vec(s, v) {
    // returns a vector perpendicular to v scaled by s.
    return vec2(-s * v.y, s * v.x)
}

// Clamp value between a min and max.
fn clamp(val, min_val, max_val) {
    if (val < min_val) {
        return min_val
    }
    if (val > max_val) {
        return max_val
    }
    return val
}

// --- SHAPES ---

// A simple circle shape.
fn circle(radius) {
    this := {
        type: "circle",
        radius: float(radius)
    }
    return this
}

// A box (rectangle) shape.
fn box(half_width, half_height) {
    this := {
        type: "box",
        half_width: float(half_width),
        half_height: float(half_height)
    }
    return this
}

// --- COLLISION DETECTION ---

// Collision detection for circle vs circle.
fn detect_collision_circle_circle(b1, b2) {
    n := b2.position.sub(b1.position)
    dist := n.len()
    r := b1.shape.radius + b2.shape.radius
    if (dist < r) {
        penetration := r - dist
        normal := (dist > 0) ? n.scale(1 / dist) : vec2(1, 0)
        contact_point := b1.position.add(normal.scale(b1.shape.radius))
        return { penetration: penetration, normal: normal, contact_point: contact_point }
    }
    return null
}

// Collision detection for circle vs box.
// Assumes b1 is circle and b2 is box.
fn detect_collision_circle_box(b_circle, b_box) {
    // Transform circle center into box's local space.
    rel := b_circle.position.sub(b_box.position)
    cosA := math.cos(-b_box.angle)
    sinA := math.sin(-b_box.angle)
    local := vec2(
        rel.x * cosA - rel.y * sinA,
        rel.x * sinA + rel.y * cosA
    )
    // Clamp the local point to the box's extents.
    clamped := vec2(
        clamp(local.x, -b_box.shape.half_width, b_box.shape.half_width),
        clamp(local.y, -b_box.shape.half_height, b_box.shape.half_height)
    )
    // Compute the difference between local circle position and clamped point.
    diff := local.sub(clamped)
    dist := diff.len()
    if (dist < b_circle.shape.radius) {
        penetration := b_circle.shape.radius - dist
        // Compute normal in local space.
        local_normal := (dist > 0) ? diff.scale(1 / dist) : vec2(1, 0)
        // Rotate the normal back to world space.
        cosA = math.cos(b_box.angle)
        sinA = math.sin(b_box.angle)
        normal := vec2(
            local_normal.x * cosA - local_normal.y * sinA,
            local_normal.x * sinA + local_normal.y * cosA
        )
        // Contact point on the circle perimeter.
        contact_point := b_circle.position.sub(normal.scale(b_circle.shape.radius))
        return { penetration: penetration, normal: normal, contact_point: contact_point }
    }
    return null
}

// Collision detection for box vs box using a simple SAT.
// Updated collision detection for box vs box.
fn detect_collision_box_box(b1, b2) {
    // Helper: get the world vertices of a box body.
    fn get_vertices(body) {
        hw := body.shape.half_width
        hh := body.shape.half_height
        // Local corners.
        local_points := [
            vec2(-hw, -hh),
            vec2(hw, -hh),
            vec2(hw, hh),
            vec2(-hw, hh)
        ]
        vertices := []
        cosA := math.cos(body.angle)
        sinA := math.sin(body.angle)
		for i := 0; i < local_points.length; i++ {
            lp := local_points[i]
            // Rotate and translate.
            rotated := vec2(
                lp.x * cosA - lp.y * sinA,
                lp.x * sinA + lp.y * cosA
            )
            vertices.push(body.position.add(rotated))
        }
        return vertices
    }

    // Use a large constant instead of math.INFINITY.
	INF := 1e9

    verticesA := get_vertices(b1)
    verticesB := get_vertices(b2)

    // Axes to test: normals of each edge from both boxes.
    axes := []
    fn add_axes(vertices, axes_list) {
        for i := 0; i < vertices.length; i++ {
            next := vertices[(i + 1) % vertices.length]
            edge := next.sub(vertices[i])
            // Normalized perpendicular.
            axis := vec2(-edge.y, edge.x).norm()
            axes_list.push(axis)
        }
    }
    add_axes(verticesA, axes)
    add_axes(verticesB, axes)

    min_overlap := INF
    smallest_axis := null

    // SAT test on all axes.
	for i := 0; i < axes.length; i++ {
        axis := axes[i]
        minA := INF
        maxA := -INF
		for j := 0; j < verticesA.length; j++ {
            projection := verticesA[j].dot(axis)
            if (projection < minA) { minA = projection }
            if (projection > maxA) { maxA = projection }
        }
        minB := INF
        maxB := -INF
		for j := 0; j < verticesB.length; j++ {
            projection := verticesB[j].dot(axis)
            if (projection < minB) { minB = projection }
            if (projection > maxB) { maxB = projection }
        }
        // Compute overlap on this axis.
        overlap := math.min(maxA, maxB) - math.max(minA, minB)
        if (overlap < 0) {
            // Separating axis found; no collision.
            return null
        }
        if (overlap < min_overlap) {
            min_overlap = overlap
            smallest_axis = axis
        }
    }

    // Ensure the normal points from b1 to b2.
    d := b2.position.sub(b1.position)
    if (d.dot(smallest_axis) < 0) {
        smallest_axis = smallest_axis.scale(-1)
    }

    // --- Compute a more accurate contact point ---
    // Function to test if a point is inside a box.
    fn point_in_box(point, box_body) {
        rel := point.sub(box_body.position)
        cosA := math.cos(-box_body.angle)
        sinA := math.sin(-box_body.angle)
        local := vec2(
            rel.x * cosA - rel.y * sinA,
            rel.x * sinA + rel.y * cosA
        )
        return (math.abs(local.x) <= box_body.shape.half_width) &&
               (math.abs(local.y) <= box_body.shape.half_height)
    }

    contact_points := []
    // Check vertices of b1 that lie inside b2.
	for i := 0; i < verticesA.length; i++ {
        if (point_in_box(verticesA[i], b2)) {
            contact_points.push(verticesA[i])
        }
    }
    // Check vertices of b2 that lie inside b1.
	for i := 0; i < verticesB.length; i++ {
        if (point_in_box(verticesB[i], b1)) {
            contact_points.push(verticesB[i])
        }
    }

    // If we have overlapping vertices, average them.
    contact_point := b1.position.add(b2.position).scale(0.5) // fallback
    if (contact_points.length > 0) {
        sum := vec2(0, 0)
		for i := 0; i < contact_points.length; i++ {
            sum = sum.add(contact_points[i])
        }
        contact_point = sum.scale(1 / contact_points.length)
    }

    return { penetration: min_overlap, normal: smallest_axis, contact_point: contact_point }
}


// Master collision detector.
// Supports circle-circle, circle-box, box-circle, and box-box.
fn detect_collision(b1, b2) {
    if (b1.shape.type == "circle" && b2.shape.type == "circle") {
        return detect_collision_circle_circle(b1, b2)
    }
    if (b1.shape.type == "circle" && b2.shape.type == "box") {
        return detect_collision_circle_box(b1, b2)
    }
    if (b1.shape.type == "box" && b2.shape.type == "circle") {
        // Swap order and invert the normal.
        manifold := detect_collision_circle_box(b2, b1)
        if (manifold != null) {
            manifold.normal = manifold.normal.scale(-1)
        }
        return manifold
    }
    if (b1.shape.type == "box" && b2.shape.type == "box") {
        return detect_collision_box_box(b1, b2)
    }
    // Additional shape combinations can be added here.
    return null
}

// --- COLLISION RESOLUTION ---

// Resolves a collision (including friction and rotation) using an impulse-based method.
fn resolve_collision(b1, b2, manifold) {
    // r vectors from centers to contact point.
    r1 := manifold.contact_point.sub(b1.position)
    r2 := manifold.contact_point.sub(b2.position)
    // Compute relative velocity at contact.
    rv := b2.velocity.add(cross_vec(b2.angular_velocity, r2)).sub(b1.velocity.add(cross_vec(b1.angular_velocity, r1)))
    vel_along_normal := rv.dot(manifold.normal)
    if (vel_along_normal > 0) {
        return
    }
    restitution := math.min(b1.restitution, b2.restitution)
    // Calculate the denominator taking into account both mass and inertia.
    r1_cross_n := cross_scalar(r1, manifold.normal)
    r2_cross_n := cross_scalar(r2, manifold.normal)
    inv_mass_sum := b1.inv_mass + b2.inv_mass +
        (r1_cross_n * r1_cross_n) * b1.inv_inertia +
        (r2_cross_n * r2_cross_n) * b2.inv_inertia
    impulse_scalar := -(1 + restitution) * vel_along_normal / inv_mass_sum
    impulse := manifold.normal.scale(impulse_scalar)

    // Apply impulse.
    if (!b1.is_static) {
        b1.velocity = b1.velocity.sub(impulse.scale(b1.inv_mass))
        b1.angular_velocity = b1.angular_velocity - b1.inv_inertia * cross_scalar(r1, impulse)
    }
    if (!b2.is_static) {
        b2.velocity = b2.velocity.add(impulse.scale(b2.inv_mass))
        b2.angular_velocity = b2.angular_velocity + b2.inv_inertia * cross_scalar(r2, impulse)
    }

    // --- Friction Impulse ---
    rv = b2.velocity.add(cross_vec(b2.angular_velocity, r2)).sub(b1.velocity.add(cross_vec(b1.angular_velocity, r1)))
    tangent := rv.sub(manifold.normal.scale(rv.dot(manifold.normal)))
    tangent = tangent.norm()
    r1_cross_t := cross_scalar(r1, tangent)
    r2_cross_t := cross_scalar(r2, tangent)
    inv_mass_sum_t := b1.inv_mass + b2.inv_mass +
         (r1_cross_t * r1_cross_t) * b1.inv_inertia +
         (r2_cross_t * r2_cross_t) * b2.inv_inertia
    jt := -rv.dot(tangent) / inv_mass_sum_t
    // Coulomb friction: use the combined friction coefficient.
    mu := math.sqrt(b1.friction * b2.friction)
    // Clamp friction impulse.
    if (math.abs(jt) > impulse_scalar * mu) {
        jt = impulse_scalar * mu * (jt < 0 ? -1 : 1)
    }
    friction_impulse := tangent.scale(jt)
    if (!b1.is_static) {
        b1.velocity = b1.velocity.sub(friction_impulse.scale(b1.inv_mass))
        b1.angular_velocity = b1.angular_velocity - b1.inv_inertia * cross_scalar(r1, friction_impulse)
    }
    if (!b2.is_static) {
        b2.velocity = b2.velocity.add(friction_impulse.scale(b2.inv_mass))
        b2.angular_velocity = b2.angular_velocity + b2.inv_inertia * cross_scalar(r2, friction_impulse)
    }

    // --- Positional Correction ---
    percent := 0.2  // correction percentage
    slop := 0.01    // allowed penetration
    correction_magnitude := math.max(manifold.penetration - slop, 0) /
                            (b1.inv_mass + b2.inv_mass) * percent
    correction := manifold.normal.scale(correction_magnitude)
    if (!b1.is_static) {
        b1.position = b1.position.sub(correction.scale(b1.inv_mass))
    }
    if (!b2.is_static) {
        b2.position = b2.position.add(correction.scale(b2.inv_mass))
    }
}

// --- BODY DEFINITION ---

// Computes moment of inertia for a given shape and mass.
fn compute_inertia(shape, mass) {
    if (shape.type == "circle") {
        // Moment of inertia for a solid circle: (1/2) * m * r^2.
        return 0.5 * mass * shape.radius * shape.radius
    }
    if (shape.type == "box") {
        // For a rectangle: (1/12) * m * (width^2 + height^2)
        width := shape.half_width * 2
        height := shape.half_height * 2
        return (mass * (width * width + height * height)) / 12
    }
    return 0
}

// A rigid body. Each body has position, velocity, angular dynamics,
// forces/torque accumulators, and an associated shape.
fn body(position, angle, is_static, shape) {
    // For dynamic bodies, assign a default mass (1.0); static bodies have mass = 0.
    mass_value := (is_static) ? 0.0 : 1.0
    inv_mass_value := (mass_value > 0) ? 1.0 / mass_value : 0.0

    // Compute moment of inertia.
    inertia_value := (mass_value > 0) ? compute_inertia(shape, mass_value) : 0.0
    inv_inertia_value := (inertia_value > 0) ? 1.0 / inertia_value : 0.0

    this := {
        position: position,
        angle: angle,
        velocity: vec2(0, 0),
        angular_velocity: 0,
        force: vec2(0, 0),
        torque: 0,
        is_static: is_static,
        shape: shape,
        mass: mass_value,
        inv_mass: inv_mass_value,
        inertia: inertia_value,
        inv_inertia: inv_inertia_value,
        friction: 0.5,
        restitution: 0.2,

        apply_force: fn(f) {
            if (!this.is_static) {
                this.force = this.force.add(f)
            }
        },

        // Apply force at a specific world-space point.
        apply_force_at_point: fn(f, point) {
            if (!this.is_static) {
                this.apply_force(f)
                r := point.sub(this.position)
                // Torque = r x f (scalar in 2D).
                this.torque = this.torque + cross_scalar(r, f)
            }
        },

        apply_torque: fn(t) {
            if (!this.is_static) {
                this.torque = this.torque + t
            }
        },

        clear_forces: fn() {
            this.force = vec2(0, 0)
            this.torque = 0
        }
    }
    return this
}

// --- WORLD DEFINITION ---

// The World contains bodies, applies gravity, integrates motion,
// and performs collision detection/resolution.
fn world(gravity) {
    this := {
        gravity: gravity,
        bodies: [],

        add_body: fn(body) {
            this.bodies.push(body)
        },

        step: fn(dt) {
            // First, integrate forces to update velocities.
			for i := 0; i < this.bodies.length; i++ {
                body := this.bodies[i]
                if (!body.is_static) {
                    // Apply gravity force.
                    body.apply_force(this.gravity.scale(body.mass))
                    // Linear integration.
                    acceleration := body.force.scale(body.inv_mass)
                    body.velocity = body.velocity.add(acceleration.scale(dt))
                    body.position = body.position.add(body.velocity.scale(dt))
                    // Angular integration.
                    angular_acceleration := body.torque * body.inv_inertia
                    body.angular_velocity = body.angular_velocity + angular_acceleration * dt
                    body.angle = body.angle + body.angular_velocity * dt
                    body.clear_forces()
                }
            }
            // Then, detect and resolve collisions.
            this.resolve_collisions()
        },

        resolve_collisions: fn() {
            for i := 0; i < this.bodies.length; i++ {
                for j := i + 1; j < this.bodies.length; j++ {
                    b1 := this.bodies[i]
                    b2 := this.bodies[j]
                    manifold := detect_collision(b1, b2)
                    if (manifold != null) {
                        resolve_collision(b1, b2, manifold)
                    }
                }
            }
        }
    }
    return this
}

export {
    world: world,
    body: body,
    circle: circle,
    box: box
}
