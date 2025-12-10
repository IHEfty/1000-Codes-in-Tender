import "wui"

w := wui.new_window()
w.set_title("Selection Controls Demo")
w.set_size(500, 400)

// ComboBox
combobox := wui.new_combobox()
combobox.set_items(["Apple", "Banana", "Cherry", "Date"])
combobox.set_bounds(20, 20, 150, 30)
combobox.set_selected_index(0)
combobox.set_on_change(fn(index) {
	println("Selected item index:", index)
})

// RadioButtons (usually grouped)
radio1 := wui.new_radiobutton()
// radio1.set_text("Option 1")
// radio1.set_bounds(20, 70, 100, 30)
// radio1.set_on_check(fn(checked) {
	// if checked {
		// println("Option 1 selected")
	// }
// })

radio2 := wui.new_radiobutton()
// radio2.set_text("Option 2")
// radio2.set_bounds(20, 110, 100, 30)
// radio2.set_on_check(fn(checked) {
	// if checked {
		// println("Option 2 selected")
	// }
// })

// StringList (ListBox)
listbox := wui.new_stringlist()
// listbox.set_items(["Item 1", "Item 2", "Item 3", "Item 4"])
// listbox.set_bounds(20, 160, 150, 120)

// StringTable (Table/Grid)
table := wui.new_stringtable("Name", "Age", "City")
// table.set_bounds(200, 20, 250, 150)
// Note: In real usage, you'd add rows to the table

w.add(combobox)
w.add(radio1)
w.add(radio2)
w.add(listbox)
w.add(table)

w.show()