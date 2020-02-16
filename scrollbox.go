
package gogui

// #include "glue.h"
//
import "C"

type ScrollBox interface {
	Box
	SetContentSize(width int, height int)
}

type scrollBoxPtr struct { ptr C.ScrollBox }

func CreateScrollBox() ScrollBox {
	box := C.CreateScrollBox()
	C.SetScrollBoxCallbacks(box)
	return scrollBoxPtr{box}
}

func (b scrollBoxPtr) getElementPtr() elementPtr {
	return elementPtr{C.ScrollBoxToElement(b.ptr)}
}

func (b scrollBoxPtr) SetPosition(left, top, right, bottom Position) {
	C.SetPosition(C.ScrollBoxToElement(b.ptr),
		cpos(left),
		cpos(top),
		cpos(right),
		cpos(bottom))
}

func (b scrollBoxPtr) SetContentSize(width int, height int) {
	C.SetContentSize(b.ptr, C.int(width), C.int(height))
}

func (b scrollBoxPtr) HandleRedraw(fn func(Graphics)) {
	boxRedrawMap[C.ScrollBoxToBox(b.ptr)] = fn
}

