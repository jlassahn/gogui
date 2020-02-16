
package gogui

// #include "glue.h"
//
import "C"

type Window interface {
	Box

	SetTitle(txt string)
	SetMenu(menu Menu)

	HandleClose(fn func())
}

type windowPtr struct { ptr C.Window }

func CreateWindow() Window {
	window := C.CreateWindow()
	C.SetWindowCallbacks(window)
	return windowPtr{window}
}

func (w windowPtr) getElementPtr() elementPtr {
	return elementPtr{C.WindowToElement(w.ptr)}
}

func (w windowPtr) SetPosition(left, top, right, bottom Position) {
	C.SetPosition(C.WindowToElement(w.ptr),
		cpos(left),
		cpos(top),
		cpos(right),
		cpos(bottom))
}

func (w windowPtr) Show() {
	C.Show(C.WindowToElement(w.ptr))
}

func (w windowPtr) HandleClose(fn func()) {
	windowCloseMap[w.ptr] = fn
}

func (w windowPtr) AddChild(el Element) {
	C.AddChild(C.WindowToBox(w.ptr), el.getElementPtr().ptr)
}

func (w windowPtr) SetMenu(menu Menu) {
	C.SetMenu(w.ptr, menu.getPtr().ptr);
}

//export gorouteWindowClose
func gorouteWindowClose(w C.Window) {
	fn := windowCloseMap[w]
	if fn != nil {
		fn()
	}
}

