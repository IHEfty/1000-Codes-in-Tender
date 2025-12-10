import "bufio"
import "strings"
import "crypto" as φ
import "io"
import "json" as Π
import "base64" as ω
import "times" as T

Δ := "Δ_.td"
SPLIT := string(ω.decode("Ly8lZGF0YSU="))


//%data%
Γ := {
    "0a538a0ca54a9f51fc1334040fb89d64": {
        "n": "",
        "t": 1764825296135,
        "e": "1GC9kCyXKJuAMLNkDyvijA=="
    },
    "e32e3e7ae1afd593ef4686c73aabc572": {
        "n": "y",
        "t": 1764825145440,
        "e": "aqndzchZOLNCJBGOT2kZyWA="
    },
    "415290769594460e2e485922904f345d": {
        "t": 1764825288725,
        "e": "EnaoyDuI3mE/SxQGFa3XLqs=",
        "n": "y"
    }
}
//%data%


fn input(t) {
	sysout t
	return strings.trim_space(bufio.readline())
}

for {
	h := φ.md5(input("CHECK: ".igreen))
	if Γ[h] != null {
		sysout h.on_green
		sysout " EXISTS!".green
		if Γ[h].t != null {
			t := T.unix(Γ[h].t/1000, Γ[h].t%1000&int(1e6))
			sysout " [" + string(t).yellow + "] "
		}
		println()
		if Γ[h].n != "" {
			println(Γ[h].n)
		}
		if Γ[h].e != "" {
			println(Γ[h].e)
		}
	}
	else {
		sysout h.on_red
		sysout " NOT EXISTS!\n".red
		I := input("Do you wanna store this? [Y/YES/YEAH/HELL YEAH/WOOH/MAYBE] ".iyellow)
		I = strings.to_upper(I)
		if I == "Y" || I == "YES" || I == "YEAH" || I == "HELL YEAH" || I == "WOOH" || I == "MAYBE" {
			sysout h.purple
			I := input(" [TYPE NOTES] ".iwhite)
			input("Sure? ")
			dta := io.readfile(Δ)
			τ := strings.split(dta, SPLIT)
			Γ[h] = {
				n: I,
				t: T.time_unix_nano(T.now()) / T.millisecond,
				e: φ.aes.encrypt(I, φ.md5(I))
			}
			τ[1] = "\nΓ := " + string(Π.indent(Π.encode(Γ), "", "    ")) + "\n"
			dta_neo := strings.join(τ, SPLIT)
			io.writefile(Δ, dta_neo)
			println("Done!", h + "=" + I)
		}
	}
}
