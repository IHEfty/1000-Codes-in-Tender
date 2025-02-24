// MIT License

// Copyright (c) 2024 2DPrototype

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

make_array := fn(rows, cols, initial) {
    arr := []
    for i := 0; i < rows; i++ {
        row := []
        for j := 0; j < cols; j++ {
            row = append(row, initial)
		}
        arr = append(arr, row)
	}
    return arr
}


is_matrix := fn(arr) {
	if len(arr) < 1 {
		return false
	}
	l := len(arr[0])
	for i in arr {
		if len(i) != l {
			return false
		}
		for j in i {
			if !(is_int(j) || is_float(j)) {
				return false
			}
		}
	}
	return true
}


det_recursive := fn(mat) {
	if len(mat) == 1 {
		return mat[0][0]
	}
	
	det := 0
	for j, value in mat[0] {
		minor := make_array(len(mat)-1, len(mat[0])-1, 0)
		for i := 1; i < len(mat); i++ {
			for k, v in mat[i] {
				if k < j {
					minor[i-1][k] = v
				}
				else if k > j {
					minor[i-1][k-1] = v
				}
			}
		}
		sign := 1
		if j%2 != 0 {
			sign = -1
		}
		det += sign * value * det_recursive(minor)
	}
	
	return det
}



matrix := fn(A) {
    this := {
		data: A,
		order: fn() {
			return [len(A), len(A[0])]
		},
		add: fn(B) {
			if is_map(B) {
				if is_matrix(B.data) {
					B = B.data
				}
			}
			if is_int(B) || is_float(B) {
				oA := this.order()
				result := make_array(oA[0], oA[1], 0)
				for i := 0; i < len(A); i++ {
					for j := 0; j < len(A[i]); j++ {
						result[i][j] = A[i][j] + B
					}
				}
				return matrix(result)
			}
			else if is_array(B) {
				oB := matrix(B).order()
				oA := this.order()
				
				if oA[0] == oB[0] && oA[1] == oB[1] {
					result := make_array(oA[0], oB[1], 0)
					for i := 0; i < len(A); i++ {
						for j := 0; j < len(A[i]); j++ {
							result[i][j] = A[i][j] + B[i][j]
						}
					}
					return matrix(result)
				} 
				else {
					return error("Invalid order for addition!")
				}
			} 
			else {
				return error("Unsupported type for addition!")
			}
		},
		sub: fn(B) {
			if is_map(B) {
				if is_matrix(B.data) {
					B = B.data
				}
			}			
			if is_int(B) || is_float(B) {
				oA := this.order()
				result := make_array(oA[0], oA[1], 0)
				for i := 0; i < len(A); i++ {
					for j := 0; j < len(A[i]); j++ {
						result[i][j] = A[i][j] - B
					}
				}
				return matrix(result)
			}
			else if is_array(B) {
				oB := matrix(B).order()
				oA := this.order()
				
				if oA[0] == oB[0] && oA[1] == oB[1] {
					result := make_array(oA[0], oB[1], 0)
					for i := 0; i < len(A); i++ {
						for j := 0; j < len(A[i]); j++ {
							result[i][j] = A[i][j] - B[i][j]
						}
					}
					return matrix(result)
				}
				else {
					return error("Invalid order for subtraction!")
				}
			}
			else {
				return error("Unsupported type for subtraction!")
			}
		},
		mul: fn(B) {
			if is_map(B) {
				if is_matrix(B.data) {
					B = B.data
				}
			}
			if is_int(B) || is_float(B) {
				for i := 0; i < len(A); i++ {
					for j := 0; j < len(A[i]); j++ {
						A[i][j] *= B
					}
				}
			} 
			else if is_array(B) {
				oB := matrix(B).order()
				oA := this.order()
				
				if oA[1] == oB[0] {
					result := make_array(oA[0], oB[1], 0)
					
					for i := 0; i < oA[0]; i++ {
						for j := 0; j < oB[1]; j++ {
							sum := 0
							for k := 0; k < oA[1]; k++ {
								sum += A[i][k] * B[k][j]
							}
							result[i][j] = sum
						}
					}
					return matrix(result)
				} 
				else {
					return error("Invalid dimensions for multiplication!")
				}
			} 
			else {
				return error("Unsupported type for multiplication!")
			}
		},
		transpose: fn() {
			result := make_array(len(A[0]), len(A), 0)
			for i := 0; i < len(A); i++ {
				for j := 0; j < len(A[i]); j++ {
					result[j][i] = A[i][j]
				}
			}
			return matrix(result)
		},
		__print__: fn() {
			for i := 0; i < len(A); i++ {
				println(A[i])
			}
		},
		scale: fn(scalar) {
			// Scalar multiplication
			if is_int(scalar) || is_float(scalar) {
				result := make_array(len(A), len(A[0]), 0)
				for i := 0; i < len(A); i++ {
					for j := 0; j < len(A[i]); j++ {
						result[i][j] = A[i][j] * scalar
					}
				}
				return matrix(result)
			} 
			else {
				return error("Unsupported type for scaling!")
			}
		},
		det: fn() {
            oA := this.order()
            if oA[0] == oA[1] {
				return det_recursive(A)
			}
			else {
                return error("Determinant calculation requires a square matrix!")
			}
		},
		is_singular: fn() {
            // Check if the matrix is singular (non-invertible)
            return this.determinant() == 0
		},
		is_square: fn() {
            // Check if the matrix is square
            oA := this.order()
            return oA[0] == oA[1]
		},
		is_symmetric: fn() {
            // Check if the matrix is symmetric
            if this.is_square() {
                for i := 0; i < len(A); i++ {
                    for j := i + 1; j < len(A[i]); j++ {
                        if A[i][j] != A[j][i] {
                            return false
						}
					}
				}
				return true
			} 
			else {
                return false
			}
		},
		is_diagonal: fn() {
            // Check if the matrix is diagonal
            if this.is_square() {
                for i := 0; i < len(A); i++ {
                    for j := 0; j < len(A[i]); j++ {
						if i != j && A[i][j] != 0 {
							return false
						}
					}
				}
				return true
			} 
			else {
				return false
			}
		},
		trace: fn() {
            // Calculate the trace of the matrix
            if this.is_square() {
                tr := 0
                for i := 0; i < len(A); i++ {
                    tr += A[i][i]
				}
				return tr
			} 
			else {
                return error("Trace calculation requires a square matrix!")
			}
		},
        is_zero: fn() {
            // Check if all elements in the matrix are zero
            for i := 0; i < len(A); i++ {
                for j := 0; j < len(A[i]); j++ {
                    if A[i][j] != 0 {
                        return false
					}
				}
			}
            return true
		},
        is_identity: fn() {
            // Check if the matrix is an identity matrix
            if this.is_square() {
                for i := 0; i < len(A); i++ {
                    for j := 0; j < len(A[i]); j++ {
                        if i == j && A[i][j] != 1 {
						return false
                        } else if i != j && A[i][j] != 0 {
                            return false
						}
					}
				}
				return true
			} 
			else {
                return false
			}
		},
        is_upper_triangular: fn() {
            // Check if the matrix is upper triangular
            if this.is_square() {
                for i := 1; i < len(A); i++ {
                    for j := 0; j < i; j++ {
                        if A[i][j] != 0 {
                            return false
						}
					}
				}
				return true
			} 
			else {
                return false
			}
		},
        is_lower_triangular: fn() {
            // Check if the matrix is lower triangular
            if this.is_square() {
                for i := 0; i < len(A); i++ {
                    for j := i + 1; j < len(A[i]); j++ {
                        if A[i][j] != 0 {
                            return false
						}
					}
				}
				return true
			} 
			else {
                return false
			}
		},
        is_orthogonal: fn() {
            // Check if the matrix is an orthogonal matrix
            if this.is_square() {
                transpose := this.transpose()
                identity := matrix.make_identity(len(A))
                product := this.mul(transpose)
				return product.is_identity()
			} 
			else {
                return false
			}
		},
        row: fn(rowIdx) {
            // Get a specific row as a new matrix
            if rowIdx >= 0 && rowIdx < len(A) {
                return matrix([A[rowIdx]])
			} 
			else {
                return error("Invalid row index!")
			}
		},
        col: fn(colIdx) {
            // Get a specific column as a new matrix
            if len(A) > 0 && colIdx >= 0 && colIdx < len(A[0]) {
                col := []
                for i := 0; i < len(A); i++ {
                    col = append(col, A[i][colIdx])
				}
                return matrix([col])
			}
			else {
                return error("Invalid column index!")
			}
		},
        submatrix: fn(startRow, endRow, startCol, endCol) {
            // Get a submatrix based on row and column indices
            if startRow >= 0 && startRow < len(A) &&
			endRow >= 0 && endRow < len(A) &&
			startCol >= 0 && startCol < len(A[0]) &&
			endCol >= 0 && endCol < len(A[0]) &&
			startRow <= endRow && startCol <= endCol {
                result := []
                for i := startRow; i <= endRow; i++ {
                    row := []
                    for j := startCol; j <= endCol; j++ {
                        row = append(row, A[i][j])
					}
                    result = append(result, row)
				}
                return matrix(result)
			} 
			else {
                return error("Invalid submatrix indices!")
			}
		},
		is_equal: fn(B) {
			if is_map(B) {
				if is_matrix(B.data) {
					B = B.data
				}
			}
            if is_matrix(B) {
                oB := matrix(B).order()
                if this.order() == oB {
                    for i := 0; i < len(A); i++ {
                        for j := 0; j < len(A[i]); j++ {
                            if A[i][j] != B[i][j] {
                                return false
							}
						}
					}
                    return true
				}
			}
            return false
		},
		to_array : fn() {
			result := []
			for v in this.data {
				result = append(result, v...)
			}
			return result
		}
	}
	return this
}

export {
    new: fn(A) {
        if is_matrix(A) {
			return matrix(A)
		} 
		else {
            return error("Invalid matrix!")
		}
	},
	identity: fn(size) {
		// Create an identity matrix of given size
		result := make_array(size, size, 0)
		for i := 0; i < size; i++ {
			result[i][i] = 1
		}
		return matrix(result)
	},
	from_array : fn(arr, width) {
		rows := []
		currentRow := []
		
		for val in arr {
			currentRow = append(currentRow, val || 0)
			
			if len(currentRow) == width {
				rows = append(rows, currentRow)
				currentRow = []
			}
		}
		
		// Fill the last row with zeros if it's shorter than width
		if len(currentRow) < width && len(currentRow) != 0  {
			currentRow = append(currentRow, make_array(1, width-len(currentRow), 0)[0]...)
			rows = append(rows, currentRow)
		}
		
		return matrix(rows)
	}
}
