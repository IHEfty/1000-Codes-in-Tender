import "strings"
import "rand"
import "fmt"

fn stringx(initial) {
	str := initial
	bindings := {}

	this := {
		// INTERNAL ---------------------------------------------------
		_apply: fn() {
			resolved := str
			for key, val in bindings {
				pattern := "${" + key + "}"
				resolved = strings.replace(resolved, pattern, val, -1)
			}
			return resolved
		},

		value: fn() { return this._apply() },
		to_string: fn() { return this._apply() },
		__print__: fn() { return this._apply() },

		// BINDINGS ---------------------------------------------------
		bind: fn(key, value) { bindings[key] = value; return this },
		unbind: fn(key) { if bindings[key] { delete(bindings, key) }; return this },
		clear_bindings: fn() { bindings = {}; return this },

		// REPLACE ----------------------------------------------------
		replace: fn(old, new) { str = strings.replace(str, old, new, -1); return this },
		re_replace: fn(pattern, repl) {
			res := strings.re_replace(pattern, str, repl)
			if is_error(res) { return res }
			str = res
			return this
		},

		// TRANSFORM ---------------------------------------------------
		uppercase: fn() { str = strings.to_upper(this._apply()); return this },
		lowercase: fn() { str = strings.to_lower(this._apply()); return this },
		titlecase: fn() { str = strings.to_title(this._apply()); return this },

		trim: fn(chars) { str = strings.trim(this._apply(), chars); return this },
		trim_space: fn() { str = strings.trim_space(this._apply()); return this },

		pad_left: fn(n, pad) { str = strings.pad_left(this._apply(), n, pad); return this },
		pad_right: fn(n, pad) { str = strings.pad_right(this._apply(), n, pad); return this },

		// QUERIES -----------------------------------------------------
		contains: fn(substr) { return strings.contains(this._apply(), substr) },
		begins_with: fn(prefix) { return strings.has_prefix(this._apply(), prefix) },
		ends_with: fn(suffix) { return strings.has_suffix(this._apply(), suffix) },
		count: fn(substr) { return strings.count(this._apply(), substr) },

		matches: fn(pattern) {
			res := strings.re_match(pattern, this._apply())
			if is_error(res) { return false }
			return res
		},

		is_empty: fn() { return len(this._apply()) == 0 },

		// STRUCTURE ----------------------------------------------------
		split: fn(sep) { return strings.split(this._apply(), sep) },
		re_split: fn(pattern, count) {
			res := strings.re_split(pattern, this._apply(), count)
			if is_error(res) { return null }
			return res
		},

		slice: fn(a, b) { return strings.substr(this._apply(), a, b) },

		// NEW METHODS ---------------------------------------------------

		// Basic
		length: fn() { return len(this._apply()) },
		reverse: fn() {
			s := this._apply()
			out := ""
			for i := len(s)-1; i >= 0; i-- {
				out += s[i]
			}
			str = out
			return this
		},

		repeat: fn(n) {
			tmp := ""
			for i := 0; i < n; i++ { tmp += this._apply() }
			str = tmp
			return this
		},

		shuffle: fn() {
			s := this._apply()
			arr := []
			for ch in s { arr.push(ch) }
			for i := 0; i < len(arr); i++ {
				j := rand.intn(len(arr))
				arr[i] = arr[j]
				arr[j] = arr[i]
			}
			str = strings.join(arr, "")
			return this
		},

		words: fn() {
			return strings.split(strings.trim_space(this._apply()), " ")
		},

		random_char: fn() {
			s := this._apply()
			if len(s) == 0 { return "" }
			return s[rand.intn(len(s))]
		},

		random_word: fn() {
			w := this.words()
			if len(w) == 0 { return "" }
			return w[rand.intn(len(w))]
		},

		ensure_prefix: fn(p) {
			if !strings.has_prefix(this._apply(), p) {
				str = p + this._apply()
			}
			return this
		},

		ensure_suffix: fn(suf) {
			if !strings.has_suffix(this._apply(), suf) {
				str = this._apply() + suf
			}
			return this
		},

		remove_prefix: fn(p) {
			if strings.has_prefix(this._apply(), p) {
				str = strings.substr(this._apply(), len(p), len(this._apply()))
			}
			return this
		},

		remove_suffix: fn(suf) {
			s := this._apply()
			if strings.has_suffix(s, suf) {
				str = strings.substr(s, 0, len(s)-len(suf))
			}
			return this
		},

		indent: fn(n, ch) {
			lines := strings.split(this._apply(), "\n")
			out := ""
			for line in lines { out += strings.repeat(ch, n) + line + "\n" }
			str = strings.trim_suffix(out, "\n")
			return this
		},

		dedent: fn(n) {
			lines := strings.split(this._apply(), "\n")
			out := ""
			for line in lines {
				if strings.has_prefix(line, strings.repeat(" ", n)) {
					out += strings.substr(line, n, len(line)) + "\n"
				} 
				else {
					out += line + "\n"
				}
			}
			str = strings.trim_suffix(out, "\n")
			return this
		},

		collapse_spaces: fn() {
			str = strings.re_replace(" +", this._apply(), " ")
			return this
		},

		// CASE STYLES ---------------------------------------------------
		swapcase: fn() {
			s := this._apply()
			out := ""
			for ch in s {
				if strings.to_upper(ch) == string(ch) {
					out += strings.to_lower(ch)
				} else {
					out += strings.to_upper(ch)
				}
			}
			str = out
			return this
		},

		camel: fn() {
			w := this.words()
			if len(w) == 0 { return this }
			out := strings.to_lower(w[0])
			for i := 1; i < len(w); i++ {
				out += strings.to_title(w[i])
			}
			str = out
			return this
		},

		pascal: fn() {
			w := this.words()
			out := ""
			for x in w { out += strings.to_title(x) }
			str = out
			return this
		},

		snake: fn() {
			w := this.words()
			str = strings.to_lower(strings.join(w, "_"))
			return this
		},

		kebab: fn() {
			w := this.words()
			str = strings.to_lower(strings.join(w, "-"))
			return this
		},

		// FUN METHODS ----------------------------------------------------

		rot: fn(n) { // Caesar Cipher
			s := this._apply()
			out := ""
			for ch in s {
				c := ch
				out += char((int(c - 32 + n) % 95) + 32)
			}
			str = out
			return this
		},

		leet: fn() {
			map := { a:"4", e:"3", i:"1", o:"0", s:"5", t:"7" }
			s := strings.to_lower(this._apply())
			for k, v in map { s = strings.replace(s, k, v, -1) }
			str = s
			return this
		},

		mock: fn() { // SpOnGeBoB TeXt
			s := this._apply()
			out := ""
			toggle := true
			for ch in s {
				out += toggle ? strings.to_upper(ch) : strings.to_lower(ch)
				toggle = !toggle
			}
			str = out
			return this
		},

		owo: fn() {
			s := this._apply()
			s = strings.replace(s, "r", "w", -1)
			s = strings.replace(s, "l", "w", -1)
			str = s + " owo"
			return this
		},

		emojify: fn() {
			s := this._apply()
			out := ""
			for ch in s {
				if ch >= 'a' && ch <= 'z' {
					out += ":regional_indicator_" + ch + ": "
				} 
				else {
					out += ch
				}
			}
			str = out
			return this
		},

		tiny: fn() { // superscript small font
			sup := {
				a:"ᵃ", b:"ᵇ", c:"ᶜ", d:"ᵈ", e:"ᵉ", f:"ᶠ",
				g:"ᵍ", h:"ʰ", i:"ⁱ", j:"ʲ", k:"ᵏ", l:"ˡ",
				m:"ᵐ", n:"ⁿ", o:"ᵒ", p:"ᵖ", r:"ʳ", s:"ˢ",
				t:"ᵗ", u:"ᵘ", v:"ᵛ", w:"ʷ", x:"ˣ", y:"ʸ", z:"ᶻ"
			}
			s := strings.to_lower(this._apply())
			out := ""
			for ch in s {
				if sup[string(ch)] { out += sup[string(ch)] } 
				else { out += ch }
			}
			str = out
			return this
		},

		wide: fn() { // ＦＵＬＬＷＩＤＴＨ
			s := this._apply()
			out := ""
			for ch in s {
				if (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') {
					out += char(ch + 65248)
				}
				else {
					out += ch
				}
			}
			str = out
			return this
		},
		
		// EXPORT --------------------------------------------------------
		raw: fn() { return str },
		get_bindings: fn() { return bindings },
		copy: fn() { return stringx.new(str) }
	}

	return this
}


export stringx
