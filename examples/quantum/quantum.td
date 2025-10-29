import "cmplx"
import "math"
import "fmt"

// Return a zero vector of length n (complex zeros)
zero_vec := fn(n) {
    v := []
    for i := 0; i < n; i++ {
        v = append(v, complex(0, 0))
    }
    return v
}

// Return identity matrix size n (array of rows)
identity := fn(n) {
    I := []
    for i := 0; i < n; i++ {
        row := []
        for j := 0; j < n; j++ {
            if i == j {
                row = append(row, complex(1, 0))
            } else {
                row = append(row, complex(0, 0))
            }
        }
        I = append(I, row)
    }
    return I
}

// Deep copy vector or matrix (works for arrays)
deep_copy := fn(x) {
    // naive copy for arrays of arrays or arrays of scalars
    if typeof(x) == "map" { return x } // maps not expected here
    cpy := []
    for _, v in x {
        if typeof(v) == "array" {
            row := []
            for _, w in v { row = append(row, w) }
            cpy = append(cpy, row)
        } else {
            cpy = append(cpy, v)
        }
    }
    return cpy
}

// ----------------------------- Vector / Matrix ops -----------------------------

// Normalize a state vector in-place and return normalized vector
normalize := fn(vec) {
    sum := 0.0
    for _, a in vec {
        // cmplx.abs returns magnitude
        mag := cmplx.abs(a)
        sum += mag * mag
    }
    if sum == 0 {
        return vec
    }
    norm := math.sqrt(sum)
    out := []
    for _, a in vec {
        out = append(out, complex(a.real / norm, a.imag / norm))
    }
    return out
}

// Inner product <v|w> (conjugate first)
inner := fn(v, w) {
    s := complex(0, 0)
    for i := 0; i < len(v); i++ {
        // conj(v[i]) * w[i]
        conj := cmplx.conj(v[i])
        prod := (conj * w[i])
        s = (s + prod)
    }
    return s
}

// Outer product |v><w| -> matrix
outer := fn(v, w) {
    M := []
    for i := 0; i < len(v); i++ {
        row := []
        for j := 0; j < len(w); j++ {
            row = append(row, (v[i] * cmplx.conj(w[j])))
        }
        M = append(M, row)
    }
    return M
}

// Matrix multiplication A * B (A: m x n, B: n x p)
mat_mul := fn(A, B) {
    m := len(A)
    n := len(A[0])
    // columns of B
    p := len(B[0])
    C := []
    for i := 0; i < m; i++ {
        row := []
        for j := 0; j < p; j++ {
            s := complex(0, 0)
            for k := 0; k < n; k++ {
                s = (s + (A[i][k] * B[k][j]))
            }
            row = append(row, s)
        }
        C = append(C, row)
    }
    return C
}

// Matrix-vector multiply
mat_vec := fn(M, v) {
    out := []
    for i := 0; i < len(M); i++ {
        s := complex(0, 0)
        for j := 0; j < len(v); j++ {
            s = s + (M[i][j] * v[j])
        }
        out = append(out, s)
    }
    return out
}

// Conjugate transpose (Hermitian adjoint)
dagger := fn(M) {
    r := len(M)
    c_ := len(M[0])
    T := []
    for j := 0; j < c_; j++ {
        row := []
        for i := 0; i < r; i++ {
            row = append(row, cmplx.conj(M[i][j]))
        }
        T = append(T, row)
    }
    return T
}

// Scalar multiply matrix
mat_scale := fn(M, s) {
    out := []
    for _, row in M {
        r2 := []
        for _, v in row {
            r2 = append(r2, (v * s))
        }
        out = append(out, r2)
    }
    return out
}

// Tensor (Kronecker) product of two matrices or vectors
// If inputs are vectors (1-D arrays of complex), treat as column vectors and return vector result
kron := fn(A, B) {
    // detect vector vs matrix by checking first element type
    if typeof(A[0]) != "array" && typeof(B[0]) != "array" {
        // vector kron vector -> vector
        out := []
        for _, a in A {
            for _, b in B {
                out = append(out, a*b)
            }
        }
        return out
    }
    // else treat as matrices
    Ar := len(A)
    Ac := len(A[0])
    Br := len(B)
    Bc := len(B[0])
    out := []
    for i := 0; i < Ar; i++ {
        for ii := 0; ii < Br; ii++ {
            row := []
            for j := 0; j < Ac; j++ {
                for jj := 0; jj < Bc; jj++ {
					row = append(row, A[i][j]*B[ii][jj])
                }
            }
            out = append(out, row)
        }
    }
    return out
}

