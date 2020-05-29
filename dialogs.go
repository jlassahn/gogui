
package gogui

// #include "glue.h"
//
import "C"
import (
	"unsafe"
)

type FileDialog interface {
	Destroy()
	Run() bool
	SetFile(filename string)
	GetFile() string
}

type fileDialogPtr struct { ptr C.FileDialog }

func CreateOpenFileDialog() FileDialog {

	return fileDialogPtr{C.CreateOpenFileDialog()}
}

func CreateSaveFileDialog() FileDialog {

	return fileDialogPtr{C.CreateSaveFileDialog()}
}

func (dlg fileDialogPtr) Destroy() {
	C.DestroyFileDialog(dlg.ptr)
}

func (dlg fileDialogPtr) Run() bool {
	return bool(C.RunDialog(dlg.ptr))
}

func (dlg fileDialogPtr) SetFile(filename string) {

	ctxt := C.CString(filename)
	defer C.free(unsafe.Pointer(ctxt))

	C.SetFileDialogFile(dlg.ptr, ctxt)
}

func (dlg fileDialogPtr) GetFile() string {

	return C.GoString(C.GetFileDialogFile(dlg.ptr))
}

