
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
	AddSeparator()
	GetMenuItemCount() int
	GetMenuItem(n int) MenuItem
	GetApplicationMenu() MenuItem
}

type MenuItem interface {
	Menu
	HandleMenuSelect(fn func())
	SetShortcut(key string)
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
	C.AddMenuItem(menu.ptr, item.(menuItemPtr).ptr)
}

func (menu menuPtr) AddSeparator() {
	C.AddMenuSeparator(menu.ptr)
}

func (mi menuPtr) GetApplicationMenu() MenuItem {
	return menuItemPtr{C.GetApplicationMenu(mi.getPtr().ptr)}
}

func (mi menuItemPtr) AddMenuItem(item MenuItem) {
	C.AddMenuItem(mi.getPtr().ptr, item.(menuItemPtr).ptr)
}

func (mi menuItemPtr) AddSeparator() {
	C.AddMenuSeparator(mi.getPtr().ptr)
}

func (mi menuItemPtr) GetApplicationMenu() MenuItem {
	return menuItemPtr{C.GetApplicationMenu(mi.getPtr().ptr)}
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

func (mi menuItemPtr) SetShortcut(key string) {

	ctxt := C.CString(key)
	defer C.free(unsafe.Pointer(ctxt))

	C.SetMenuShortcut(mi.ptr, ctxt)
}