// Build full tensor product of list of matrices or vectors
tensor_all := fn(list) {
    out := list[0]
    for i := 1; i < len(list); i++ {
        out = kron(out, list[i])
    }
    return out
}

// ----------------------------- State constructors -----------------------------

// single-qubit computational basis kets
ket0 := fn() { return [complex(1, 0), complex(0, 0)] }
ket1 := fn() { return [complex(0, 0), complex(1, 0)] }

// n-qubit zero state |0...0>
zero_state := fn(n) {
    s := ket0()
    for i := 1; i < n; i++ {
        s = kron(s, ket0())
    }
    return s
}

// basis state with integer index (0..2^n-1) for n qubits
basis_state := fn(n, idx) {
    size := 1 << n
    v := zero_vec(size)
    v[idx] = complex(1, 0)
    return v
}

// Bell state helpers (4 states)
bell_state := fn(which) {
    // which: 0..3
    // |Φ+> = (|00> + |11>)/sqrt(2)
    // |Φ-> = (|00> - |11>)/sqrt(2)
    // |Ψ+> = (|01> + |10>)/sqrt(2)
    // |Ψ-> = (|01> - |10>)/sqrt(2)
    a := zero_vec(4)
    sqrt2 := math.sqrt(2)
    if which == 0 {
        a[0] = complex(1/sqrt2, 0)
        a[3] = complex(1/sqrt2, 0)
    } else if which == 1 {
        a[0] = complex(1/sqrt2, 0)
        a[3] = complex(-1/sqrt2, 0)
    } else if which == 2 {
        a[1] = complex(1/sqrt2, 0)
        a[2] = complex(1/sqrt2, 0)
    } else {
        a[1] = complex(1/sqrt2, 0)
        a[2] = complex(-1/sqrt2, 0)
    }
    return a
}

// ----------------------------- Basic gates (1-qubit) -----------------------------

// Return 2x2 matrix
pauliX := fn() { return [[complex(0,0), complex(1,0)], [complex(1,0), complex(0,0)]] }
pauliY := fn() { return [[complex(0,0), complex(0,-1)], [complex(0,1), complex(0,0)]] }
pauliZ := fn() { return [[complex(1,0), complex(0,0)], [complex(0,0), complex(-1,0)]] }
hadamard := fn() {
    inv := complex(1 / math.sqrt(2), 0)
	return [[inv, inv], [inv, inv*complex(-1, 0)]]
}
phaseS := fn() { return [[complex(1,0), complex(0,0)], [complex(0,0), complex(0,1)]] } // S = diag(1, i)
phaseT := fn() { t := cmplx.exp(complex(0, math.pi/4)); return [[complex(1,0), complex(0,0)], [complex(0,0), t]] } // T gate

// Rotation gates (angle in radians)
rx := fn(theta) {
    ct := math.cos(theta/2)
    st := math.sin(theta/2)
    return [[complex(ct,0), (complex(0,-1) * complex(st,0))], [(complex(0,-1) * complex(st,0)), complex(ct,0)]]
}
ry := fn(theta) {
    ct := math.cos(theta/2)
    st := math.sin(theta/2)
    return [[complex(ct,0), complex(-st,0)], [complex(st,0), complex(ct,0)]]
}
rz := fn(theta) {
    return [[cmplx.exp(complex(0, -theta/2)), complex(0,0)], [complex(0,0), cmplx.exp(complex(0, theta/2))]]
}
phase := fn(phi) { return [[complex(1,0), complex(0,0)], [complex(0,0), cmplx.exp(complex(0, phi))]] }

// ----------------------------- Multi-qubit / controlled gates -----------------------------

// 2-qubit CNOT (control=qubit 0, target=qubit 1) as matrix
cnot_2 := fn() {
    // ordering: 00,01,10,11
    return [
        [complex(1,0), complex(0,0), complex(0,0), complex(0,0)],
        [complex(0,0), complex(1,0), complex(0,0), complex(0,0)],
        [complex(0,0), complex(0,0), complex(0,0), complex(1,0)],
        [complex(0,0), complex(0,0), complex(1,0), complex(0,0)]
    ]
}
cz_2 := fn() {
    return [
        [complex(1,0), complex(0,0), complex(0,0), complex(0,0)],
        [complex(0,0), complex(1,0), complex(0,0), complex(0,0)],
        [complex(0,0), complex(0,0), complex(1,0), complex(0,0)],
        [complex(0,0), complex(0,0), complex(0,0), complex(-1,0)]
    ]
}
swap_2 := fn() {
    return [
        [complex(1,0), complex(0,0), complex(0,0), complex(0,0)],
        [complex(0,0), complex(0,0), complex(1,0), complex(0,0)],
        [complex(0,0), complex(1,0), complex(0,0), complex(0,0)],
        [complex(0,0), complex(0,0), complex(0,0), complex(1,0)]
    ]
}

