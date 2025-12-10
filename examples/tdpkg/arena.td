import "fmt"
import "json"

fn arena() {
    vars := {}           // sandbox variables
    env  := {}           // custom environment overrides
    stack := []          // nested contexts

    clone := fn(v) {
        // deep clone using json encode/decode
        enc := json.encode(v)
        return json.decode(enc)
    }

    this := {

        // BASIC ---------------------------------------------------

        add: fn(name, value) {
            vars[name] = clone(value)
            return this
        },

        get: fn(name) {
            return vars[name]
        },

        set: fn(name, value) {
            vars[name] = clone(value)
            return this
        },

        delete: fn(name) {
            if vars[name] { delete(vars, name) }
            return this
        },

        clear: fn() { vars = {}; return this },

        // ENVIRONMENT ---------------------------------------------

        setRule: fn(key, val) { env[key] = val; return this },
        rule:    fn(key) { return env[key] },

        clearRules: fn() { env = {}; return this },

        // SNAPSHOT -------------------------------------------------

        snapshot: fn() {
            return {
                vars: clone(vars),
                env:  clone(env)
            }
        },

        restore: fn(s) {
            vars = clone(s.vars)
            env  = clone(s.env)
            return this
        },

        // EXECUTION -----------------------------------------------

        run: fn(fnblock) {
            snap := this.snapshot()
			stack.push(snap)

            result := null
            err := null

            // custom rule: before hook
            if env["before"] { env["before"]() }

            res := fn() {
                // build execution context
                ctx := {}

                // mirror variables into context
                for k,v in vars { ctx[k] = v }

                // execution inside arena
                out := fnblock(ctx)

                // commit changes back
                for k,v in ctx { vars[k] = v }

                return out
            }()

            if is_error(res) {
                // custom rule: onError
                if env["onError"] {
                    env["onError"](res)
                }
                // rollback
                this.restore(snap)
                err = res
            } else {
                result = res
            }

            // custom rule: after hook
            if env["after"] { env["after"](result) }

            stack.pop()
            return err ? err : result
        },

        // IMPORT / EXPORT ------------------------------------------

        imp: fn(map) {
            for k,v in map {
                vars[k] = clone(v)
            }
            return this
        },

        exp: fn() {
            out := {}
            for k,v in vars { out[k] = clone(v) }
            return out
        },

        // NESTING ---------------------------------------------------

        subarena: fn() {
            return arena().imp(vars)
        },

        // UTILS -----------------------------------------------------

        keys: fn() {
            out := []
            for k in vars { out.push(k) }
            return out
        },

        __print__: fn() {
            return "[arena vars=" + fmt.sprintf("%v", vars) + "]"
        }
    }

    return this
}

export arena
