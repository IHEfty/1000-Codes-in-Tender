// vec3 library
import "math"

fn vec3(x, y, z) {
    this := {
        x: float(x),
        y: float(y),
        z: float(z),
        
        __print__: fn(){
            return format("vec3(" + "%+v".iblue + ", " + "%+v".iblue + ", " + "%+v".iblue + ")", this.x, this.y, this.z)
        },
        
        set_pos: fn(x, y, z) {
            this.x = x
            this.y = y
            this.z = z
        },
        
        equal: fn(vec) {
            return this.x == vec.x && this.y == vec.y && this.z == vec.z
        },
        
        equal_err: fn(vec, sigma) {
            return math.abs(this.x - vec.x) < sigma &&
                   math.abs(this.y - vec.y) < sigma &&
                   math.abs(this.z - vec.z) < sigma
        },
        
        // Resizes the vector to have length l (maintaining its direction)
        resize: fn(l) {
            return this.norm().scale(l)
        },
        
        // Returns a normalized copy of this vector
        norm: fn() {
            len := this.len()
            return vec3(this.x / len, this.y / len, this.z / len)
        },
        
        copy: fn() {
            return vec3(this.x, this.y, this.z)
        },
        
        // For 3D, "flip" is ambiguous.
        // Here we swap x and y, leaving z unchanged.
        flip: fn() {
            return vec3(this.y, this.x, this.z)
        },
        
        sub: fn(vec) {
            return vec3(this.x - vec.x, this.y - vec.y, this.z - vec.z)
        },
        
        add: fn(vec) {
            return vec3(this.x + vec.x, this.y + vec.y, this.z + vec.z)
        },
        
        // Rotates this vector around a given (normalized) axis by the angle rad (in radians)
        // using Rodrigues' rotation formula:
        //   v_rot = v*cos(rad) + (axis x v)*sin(rad) + axis*(axis dot v)*(1 - cos(rad))
        rotate_around_axis: fn(axis, rad) {
            cosTheta := math.cos(rad)
            sinTheta := math.sin(rad)
            dotAV := this.dot(axis)
            part1 := this.scale(cosTheta)
            part2 := axis.cross(this).scale(sinTheta)
            part3 := axis.scale(dotAV * (1 - cosTheta))
            return part1.add(part2).add(part3)
        },
        
        // Returns the angle (in radians) between this vector and another vector
        angle: fn(vec) {
            return math.acos(this.dot(vec) / (this.len() * vec.len()))
        },
        
        negate: fn() {
            return vec3(-this.x, -this.y, -this.z)
        },
        
        // Cross product of this vector with another vector
        cross: fn(vec) {
            return vec3(
                this.y * vec.z - this.z * vec.y,
                this.z * vec.x - this.x * vec.z,
                this.x * vec.y - this.y * vec.x
            )
        },
        
        // Dot product of this vector with another vector
        dot: fn(vec) {
            return this.x * vec.x + this.y * vec.y + this.z * vec.z
        },
        
        // Alias for dot product
        scalar: fn(vec) {
            return this.dot(vec)
        },
        
        // Returns a vector pointing from this vector to the given vector
        vec_to: fn(vec) {
            return vec.sub(this)
        },
        
        // Scales this vector by a factor
        scale: fn(fac) {
            return vec3(this.x * fac, this.y * fac, this.z * fac)
        },
        
        // Returns the Euclidean distance between this vector and another vector
        distance: fn(vec) {
            dx := this.x - vec.x
            dy := this.y - vec.y
            dz := this.z - vec.z
            return math.sqrt(dx * dx + dy * dy + dz * dz)
        },
        
        // Returns the length (magnitude) of this vector
        len: fn() {
            return math.sqrt(this.len_sqrt())
        },
        
        // Returns the squared length of this vector
        len_sqrt: fn() {
            return this.x * this.x + this.y * this.y + this.z * this.z
        },
        
        // Rotates a given point around the line defined by this vector (as the center) and the provided axis by rad radians.
        // It first translates the point relative to this vector, rotates it, then translates it back.
        rotate_point_around: fn(point, axis, rad) {
            rel := point.sub(this)
            rotated := rel.rotate_around_axis(axis, rad)
            return this.add(rotated)
        }
    }
    
    return this
}

export vec3