// build controlled-U for single-qubit U placed on target qubit, with control qubit index ctrl (0..n-1)
// n: total qubits, ctrl: index of control, targ: index of target
controlled_unitary := fn(U, n, ctrl, targ) {
    // Build by expanding projectors: |0><0|_ctrl ⊗ I_rest + |1><1|_ctrl ⊗ U_on_target
    // We'll construct by tensoring factors in proper order
    // helper projectors
    P0 := [[complex(1,0), complex(0,0)], [complex(0,0), complex(0,0)]]
    P1 := [[complex(0,0), complex(0,0)], [complex(0,0), complex(1,0)]]
    // function to place an operator at position pos (0..n-1) and identities elsewhere
    place := fn(op, pos) {
        parts := []
        for q := 0; q < n; q++ {
            if q == pos {
                parts = append(parts, op)
            } else {
                parts = append(parts, identity(2))
            }
        }
        return tensor_all(parts)
    }
    // build first term: P0 on ctrl, I on target (rest identities)
    term0_parts := []
    for q := 0; q < n; q++ {
        if q == ctrl {
            term0_parts = append(term0_parts, P0)
        } else {
            term0_parts = append(term0_parts, identity(2))
        }
    }
    term0 := tensor_all(term0_parts)
    // build second term: P1 on ctrl and U on target
    term1_parts := []
    for q := 0; q < n; q++ {
        if q == ctrl {
            term1_parts = append(term1_parts, P1)
        } else if q == targ {
            term1_parts = append(term1_parts, U)
        } else {
            term1_parts = append(term1_parts, identity(2))
        }
    }
    term1 := tensor_all(term1_parts)
    // sum term0 + term1
    // matrix addition
    sum := []
    for i := 0; i < len(term0); i++ {
        row := []
        for j := 0; j < len(term0[0]); j++ {
            row = append(row, (term0[i][j] + term1[i][j]))
        }
        sum = append(sum, row)
    }
    return sum
}

// Build a full n-qubit unitary that applies a single-qubit gate `G` to qubit index `pos` (0..n-1)
embed_single_qubit := fn(G, n, pos) {
    parts := []
    for q := 0; q < n; q++ {
        if q == pos {
            parts = append(parts, G)
        } else {
            parts = append(parts, identity(2))
        }
    }
    return tensor_all(parts)
}

// Build full unitary from list of (gate, targets) applied sequentially by multiplying unitaries
// gates_spec: array of {U: matrix, targets: [indices], control: optional}
apply_circuit_unitary := fn(n, gates_spec) {
    U := identity(1 << n) // start as identity, but our identity builder expects size; so create by tensor of identities:
    // build identity by tensoring n identity(2)
    ids := []
    for i := 0; i < n; i++ { ids = append(ids, identity(2)) }
    U = tensor_all(ids)
    // apply gates from left (first applied) or right? we'll apply as left-multiply on state (U_total = U_k ... U_2 U_1)
    for gspec in gates_spec {
        Ugate := gspec.U
        // if gate is specified for single qubit via targets
        if gspec.targets != null && len(gspec.targets) == 1 {
            Ufull := embed_single_qubit(Ugate, n, gspec.targets[0])
            U = mat_mul(Ufull, U)
        } else if gspec.type == "controlled" {
            // expecting Ugate (single-qubit) with ctrl and targ
            ctrl := gspec.ctrl
            targ := gspec.targ
            Ufull := controlled_unitary(Ugate, n, ctrl, targ)
            U = mat_mul(Ufull, U)
        } else {
            // else assume Ugate already full size
            U = mat_mul(Ugate, U)
        }
    }
    return U
}

// ----------------------------- State evolution helpers -----------------------------

// Apply a full matrix U to state vector (U must be 2^n x 2^n)
apply_unitary := fn(U, state) {
    return mat_vec(U, state)
}

// Apply a single-qubit gate G to qubit pos in n-qubit state (construct embed and apply)
apply_single_qubit := fn(G, state, n, pos) {
    U := embed_single_qubit(G, n, pos)
    return apply_unitary(U, state)
}

