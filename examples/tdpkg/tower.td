// Tower Data Type
import "strings"

tower := fn() {
    layers := []

    this := {
        push: fn(value) {
            layers = append(layers, value)
            return this
        },

        pop: fn() {
            if len(layers) == 0 {
                return error("Tower is empty!")
            }
            top := layers[len(layers)-1]
            layers = layers[0:len(layers)-1]
            return top
        },

        peek: fn() {
            if len(layers) == 0 {
                return error("Tower is empty!")
            }
            return layers[len(layers)-1]
        },

        size: fn() {
            return len(layers)
        },

        is_empty: fn() {
            return len(layers) == 0
        },

        // Merge all layers into one using optional merge function
        collapse: fn(mergeFn) {
            if len(layers) == 0 {
                return error("Tower is empty!")
            }

            result := layers[0]

            if mergeFn {
                // Use user-provided merge function
                for i := 1; i < len(layers); i++ {
                    result = mergeFn(result, layers[i])
                }
            }
            else {
                // Default: overwrite layers (last wins)
                for v in layers {
                    result = v
                }
            }

            layers = [result]
            return result
        },

        // Climb upward through layers, returning array of values
        climb: fn() {
            return layers
        },

        // Merge another tower into this one (layer by layer)
        merge: fn(other) {
            if is_map(other) && other.is_tower && other.is_tower() {
                for v in other.get_layers() {
                    layers = append(layers, v)
                }
                return this
            }
            return error("Expected Tower!")
        },

        get_layers: fn() {
            return layers
        },

        is_tower: fn() {
            return true
        },

        __print__: fn() {
            println("<tower " + strings.join(layers, " ") + " >")
        }
    }

    return this
}


export tower