
package gogui

// #include "glue.h"
//
import "C"
import (
	"unsafe"
)

type TextInput interface {
	Element
	GetBestHeight() int
	HandleChange(fn func(txt string))
	SetText(txt string)
	GetText() string
}

type textInputPtr struct { ptr C.TextInput }

func CreateTextLineInput() TextInput {

	txt := C.CreateTextLineInput()
	C.SetTextCallbacks(txt)
	return textInputPtr{txt}
}

func (t textInputPtr) getElementPtr() elementPtr {
	return elementPtr{C.TextInputToElement(t.ptr)}
}

func (t textInputPtr) GetBestHeight() int {
	return int(C.GetBestTextHeight(t.ptr));
}

func (t textInputPtr) SetPosition(left, top, right, bottom Position) {
	C.SetPosition(C.TextInputToElement(t.ptr),
		cpos(left),
		cpos(top),
		cpos(right),
		cpos(bottom))
}

func (t textInputPtr) HandleChange(fn func(txt string)) {
	textChangeMap[t.ptr] = fn
}

func (t textInputPtr) SetText(txt string) {

	ctxt := C.CString(txt)
	defer C.free(unsafe.Pointer(ctxt))

	C.SetTextData(t.ptr, ctxt)
}

func (t textInputPtr) GetText() string {
	return C.GoString(C.GetTextData(t.ptr))
}

// FIXME implement
func (t textInputPtr) Show() {}
func (t textInputPtr) Hide() {}
func (t textInputPtr) Destroy() {}
func (t textInputPtr) Parent() Element { return nil }