// Apply CNOT with control ctrl and target targ (n total qubits)
apply_cnot := fn(state, n, ctrl, targ) {
    U := controlled_unitary(pauliX(), n, ctrl, targ)
    return apply_unitary(U, state)
}

// ----------------------------- Measurement -----------------------------

// Return probability distribution array for state vector (length 2^n)
probs_from_state := fn(state) {
    p := []
    for _, a in state { p = append(p, cmplx.abs(a) * cmplx.abs(a)) }
    return p
}

// Collapse state to basis outcome index (0..2^n-1), returns normalized collapsed state
collapse_to := fn(state, idx) {
    size := len(state)
    s := complex(0, 0)
    for i := 0; i < size; i++ {
        s = (s + (cmplx.conj(state[i]) * state[i]))
    }
    // but we only need norm of chosen amplitude
    amp := state[idx]
    prob := cmplx.abs(amp) * cmplx.abs(amp)
    if prob == 0 {
        // cannot collapse to zero-probability outcome; return same state
        return state
    }
    norm := math.sqrt(prob)
    out := []
    for i := 0; i < size; i++ {
        if i == idx {
            out = append(out, complex(state[i].real / norm, state[i].imag / norm))
        } else {
            out = append(out, complex(0, 0))
        }
    }
    return out
}

// Sample measurement using a provided random number r in [0,1).
// This avoids depending on a specific global RNG.
// Returns {outcome: int, probs: array, collapsed_state: array}
sample_measure_with_r := fn(state, r) {
    p := probs_from_state(state)
    cum := 0.0
    chosen := 0
    for i := 0; i < len(p); i++ {
        cum += p[i]
        if r < cum {
            chosen = i
            break
        }
    }
    collapsed := collapse_to(state, chosen)
    return {outcome: chosen, probs: p, collapsed: collapsed}
}

// Compute expectation value <psi|O|psi> where O is matrix
expectation := fn(state, O) {
    // compute O|psi>
    psi2 := mat_vec(O, state)
    val := inner(state, psi2)
    return val
}

// ----------------------------- Density matrices & partial trace -----------------------------

// Convert pure state vector to density matrix |psi><psi|
density_from_state := fn(state) {
    return outer(state, state)
}

// Partial trace over a single qubit (trace out qubit index `tr`), for n total qubits
partial_trace_one := fn(rho, n, tr) {
    // rho is 2^n x 2^n matrix
    dim := 1 << n
    out_dim := 1 << (n-1)
    // initialize zero matrix out_dim x out_dim
    out := []
    for i := 0; i < out_dim; i++ {
        row := []
        for j := 0; j < out_dim; j++ {
            row = append(row, complex(0,0))
        }
        out = append(out, row)
    }
    // mapping indices: expand each index into n-bit binary; skip traced qubit bits
    for i := 0; i < dim; i++ {
        for j := 0; j < dim; j++ {
            // get bits at tr position for i and j
            bit_i := (i >> (n - 1 - tr)) & 1
            bit_j := (j >> (n - 1 - tr)) & 1
            if bit_i == bit_j {
                // compute reduced indices by removing that bit
                // build new index by compressing bits
                idx_i := 0
                idx_j := 0
                ii := 0
                for b := 0; b < n; b++ {
                    if b == tr { continue }
                    idx_i = (idx_i << 1) | ((i >> (n - 1 - b)) & 1)
                    idx_j = (idx_j << 1) | ((j >> (n - 1 - b)) & 1)
                    ii++
                }
                out[idx_i][idx_j] = (out[idx_i][idx_j] + rho[i][j])
            }
        }
    }
    return out
}

// Fidelity between two pure states |psi>, |phi> (returns real number)
fidelity_pure := fn(psi, phi) {
    s := inner(psi, phi)
    // fidelity = |<psi|phi>|^2
    mag := cmplx.abs(s)
    return mag * mag
}

// ----------------------------- Common algorithms -----------------------------

// QFT on n qubits: returns unitary matrix (2^n x 2^n)
qft_unitary := fn(n) {
    N := 1 << n
    U := []
    omega := cmplx.exp(complex(0, 2 * math.pi / N))
    inv_sqrt := complex(1 / math.sqrt(N), 0)
    for a := 0; a < N; a++ {
        row := []
        for b := 0; b < N; b++ {
            // omega^(a*b)
            exp := cmplx.pow(omega, complex(a * b, 0))
            row = append(row, (inv_sqrt * exp))
        }
        U = append(U, row)
    }
    return U
}

// Apply QFT to state (return state vector)
apply_qft := fn(state, n) {
    U := qft_unitary(n)
    return apply_unitary(U, state)
}

