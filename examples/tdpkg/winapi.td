import "dll"

winapi := {
    _kernel32: dll.new("kernel32.dll"),
    _user32: dll.new("user32.dll"),
    _gdi32: dll.new("gdi32.dll"),
    _ole32: dll.new("ole32.dll"),
    _winmm: dll.new("winmm.dll"),

    // --- Core utilities ---
    beep: fn(freq, duration_ms) { winapi._kernel32.proc("Beep").call(freq, duration_ms) },
    sleep: fn(ms) { winapi._kernel32.proc("Sleep").call(ms) },
    get_tick_count: fn() { return winapi._kernel32.proc("GetTickCount").call() },
    last_error: fn() { return winapi._kernel32.proc("GetLastError").call() },

    // --- Message boxes ---
    message: fn(text, title, style) {
        return winapi._user32.proc("MessageBoxW").call(
            0,
			text,
			title,
            style
        )
    },

    // --- Console helpers ---
	set_console_title: fn(title) { winapi._kernel32.proc("SetConsoleTitleW").call(title) },
    get_console_hwnd: fn() { return winapi._kernel32.proc("GetConsoleWindow").call() },

    // --- File helpers ---
    file_exists: fn(path) {
        handle := winapi._kernel32.proc("CreateFileW").call(
            path,
            0x80000000, // GENERIC_READ
            1 | 2,      // FILE_SHARE_READ | FILE_SHARE_WRITE
            0,          // lpSecurityAttributes
            3,          // OPEN_EXISTING
            0,
            0
        )
        if handle <= -1 { return false }
        winapi._kernel32.proc("CloseHandle").call(handle)
        return true
    },

    // --- Clipboard helpers ---
    copy_to_clipboard: fn(text) {
        winapi._user32.proc("OpenClipboard").call(0)
        winapi._user32.proc("EmptyClipboard").call()
        ptr := winapi._kernel32.proc("GlobalAlloc").call(0x2000, (len(text)+1)*2)
        buf := winapi._kernel32.proc("GlobalLock").call(ptr)
        for i := 0; i < len(text); i++ { winapi._kernel32.proc("WriteProcessMemory").call(0, buf + i*2, string(text[i]), 2) }
        winapi._kernel32.proc("GlobalUnlock").call(ptr)
        winapi._user32.proc("SetClipboardData").call(1, ptr)
        winapi._user32.proc("CloseClipboard").call()
    },

    paste_from_clipboard: fn() {
        winapi._user32.proc("OpenClipboard").call(0)
        ptr := winapi._user32.proc("GetClipboardData").call(1)
        text := winapi._kernel32.proc("GlobalLock").call(ptr)
        winapi._kernel32.proc("GlobalUnlock").call(ptr)
        winapi._user32.proc("CloseClipboard").call()
        return text
    },

    // --- Window manipulation ---
    move_window: fn(hwnd, x, y, width, height, repaint) {
        winapi._user32.proc("MoveWindow").call(hwnd, x, y, width, height, repaint)
    },

    show_window: fn(hwnd, cmd) { winapi._user32.proc("ShowWindow").call(hwnd, cmd) }, // SW_SHOWDEFAULT

    set_foreground_window: fn(hwnd) { winapi._user32.proc("SetForegroundWindow").call(hwnd) },

    // --- Keyboard & mouse automation ---
    set_cursor_pos: fn(x, y) { winapi._user32.proc("SetCursorPos").call(x, y) },

    // --- Sound & media ---
    play_sound: fn(file, flags) {
        winapi._winmm.proc("PlaySoundW").call(file, 0, flags)
    },

    // --- System info ---
    get_system_metrics: fn(index) { return winapi._user32.proc("GetSystemMetrics").call(index) }
}

export winapi
