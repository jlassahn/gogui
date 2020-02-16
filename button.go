
package gogui

// #include "glue.h"
//
import "C"
import (
	"unsafe"
)

type Button interface {
	Element
	GetBestWidth() int
	GetBestHeight() int
	HandleClick(fn func())
	SetText(txt string)
	SetImage(img Image)
}

type buttonPtr struct { ptr C.Button }

func CreateTextButton(txt string) Button {

	ctxt := C.CString(txt)
	defer C.free(unsafe.Pointer(ctxt))

	button := C.CreateTextButton(ctxt)
	C.SetButtonCallbacks(button)
	return buttonPtr{button}
}

func CreateImageButton(img Image) Button {
	button := C.CreateImageButton(img.getPtr().ptr)
	C.SetButtonCallbacks(button)
	return buttonPtr{button}
}

func CreateImageTextButton(img Image, txt string) Button {

	ctxt := C.CString(txt)
	defer C.free(unsafe.Pointer(ctxt))

	button := C.CreateImgTextButton(img.getPtr().ptr, ctxt)
	C.SetButtonCallbacks(button)
	return buttonPtr{button}
}

func (b buttonPtr) getElementPtr() elementPtr {
	return elementPtr{C.ButtonToElement(b.ptr)}
}

func (b buttonPtr) GetBestWidth() int {
	return int(C.GetBestWidth(b.ptr));
}

func (b buttonPtr) GetBestHeight() int {
	return int(C.GetBestHeight(b.ptr));
}

func (b buttonPtr) SetPosition(left, top, right, bottom Position) {
	C.SetPosition(C.ButtonToElement(b.ptr),
		cpos(left),
		cpos(top),
		cpos(right),
		cpos(bottom))
}

func (b buttonPtr) HandleClick(fn func()) {
	buttonClickMap[b.ptr] = fn
}

