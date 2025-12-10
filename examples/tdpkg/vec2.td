import "math"

fn vec2(x, y) {
    this := {
        x: float(x),
        y: float(y),
		__print__: fn(){
			return format("vec2(" + "%+v".iblue + ", " + "%+v".iblue + ")", x, y)
		},
        set_pos: fn(x, y) {
            this.x = x
            this.y = y
        },
        equal: fn(vec) {
            return this.x == vec.x && this.y == vec.y
        },
        equal_err: fn(vec, sigma) {
            return math.abs(this.x - vec.x) < sigma && math.abs(this.y - vec.y) < sigma
        },
        resize: fn(l) {
            return this.norm().scale(l)
        },
        norm: fn() {
            len := this.len()
            return vec2(this.x / len, this.y / len)
        },
        copy: fn() {
            return vec2(this.x, this.y)
        },
        flip: fn() {
            return vec2(this.y, this.x)
        },
        sub: fn(vec) {
            return vec2(this.x - vec.x, this.y - vec.y)
        },
        add: fn(vec) {
            return vec2(this.x + vec.x, this.y + vec.y)
        },
        rotate: fn(rad) {
            cs := math.cos(rad)
            sn := math.sin(rad)
            return vec2(this.x * cs - this.y * sn, this.x * sn + this.y * cs)
        },
        angle: fn(vec) {
            return math.acos(this.scalar(vec) / (this.len() * vec.len()))
        },
        negate: fn() {
            return vec2(-this.x, -this.y)
        },
        cross: fn(vec) {
            return this.x * vec.y - this.y * vec.x
        },
        dot: fn(vec) {
            return this.scalar(vec)
        },
        det: fn(vec) {
            return this.cross(vec)
        },
        full_angle: fn(vec) {
            return math.atan2(this.det(vec), this.dot(vec))
        },
        vec_to: fn(vec) {
            return vec.sub(this)
        },
        scale: fn(fac) {
            return vec2(this.x * fac, this.y * fac)
        },
        scalar: fn(vec) {
            return this.x * vec.x + this.y * vec.y
        },
        distance: fn(vec) {
            dx := this.x - vec.x
            dy := this.y - vec.y
            return math.sqrt(dx * dx + dy * dy)
        },
        len: fn() {
            return math.sqrt(this.len_sqrt())
        },
        len_sqrt: fn() {
            return this.x * this.x + this.y * this.y
        },

        rotate_point_around: fn(vecPoint, rad) {
            rot_vec := this.vec_to(vecPoint)
            rotatedVec := rot_vec.rotate(rad)
            return this.add(rotatedVec)
        }
    }

    return this
}

export vec2
