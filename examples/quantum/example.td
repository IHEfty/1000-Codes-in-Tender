import "quantum" as q

// Example 1 — Create and normalize a qubit
psi := [complex(1, 1), complex(0, 0)]
psi = q.normalize(psi)
q.vec_print(psi)

// Example 2 — Apply a Hadamard gate to |0⟩
state := q.ket0()
H := q.hadamard()
state2 := q.apply_single_qubit(H, state, 1, 0)
q.vec_print(state2)

// Example 3 — Build a Bell state using CNOT/
h := q.hadamard()
Ψ := q.zero_state(2)
Ψ = q.apply_single_qubit(h, Ψ, 2, 0)
Ψ = q.apply_cnot(Ψ, 2, 0, 1)
q.vec_print(Ψ)

// Example 4 — Measure a 2-qubit Bell state
r := 0.6 // random number in [0,1)
m := q.sample_measure_with_r(Ψ, r)
println("Outcome:", m.outcome)
q.vec_print(m.collapsed)

// Example 5 — Compute expectation ⟨ψ|Z|ψ⟩
Z := q.pauliZ()
val := q.expectation(q.ket0(), Z)
println(val)

// Example 6 — Quantum Fourier Transform (QFT)
state = q.basis_state(2, 1)
q.vec_print(state)
state2 = q.apply_qft(state, 2)
q.vec_print(state2)

// Example 7 — Grover diffusion operator
G := q.grover_diffusion(2)
println("Grover matrix:")
for row in G { 
	println(row) 
}

// Example 8 — Density matrix and partial trace
Ψ = q.bell_state(0)
ρ := q.density_from_state(Ψ)
reduced := q.partial_trace_one(ρ, 2, 1)
println("Reduced ρ:")
for row in reduced { 
	println(row) 
}



// Example 9 — Add noise (bit-flip, depolarizing)
rho := q.density_from_state(q.ket0())
rho2 := q.bit_flip_channel(rho, 0.1)
rho3 := q.depolarizing(rho, 0.2)
println("After bit-flip:", rho2)
println("After depolarizing:", rho3)

// Example 10 — Build a small quantum circuit
spec := [
    {U: q.hadamard(), targets: [0]},
    {type: "controlled", U: q.pauliX(), ctrl: 0, targ: 1}
]
U := q.apply_circuit_unitary(2, spec)
println("Circuit matrix:", U)

// Example 11 — Fidelity between two states
a := q.hadamard()
psi = q.ket0()
phi := q.apply_single_qubit(a, psi, 1, 0)
fid := q.fidelity_pure(psi, phi)
println("Fidelity =", fid)