// Inverse QFT is conjugate transpose of QFT unitary
apply_inv_qft := fn(state, n) {
    U := qft_unitary(n)
    Udag := dagger(U)
    return apply_unitary(Udag, state)
}

// Create Grover diffusion operator for n qubits (about mean)
grover_diffusion := fn(n) {
    N := 1 << n
    // matrix with 2/N everywhere minus I
    two_over_N := complex(2.0 / N, 0)
    M := []
    for i := 0; i < N; i++ {
        row := []
        for j := 0; j < N; j++ {
            val := two_over_N
            if i == j {
                val = (val + complex(-1, 0))
            }
            row = append(row, val)
        }
        M = append(M, row)
    }
    return M
}

// ----------------------------- Basic noise channels (Kraus style) -----------------------------

// Bit-flip channel with probability p applied to single-qubit density matrix rho (2x2)
bit_flip_channel := fn(rho, p) {
    X := pauliX()
    // Convert probabilities
    p_c := p
    // rho' = (1-p) rho + p X rho X
    term1 := mat_scale(rho, complex(1-p_c, 0))
    Xrho := mat_mul(X, mat_mul(rho, X))
    term2 := mat_scale(Xrho, complex(p_c, 0))
    // matrix addition
    out := []
    for i := 0; i < len(rho); i++ {
        row := []
        for j := 0; j < len(rho[0]); j++ {
            row = append(row, (term1[i][j] + term2[i][j]))
        }
        out = append(out, row)
    }
    return out
}

// Depolarizing channel for single qubit with probability p: rho' = (1-p) rho + p * I/2
depolarizing := fn(rho, p) {
    I := identity(2)
    half := complex(1/2, 0)
    term1 := mat_scale(rho, complex(1-p, 0))
    term2 := mat_scale(I, complex(p, 0))
    term2 = mat_scale(term2, half)
    out := []
    for i := 0; i < len(rho); i++ {
        row := []
        for j := 0; j < len(rho[0]); j++ {
            row = append(row, (term1[i][j] + term2[i][j]))
        }
        out = append(out, row)
    }
    return out
}

// ----------------------------- Utilities / debug -----------------------------

// Pretty-print a complex vector (small)
vec_print := fn(v) {
    s := "["
    for i := 0; i < len(v); i++ {
        a := v[i]
        s += fmt.sprintf("(%f%+fi)", a.real, a.imag)
        if i < len(v)-1 { s += ", " }
    }
    s += "]"
    println(s)
}


export {
	// Linear algebra and utils
	zero_vec: zero_vec,
	identity: identity,
	deep_copy: deep_copy,
	normalize: normalize,
	inner: inner,
	outer: outer,
	mat_mul: mat_mul,
	mat_vec: mat_vec,
	dagger: dagger,
	mat_scale: mat_scale,
	kron: kron,
	tensor_all: tensor_all,

	// States
	ket0: ket0,
	ket1: ket1,
	zero_state: zero_state,
	basis_state: basis_state,
	bell_state: bell_state,

	// Gates (1-qubit)
	pauliX: pauliX,
	pauliY: pauliY,
	pauliZ: pauliZ,
	hadamard: hadamard,
	phaseS: phaseS,
	phaseT: phaseT,
	rx: rx,
	ry: ry,
	rz: rz,
	phase: phase,

	// Multi-qubit & controlled gates
	cnot_2: cnot_2,
	cz_2: cz_2,
	swap_2: swap_2,
	controlled_unitary: controlled_unitary,
	embed_single_qubit: embed_single_qubit,
	apply_circuit_unitary: apply_circuit_unitary,

	// State evolution
	apply_unitary: apply_unitary,
	apply_single_qubit: apply_single_qubit,
	apply_cnot: apply_cnot,

	// Measurement
	probs_from_state: probs_from_state,
	collapse_to: collapse_to,
	sample_measure_with_r: sample_measure_with_r,
	expectation: expectation,

	// Density matrices & operations
	density_from_state: density_from_state,
	partial_trace_one: partial_trace_one,
	fidelity_pure: fidelity_pure,

	// Algorithms
	qft_unitary: qft_unitary,
	apply_qft: apply_qft,
	apply_inv_qft: apply_inv_qft,
	grover_diffusion: grover_diffusion,

	// Noise channels
	bit_flip_channel: bit_flip_channel,
	depolarizing: depolarizing,
	
	// Pauli Matrices
	pauliX: pauliX,
	pauliY: pauliY,
	pauliZ: pauliZ,

	// Utilities
	vec_print: vec_print
}

