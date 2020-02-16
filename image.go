
package gogui

// #include "glue.h"
//
import "C"
import (
	"unsafe"
)

type Image interface {
	getPtr() imagePtr
	Destroy()
	GetImageBuffer() []byte
	BeginDraw() Graphics
	EndDraw(gfx Graphics)
}

type imagePtr struct { ptr C.Image }

func CreateImage(width int, height int) Image {
	return imagePtr{C.CreateImage(C.int(width), C.int(height))}
}

func (img imagePtr) getPtr() imagePtr {
	return img
}

func (img imagePtr) Destroy() {
	C.DestroyImage(img.getPtr().ptr)
}

func (img imagePtr) GetImageBuffer() []byte {
	carray := C.GetImageBuffer(img.getPtr().ptr)
	length := int(C.GetImageBufferSize(img.getPtr().ptr))
	slice := (*[0x7FFFFFFF]byte)(unsafe.Pointer(carray))[:length:length]

	return slice
}

func (img imagePtr) BeginDraw() Graphics {
	return graphicsPtr{C.BeginDrawToImage(img.getPtr().ptr)}
}

func (img imagePtr) EndDraw(gfx Graphics) {
	C.EndDrawToImage(img.getPtr().ptr, gfx.(graphicsPtr).ptr)
}

