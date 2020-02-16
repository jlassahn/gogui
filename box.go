
package gogui

// #include "glue.h"
//
import "C"

type Box interface {
	Element
	AddChild(el Element)
	RemoveChild(n int)
	GetChildCount() int
	GetChild(n int) Element
	HandleResize(fn func())
	HandleMouseMove(fn func(int, int))
	HandleMouseDown(fn func(int))
	HandleMouseUp(fn func(int))
	HandleMouseEnter(fn func())
	HandleMouseLeave(fn func())
	HandleKeyDown(fn func(int))
	HandleKeyUp(fn func(int))
	HandleRedraw(fn func(Graphics))
	ForceRedraw()
}

type boxPtr struct { ptr C.Box }

func CreateBox() Box {
	box := C.CreateBox()
	C.SetBoxCallbacks(box)
	return boxPtr{box}
}

func (b boxPtr) getElementPtr() elementPtr {
	return elementPtr{C.BoxToElement(b.ptr)}
}

func (b boxPtr) AddChild(el Element) {
	C.AddChild(b.ptr, el.getElementPtr().ptr)
}

func (b boxPtr) SetPosition(left, top, right, bottom Position) {
	C.SetPosition(C.BoxToElement(b.ptr),
		cpos(left),
		cpos(top),
		cpos(right),
		cpos(bottom))
}

func (b boxPtr) Show() {
	C.Show(C.BoxToElement(b.ptr))
}

func (b boxPtr) HandleRedraw(fn func(Graphics)) {
	boxRedrawMap[b.ptr] = fn
}

