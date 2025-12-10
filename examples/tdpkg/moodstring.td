import "strings"
import "rand"
import "fmt"

moodstring := fn(initial) {
    raw := initial
    mood := "none"
    custom := {}     // user-defined mood → transform fn

    //-----------------------------------------------------------------
    // Helpers
    //-----------------------------------------------------------------

    zalgo_up := ["̍","̎","̄","̅","̿","̑","̆","̐","͒","͗","͑","̇",
                 "̈","̊","͂","̓","̈","͊","͋","͌","̃","̂","̌","͐",
                 "̀","́","̋","̏","̽","̉","ͣ","ͤ","ͥ","ͦ","ͧ","ͨ",
                 "ͩ","ͪ","ͫ","ͬ","ͭ","ͮ","ͯ","̾","͛","͆","̚"]

    rand_space := fn(s) {
        out := ""
        for ch in s {
            out += ch
            if rand.intn(3) == 0 { out += " " }
        }
        return out
    }

    fullwidth := fn(s) {
        out := ""
        for ch in s { out += string(ch[0] + 65248) }
        return out
    }

    reverse := fn(s) {
        out := ""
        for i := len(s) - 1; i >= 0; i-- { out += s[i] }
        return out
    }

    leet := fn(s) {
        repl := { a:"4", e:"3", i:"1", o:"0", s:"5", t:"7" }
        s = strings.to_lower(s)
        for k, v in repl { s = strings.replace(s, k, v, -1) }
        return s
    }

    zalgo := fn(s) {
        out := ""
        for ch in s {
            out += ch
            n := rand.intn(6) + 1
            for i := 0; i < n; i++ {
                out += zalgo_up[rand.intn(len(zalgo_up))]
            }
        }
        return out
    }

    faded := fn(s) {
        out := ""
        fade := ["͏","͎","͟","͜","͢","̷","̸","̶"]
        for ch in s {
            out += ch
            if rand.intn(2) == 0 { out += fade[rand.intn(len(fade))] }
        }
        return out
    }

    rainbow := fn(s) {
        colors := ["❤️","🧡","💛","💚","💙","💜"]
        out := ""
        idx := 0
        for ch in s {
            out += ch + colors[idx]
            idx = (idx + 1) % len(colors)
        }
        return out
    }

    //-----------------------------------------------------------------
    // Built-in moods
    //-----------------------------------------------------------------

    moods := {
        angry: fn(s) { return strings.to_upper(s) + "!!!" },

        sad: fn(s) { return strings.to_lower(s) + "…" },

        happy: fn(s) { return strings.to_title(s) + " 😊" },

        excited: fn(s) { return strings.to_upper(rand_space(s)) + "!!!" },

        cute: fn(s) {
            s = strings.replace(s, "r", "w", -1)
            s = strings.replace(s, "l", "w", -1)
            return s + " ❤❤"
        },

        serious: fn(s) { return strings.trim_space(s) },

        whisper: fn(s) { return strings.to_lower(s) + "..." },

        robot: fn(s) { return "[" + fullwidth(s) + "]" },

        glitch: fn(s) { return zalgo(s) },

        evil: fn(s) { return reverse(s) + " ☠️" },

        pride: fn(s) { return rainbow(s) },

        question: fn(s) { return s + "???" },

        hacker: fn(s) { return leet(s) + " <00>" },

        ghost: fn(s) { return faded(s) },

        none: fn(s) { return s }
    }

    //-----------------------------------------------------------------
    // Object
    //-----------------------------------------------------------------

    this := {
        mood: fn(m) {
            mood = m
            return this
        },

        getMood: fn() { return mood },

        set: fn(s) {
            raw = s
            return this
        },

        addMood: fn(name, fnRef) {
            custom[name] = fnRef
            return this
        },

        to_string: fn() {
            if custom[mood] {
                return custom[mood](raw)
            }
            if moods[mood] {
                return moods[mood](raw)
            }
            return raw
        },

        __print__: fn() { return this.to_string() }
    }

    return this
}

export moodstring