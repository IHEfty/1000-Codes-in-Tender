import "json"

snapshot := {
    new: fn() {
        history := []

        this := {
            save: fn(state) {
                clone := json.encode(state)  // deep copy
                history.push(json.decode(clone))
                return this
            },
            get: fn(idx) {
                return history[idx] || null
            },
            latest: fn() {
                return history[len(history)-1] || null
            },
            count: fn() { return len(history) },
            diff: fn(a, b) {
                s1 := history[a] || {}
                s2 := history[b] || {}
                diff := {}
                for k, v in s2 {
                    if s1[k] != v { diff[k] = {from: s1[k], to: v} }
                }
                return diff
            },
            clear: fn() { history = []; return this },
            __print__: fn() { return history }
        }

        return this
    }
}


export snapshot