dll := import("dll")

export {
	// To indicate the buttons displayed in the message box, specify one of the following values.
	MB_ABORTRETRYIGNORE : 0x00000002,
	MB_CANCELTRYCONTINUE : 0x00000006,
	MB_HELP : 0x00004000,
	MB_OK : 0x00000000,
	MB_OKCANCEL : 0x00000001,
	MB_RETRYCANCEL : 0x00000005,
	MB_YESNO : 0x00000004,
	MB_YESNOCANCEL : 0x00000003,
	// To display an icon in the message box, specify one of the following values.
	MB_ICONEXCLAMATION : 0x00000030,
	MB_ICONWARNING : 0x00000030,
	MB_ICONINFORMATION : 0x00000040,
	MB_ICONASTERISK : 0x00000040,
	MB_ICONQUESTION : 0x00000020,
	MB_ICONSTOP : 0x00000010,
	MB_ICONERROR : 0x00000010,
	MB_ICONHAND : 0x00000010,
	// To indicate the default button, specify one of the following values.
	MB_DEFBUTTON1 : 0x00000000,
	MB_DEFBUTTON2 : 0x00000100,
	MB_DEFBUTTON3 : 0x00000200,
	MB_DEFBUTTON4 : 0x00000300,
	// To indicate the modality of the dialog box, specify one of the following values.
	MB_APPLMODAL : 0x00000000,
	MB_SYSTEMMODAL : 0x00001000,
	MB_TASKMODAL : 0x00002000,
	// To specify other options, use one or more of the following values.
	MB_DEFAULT_DESKTOP_ONLY : 0x00020000,
	MB_RIGHT : 0x00080000,
	MB_RTLREADING : 0x00100000,
	MB_SETFOREGROUND : 0x00010000,
	MB_TOPMOST : 0x00040000,
	MB_SERVICE_NOTIFICATION : 0x00200000,
	//Return values.
	IDABORT : 3, //The Abort button was selected.
	IDCANCEL : 2, //The Cancel button was selected.
	IDCONTINUE : 11, //The Continue button was selected.
	IDIGNORE : 5, //The Ignore button was selected.
	IDNO : 7, //The No button was selected.
	IDOK : 1, //The OK button was selected.
	IDRETRY : 4, //The Retry button was selected.
	IDTRYAGAIN : 10, //The Try Again button was selected.
	IDYES : 6, //The Yes button was selected.
	
	//function
	new : fn(content, title, f) {
		return dll.new("user32").proc("MessageBoxW").call(0, content, title, f)
	}
}