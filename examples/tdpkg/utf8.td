fn stringFromCharCode(n) {
	return string(char(n))
}
// Define ucs2decode function
ucs2decode := fn(string) {
    output := []
    counter := 0
    length := len(string)
    value := 0
    extra := 0
	
	for counter < length {
        value := int(char(string[counter]))
		counter++
		if value != null {
			if value >= 0xD800 && value <= 0xDBFF && counter < length - 1 {
				// high surrogate, and there is a next character
				extra := char(string[counter + 1])
				if extra & 0xFC00 == 0xDC00 {
					// low surrogate
					output = append(output, ((value & 0x3FF) << 10) + (extra & 0x3FF) + 0x10000)
					counter := counter + 2
				} 
				else {
					// unmatched surrogate
					output = append(output, value)
					counter := counter + 1
				}
			} 
			else {
				output = append(output, value)
				counter := counter + 1
			}
		}
	}
	
    return output
}

// Define ucs2encode function
ucs2encode := fn(array) {
    length := len(array)
    index := 0
    value := 0
    output := ""
	
    for index < length {
        value := array[index]
        if value > 0xFFFF {
            value := value - 0x10000
            output += stringFromCharCode((value >> 10 & 0x3FF) | 0xD800)
            value = 0xDC00 | (value & 0x3FF)
		}
        output += stringFromCharCode(value)
		index++
	}
	
    return output
}

// Define checkScalarValue function
checkScalarValue := fn(codePoint) {
    if codePoint >= 0xD800 && codePoint <= 0xDFFF {
		println(error("Lone surrogate \"" + string(codePoint) + "\" is not a scalar value"))
	}
}

createByte := fn(codePoint, shift) {
    return stringFromCharCode(((codePoint >> shift) & 0x3F) | 0x80)
}

encodeCodePoint := fn(codePoint) {
    if codePoint & 0xFFFFFF80 == 0 {
        // 1-byte sequence
        return stringFromCharCode(codePoint)
	}
    symbol := ""
    if codePoint & 0xFFFFF800 == 0 {
        // 2-byte sequence
        symbol = stringFromCharCode(((codePoint >> 6) & 0x1F) | 0xC0)
	} 
	else if codePoint & 0xFFFF0000 == 0 {
        // 3-byte sequence
        checkScalarValue(codePoint)
        symbol = stringFromCharCode(((codePoint >> 12) & 0x0F) | 0xE0)
        symbol += createByte(codePoint, 6)
	} 
	else if codePoint & 0xFFE00000 == 0 {
        // 4-byte sequence
        symbol = stringFromCharCode(((codePoint >> 18) & 0x07) | 0xF0)
        symbol += createByte(codePoint, 12)
        symbol += createByte(codePoint, 6)
	}
    symbol += stringFromCharCode((codePoint & 0x3F) | 0x80)
    return symbol
}


fn utf8encode(str) {
	codePoints := ucs2decode(str)
	length := len(codePoints)
	index := 0
	codePoint := 0
	byteString := ""
	for index < length {
		codePoint = codePoints[index]
		byteString += encodeCodePoint(codePoint)
		index++
	}
	return byteString
}

byteArray := []
byteCount := 0
byteIndex := 0

// Define readContinuationByte function
readContinuationByte := fn() {
    if byteIndex >= byteCount {
		println(error("Invalid byte index"))
	}
	
    continuationByte := byteArray[byteIndex] & 0xFF
    byteIndex = byteIndex + 1
	
    if continuationByte & 0xC0 == 0x80 {
        return continuationByte & 0x3F
	}
	
    // If we end up here, it’s not a continuation byte
    println(error("Invalid continuation byte"))
}

// Define decodeSymbol function
decodeSymbol := fn() {
    byte1 := 0
    byte2 := 0
    byte3 := 0
    byte4 := 0
    codePoint := 0
	
	// println(byteCount, byteIndex)
	
    if byteIndex > byteCount {
        println(error("Invalid byte index"))
	}
	
    if byteIndex == byteCount {
        return false
	}
	
    // Read first byte
    byte1 = byteArray[byteIndex] & 0xFF
    byteIndex = byteIndex + 1
	
    // 1-byte sequence (no continuation bytes)
    if byte1 & 0x80 == 0 {
        return byte1
	}
	
    // 2-byte sequence
    if byte1 & 0xE0 == 0xC0 {
        byte2 = readContinuationByte()
        codePoint = ((byte1 & 0x1F) << 6) | byte2
        if codePoint >= 0x80 {
			return codePoint
		} 
		else {
            println(error("Invalid continuation byte"))
		}
	}
	
    // 3-byte sequence (may include unpaired surrogates)
    if byte1 & 0xF0 == 0xE0 {
        byte2 = readContinuationByte()
        byte3 = readContinuationByte()
        codePoint = ((byte1 & 0x0F) << 12) | (byte2 << 6) | byte3
        if codePoint >= 0x0800 {
            checkScalarValue(codePoint)
			return codePoint
		} 
		else {
            println(error("Invalid continuation byte"))
		}
	}
	
    // 4-byte sequence
    if byte1 & 0xF8 == 0xF0 {
        byte2 = readContinuationByte()
        byte3 = readContinuationByte()
        byte4 = readContinuationByte()
        codePoint = ((byte1 & 0x07) << 0x12) | (byte2 << 0x0C) | (byte3 << 0x06) | byte4
        if codePoint >= 0x010000 && codePoint <= 0x10FFFF {
            return codePoint
		}
	}
	
	println(error("Invalid UTF-8 detected"))
}

// Define utf8decode function
utf8decode := fn(byteString) {
    byteArray = ucs2decode(byteString)
    byteCount = len(byteArray)
    byteIndex = 0
    codePoints := []
    tmp := null
	
    for tmp != false {
		tmp = decodeSymbol()
		if tmp != false {
			codePoints = append(codePoints, tmp)
		}
	}
	
    return ucs2encode(codePoints)
}


export {
	ucs2decode : ucs2decode,
	ucs2encode : ucs2encode,
	decode : utf8decode,
	encode : utf8encode
}