
package gogui

// #include "glue.h"
//
import "C"

type ScrollBox interface {
	Box
	SetContentSize(width int, height int)
	SetBackgroundColor(color Color)
	GetVisibleWidth() int
	GetVisibleHeight() int
	GetVisibleLeft() int
	GetVisibleTop() int
	SetVisibleLeftTop(left int, top int)
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

func (b scrollBoxPtr)  SetBackgroundColor(color Color) {
	C.SetBackgroundColor(b.ptr, ccol(color))
}

func (b scrollBoxPtr) HandleRedraw(fn func(Graphics)) {
	boxRedrawMap[C.ScrollBoxToBox(b.ptr)] = fn
}

func (b scrollBoxPtr) HandleMouseMove(fn func(int, int)) {
	boxMouseMoveMap[C.ScrollBoxToBox(b.ptr)] = fn
}

func (b scrollBoxPtr) HandleMouseDown(fn func(int, int, int)) {
	boxMouseDownMap[C.ScrollBoxToBox(b.ptr)] = fn
}

func (b scrollBoxPtr) HandleMouseUp(fn func(int, int, int)) {
	boxMouseUpMap[C.ScrollBoxToBox(b.ptr)] = fn
}

func (b scrollBoxPtr) HandleMouseEnter(fn func()) {
	boxMouseEnterMap[C.ScrollBoxToBox(b.ptr)] = fn
}

func (b scrollBoxPtr) HandleMouseLeave(fn func()) {
	boxMouseLeaveMap[C.ScrollBoxToBox(b.ptr)] = fn
}

func (b scrollBoxPtr) ForceRedraw() {
	C.ForceRedraw(C.ScrollBoxToBox(b.ptr))
}

func (b scrollBoxPtr) GetVisibleWidth() int {
	return int(C.GetVisibleWidth(b.ptr))
}

func (b scrollBoxPtr) GetVisibleHeight() int {
	return int(C.GetVisibleHeight(b.ptr))
}

func (b scrollBoxPtr) GetVisibleLeft() int {
	return int(C.GetVisibleLeft(b.ptr))
}

func (b scrollBoxPtr) GetVisibleTop() int {
	return int(C.GetVisibleTop(b.ptr))
}

func (b scrollBoxPtr) SetVisibleLeftTop(left int, top int) {
	C.SetVisibleLeftTop(b.ptr, C.int(left), C.int(top))
}

func (b scrollBoxPtr) Show() {}
func (b scrollBoxPtr) Hide() {}
func (b scrollBoxPtr) Destroy() {}
func (b scrollBoxPtr) Parent() Element { return nil }
func (b scrollBoxPtr) AddChild(el Element) {}
func (b scrollBoxPtr) RemoveChild(n int) {}
func (b scrollBoxPtr) GetChildCount() int { return 0 }
func (b scrollBoxPtr) GetChild(n int) Element { return nil }
func (b scrollBoxPtr) HandleResize(fn func()) {}
func (b scrollBoxPtr) HandleKeyDown(fn func(int)) {}
func (b scrollBoxPtr) HandleKeyUp(fn func(int)) {}

