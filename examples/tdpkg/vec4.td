// vec4 library
import "math"

fn vec4(x, y, z, w) {
    this := {
        x: float(x),
        y: float(y),
        z: float(z),
        w: float(w),

        __print__: fn() {
            return format("vec4(" + "%+v".iblue + ", " + "%+v".iblue + ", " + "%+v".iblue + ", " + "%+v".iblue + ")", this.x, this.y, this.z, this.w)
        },

        set_pos: fn(x, y, z, w) {
            this.x = x
            this.y = y
            this.z = z
            this.w = w
        },

        equal: fn(vec) {
            return this.x == vec.x &&
                   this.y == vec.y &&
                   this.z == vec.z &&
                   this.w == vec.w
        },

        equal_err: fn(vec, sigma) {
            return math.abs(this.x - vec.x) < sigma &&
                   math.abs(this.y - vec.y) < sigma &&
                   math.abs(this.z - vec.z) < sigma &&
                   math.abs(this.w - vec.w) < sigma
        },

        // Resizes the vector to have length l while preserving direction.
        resize: fn(l) {
            return this.norm().scale(l)
        },

        // Returns a normalized copy of the vector.
        norm: fn() {
            len := this.len()
            return vec4(this.x / len, this.y / len, this.z / len, this.w / len)
        },

        copy: fn() {
            return vec4(this.x, this.y, this.z, this.w)
        },

        // A simple "flip" that swaps x and y (leaving z and w unchanged).
        flip: fn() {
            return vec4(this.y, this.x, this.z, this.w)
        },

        sub: fn(vec) {
            return vec4(this.x - vec.x, this.y - vec.y, this.z - vec.z, this.w - vec.w)
        },

        add: fn(vec) {
            return vec4(this.x + vec.x, this.y + vec.y, this.z + vec.z, this.w + vec.w)
        },

        // Rotates the vector in the specified plane by rad radians.
        // 'plane' should be one of: "xy", "xz", "xw", "yz", "yw", "zw"
        rotate_in_plane: fn(plane, rad) {
            cosTheta := math.cos(rad)
            sinTheta := math.sin(rad)
            // Start with current components.
            nx := this.x
            ny := this.y
            nz := this.z
            nw := this.w

            if (plane == "xy") {
                nx = this.x * cosTheta - this.y * sinTheta
                ny = this.x * sinTheta + this.y * cosTheta
            } else if (plane == "xz") {
                nx = this.x * cosTheta - this.z * sinTheta
                nz = this.x * sinTheta + this.z * cosTheta
            } else if (plane == "xw") {
                nx = this.x * cosTheta - this.w * sinTheta
                nw = this.x * sinTheta + this.w * cosTheta
            } else if (plane == "yz") {
                ny = this.y * cosTheta - this.z * sinTheta
                nz = this.y * sinTheta + this.z * cosTheta
            } else if (plane == "yw") {
                ny = this.y * cosTheta - this.w * sinTheta
                nw = this.y * sinTheta + this.w * cosTheta
            } else if (plane == "zw") {
                nz = this.z * cosTheta - this.w * sinTheta
                nw = this.z * sinTheta + this.w * cosTheta
            }
            return vec4(nx, ny, nz, nw)
        },

        // Returns the angle (in radians) between this vector and another vec4,
        // computed via the dot product.
        angle: fn(vec) {
            return math.acos(this.dot(vec) / (this.len() * vec.len()))
        },

        negate: fn() {
            return vec4(-this.x, -this.y, -this.z, -this.w)
        },

        // Dot product.
        dot: fn(vec) {
            return this.x * vec.x + this.y * vec.y + this.z * vec.z + this.w * vec.w
        },

        // Alias for dot product.
        scalar: fn(vec) {
            return this.dot(vec)
        },

        // Returns a vector pointing from this vector to the given vec.
        vec_to: fn(vec) {
            return vec.sub(this)
        },

        // Scales the vector by a factor.
        scale: fn(fac) {
            return vec4(this.x * fac, this.y * fac, this.z * fac, this.w * fac)
        },

        // Computes the Euclidean distance between this vector and another.
        distance: fn(vec) {
            dx := this.x - vec.x
            dy := this.y - vec.y
            dz := this.z - vec.z
            dw := this.w - vec.w
            return math.sqrt(dx * dx + dy * dy + dz * dz + dw * dw)
        },

        // Returns the magnitude (length) of the vector.
        len: fn() {
            return math.sqrt(this.len_sqrt())
        },

        // Returns the squared length of the vector.
        len_sqrt: fn() {
            return this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w
        },

        // Rotates a given point (another vec4) around this vector (used as a center)
        // in the specified plane by rad radians.
        rotate_point_in_plane: fn(point, plane, rad) {
            rel := point.sub(this)
            rotated := rel.rotate_in_plane(plane, rad)
            return this.add(rotated)
        }
    }

    return this
}

export vec4
