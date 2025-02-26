// 2D Physics Engine

import "math"
import "vec2"

// --- SHAPES ---

// A simple circle shape.
fn circle(radius) {
    this := {
        type: "circle",
        radius: float(radius)
    }
    return this
}

// A placeholder for a box shape.
// (Collision for boxes is not implemented here.)
fn box(half_width, half_height) {
    this := {
        type: "box",
        half_width: float(half_width),
        half_height: float(half_height)
    }
    return this
}

// --- COLLISION DETECTION & RESOLUTION ---

// Currently, we only implement collision detection for circle vs circle.
// Returns a "manifold" (an object with penetration depth, collision normal,
// and a contact point) or null if there is no collision.
fn detect_collision(b1, b2) {
    if (b1.shape.type == "circle" && b2.shape.type == "circle") {
        normal := null
        contact_point := null
        n := b2.position.sub(b1.position)
        dist := n.len()
        r := b1.shape.radius + b2.shape.radius
        if (dist < r) {
            penetration := r - dist
            if (dist > 0) {
                normal = n.scale(1 / dist)
            } else {
                normal = vec2(1, 0)
            }
            contact_point = b1.position.add(normal.scale(b1.shape.radius))
            return { penetration: penetration, normal: normal, contact_point: contact_point }
        }
    }
    // (Additional collision detection for boxes or mixed shapes can be added here.)
    return null
}

// Resolves a collision using an impulse-based method.
fn resolve_collision(b1, b2, manifold) {
    // Use the lower restitution ("bounciness") of the two bodies.
    restitution := math.min(b1.restitution, b2.restitution)

    // Compute the relative velocity along the collision normal.
    rv := b2.velocity.sub(b1.velocity)
    vel_along_normal := rv.dot(manifold.normal)

    // Do not resolve if bodies are moving apart.
    if (vel_along_normal > 0) {
        return
    }

    // Compute impulse scalar.
    impulse_scalar := -(1 + restitution) * vel_along_normal / (b1.inv_mass + b2.inv_mass)
    impulse := manifold.normal.scale(impulse_scalar)

    // Apply the impulse to each body.
    if (!b1.is_static) {
        b1.velocity = b1.velocity.sub(impulse.scale(b1.inv_mass))
    }
    if (!b2.is_static) {
        b2.velocity = b2.velocity.add(impulse.scale(b2.inv_mass))
    }

    // Positional correction to counteract sinking (reducing numerical error).
    percent := 0.2  // correction factor (20%)
    slop := 0.01    // penetration allowance
    correction_magnitude := math.max(manifold.penetration - slop, 0) / (b1.inv_mass + b2.inv_mass) * percent
    correction := manifold.normal.scale(correction_magnitude)
    if (!b1.is_static) {
        b1.position = b1.position.sub(correction.scale(b1.inv_mass))
    }
    if (!b2.is_static) {
        b2.position = b2.position.add(correction.scale(b2.inv_mass))
    }
}

// --- BODY DEFINITION ---

// A rigid body. Each body has a position, velocity, mass properties,
// and an associated shape.
fn body(position, angle, is_static, shape) {
    // For dynamic bodies, we assign a default mass (1.0).
    mass_value := 1.0
    if (is_static) {
        mass_value = 0.0
    }
    inv_mass_value := 0.0
    if (mass_value != 0.0) {
        inv_mass_value = 1.0 / mass_value
    }
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
        friction: 0.5,
        restitution: 0.2,

        apply_force: fn(f) {
            if (!this.is_static) {
                this.force = this.force.add(f)
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
            for i := 0; i < this.bodies.length; i++ {
                body := this.bodies[i]
                if (!body.is_static) {
                    body.apply_force(this.gravity.scale(body.mass))
                    acceleration := body.force.scale(body.inv_mass)
                    body.velocity = body.velocity.add(acceleration.scale(dt))
                    body.position = body.position.add(body.velocity.scale(dt))
                    body.clear_forces()
                }
            }
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
