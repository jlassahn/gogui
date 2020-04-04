
package gogui

// #include "glue.h"
//
import "C"

import (
	"unsafe"
)

type Window interface {
	Box

	SetTitle(txt string)
	SetMenu(menu Menu)

	HandleClose(fn func())
}

type windowPtr struct { ptr C.Window }

func CreateWindow(mode int) Window {
	window := C.CreateWindow(C.int(mode))
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
	C.SetMenu(w.ptr, menu.getPtr().ptr)
}

func (w windowPtr) SetTitle(txt string) {
	ctxt := C.CString(txt)
	defer C.free(unsafe.Pointer(ctxt))

	C.SetTitle(w.ptr, ctxt)
}

func (w windowPtr) ForceRedraw() {
	C.ForceRedraw(C.WindowToBox(w.ptr))
}

func (w windowPtr) Destroy() {
	C.Destroy(C.WindowToElement(w.ptr))
}

//export gorouteWindowClose
func gorouteWindowClose(w C.Window) {
	fn := windowCloseMap[w]
	if fn != nil {
		fn()
	}
}

func (w windowPtr) Hide() {}
func (w windowPtr) Parent() Element { return nil }
func (w windowPtr) RemoveChild(n int) {}
func (w windowPtr) GetChildCount() int { return 0 }
func (w windowPtr) GetChild(n int) Element { return nil }
func (w windowPtr) HandleResize(fn func()) {}
func (w windowPtr) HandleMouseMove(fn func(int, int)) {}
func (w windowPtr) HandleMouseDown(fn func(int, int, int)) {}
func (w windowPtr) HandleMouseUp(fn func(int, int, int)) {}
func (w windowPtr) HandleMouseEnter(fn func()) {}
func (w windowPtr) HandleMouseLeave(fn func()) {}
func (w windowPtr) HandleKeyDown(fn func(int)) {}
func (w windowPtr) HandleKeyUp(fn func(int)) {}
func (w windowPtr) HandleRedraw(fn func(Graphics)) {}

