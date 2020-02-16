
package gogui

// #include "glue.h"
//
import "C"
import (
	"unsafe"
)

type Menu interface {
	getPtr() menuPtr
	AddMenuItem(item MenuItem)
	GetMenuItemCount() int
	GetMenuItem(n int) MenuItem
}

type MenuItem interface {
	Menu
	HandleMenuSelect(fn func())
}

type menuPtr struct { ptr C.Menu }
type menuItemPtr struct { ptr C.MenuItem }

func CreateMenu() Menu {
	menu := C.CreateMenu()
	return menuPtr{menu}
}

func (menu menuPtr) getPtr() menuPtr {
	return menu
}

func (menu menuPtr) AddMenuItem(item MenuItem) {
	C.AddMenuItem(menu.ptr, item.(menuItemPtr).ptr);
}

func (mi menuItemPtr) AddMenuItem(item MenuItem) {
	C.AddMenuItem(mi.getPtr().ptr, item.(menuItemPtr).ptr);
}

func CreateTextMenuItem(txt string) MenuItem {

	ctxt := C.CString(txt)
	defer C.free(unsafe.Pointer(ctxt))

	item := C.CreateTextMenuItem(ctxt)
	C.SetMenuCallbacks(item)
	return menuItemPtr{item}
}

func CreateImageTextMenuItem(img Image, txt string) MenuItem {
	ctxt := C.CString(txt)
	defer C.free(unsafe.Pointer(ctxt))

	item := C.CreateImgTextMenuItem(img.getPtr().ptr, ctxt)
	return menuItemPtr{item}
}

func (menu menuItemPtr) getPtr() menuPtr {
	return menuPtr{C.MenuItemToMenu(menu.ptr)}
}

func (mi menuItemPtr) HandleMenuSelect(fn func()) {
	itemSelectMap[mi.ptr] = fn
}

//FIXME remove from API
func SetMainMenu(menu Menu) {
	C.SetMainMenu(menu.getPtr().ptr)
}

