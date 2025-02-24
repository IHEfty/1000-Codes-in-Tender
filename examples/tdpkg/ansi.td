export {
	// General ASCII Codes
	BEL: "\x1B[7m",
	BS: "\x1B[8m",
	HT: "\x1B[9m",
	LF: "\x1B[10m",
	VT: "\x1B[11m",
	FF: "\x1B[12m",
	CR: "\x1B[13m",
	ESC: "\x1B[27m",
	DEL: "\x1B[127m",
	
	// Cursor Controls
	HOME: "\x1B[H",
	MOVE_TO: fn(line, column) { return "\x1B[" + line + ";" + column + "H" },
	CURSOR_UP: fn(lines) { return "\x1B[" + lines + "A" },
	CURSOR_DOWN: fn(lines) { return "\x1B[" + lines + "B" },
	CURSOR_RIGHT: fn(columns) { return "\x1B[" + columns + "C" },
	CURSOR_LEFT: fn(columns) { return "\x1B[" + columns + "D" },
	NEXT_LINE: fn(lines) { return "\x1B[" + lines + "E" },
	PREVIOUS_LINE: fn(lines) { return "\x1B[" + lines + "F" },
	MOVE_TO_COLUMN: fn(column) { return "\x1B[" + column + "G" },
	REPORT_CURSOR_POSITION: "\x1B[6n",
	MOVE_UP: "\x1BM",
	SAVE_CURSOR_POSITION: "\x1B[s",
	RESTORE_CURSOR_POSITION: "\x1B[u",
	
	// Erase Functions
	ERASE_DISPLAY: "\x1B[J",
	ERASE_TO_END: "\x1B[0J",
	ERASE_TO_BEGINNING: "\x1B[1J",
	ERASE_ENTIRE_SCREEN: "\x1B[2J",
	ERASE_SAVED_LINES: "\x1B[3J",
	ERASE_LINE: "\x1B[K",
	ERASE_TO_END_OF_LINE: "\x1B[0K",
	ERASE_TO_BEGINNING_OF_LINE: "\x1B[1K",
	ERASE_ENTIRE_LINE: "\x1B[2K",
	
	// Colors / Graphics Mode
	// SET_GRAPHICS_MODE: fn(...modes) { return "\x1B[" + modes.joinfn(";") + "m" },
	RESET_GRAPHICS_MODE: "\x1B[0m",
	SET_BOLD_MODE: "\x1B[1m",
	SET_DIM_MODE: "\x1B[2m",
	SET_ITALIC_MODE: "\x1B[3m",
	SET_UNDERLINE_MODE: "\x1B[4m",
	SET_BLINKING_MODE: "\x1B[5m",
	SET_INVERSE_MODE: "\x1B[7m",
	SET_HIDDEN_MODE: "\x1B[8m",
	SET_STRIKETHROUGH_MODE: "\x1B[9m",
	
	// Colors
	SET_COLOR: fn(foreground, background) { return "\x1B[38;5;" + foreground + "m\x1B[48;5;" + background + "m" },
	RESET_COLOR: "\x1B[0;0m",
	
	// Screen Modes
	SET_SCREEN_MODE: fn(value) { return "\x1B[=" + value + "h" },
	RESET_SCREEN_MODE: fn(value) { return "\x1B[=" + value + "l" },
	
	// Common Private Modes
	CURSOR_INVISIBLE: "\x1B[?25l",
	CURSOR_VISIBLE: "\x1B[?25h",
	RESTORE_SCREEN: "\x1B[?47l",
	SAVE_SCREEN: "\x1B[?47h",
	ENABLE_ALTERNATIVE_BUFFER: "\x1B[?1049h",
	DISABLE_ALTERNATIVE_BUFFER: "\x1B[?1049l",
	
	// Keyboard Strings
	REDEFINE_KEY: fn(code, string) { return "\x1B[" + code + ";" + string + "p" }
}