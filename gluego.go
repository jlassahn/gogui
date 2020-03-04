
package gogui

// #cgo CFLAGS: -x objective-c
// #cgo LDFLAGS: -framework cocoa
//
// #include "glue.h"
//
import "C"



var appOpenFileHandler func(string) error
var windowCloseMap = map[C.Window] func() {}
var buttonClickMap = map[C.Button] func() {}
var boxRedrawMap = map[C.Box] func(Graphics) {}
var itemSelectMap = map[C.MenuItem] func() {}

//export gorouteAppOpenFile
func gorouteAppOpenFile(txt *C.char) C.char {
	if appOpenFileHandler != nil {
		str := C.GoString(txt)
		if appOpenFileHandler(str) == nil {
			return 1
		}
		return 0
	}
	return 0
}

//export gorouteButtonClick
func gorouteButtonClick(b C.Button) {
	fn := buttonClickMap[b]
	if fn != nil {
		fn()
	}
}

//export gorouteBoxRedraw
func gorouteBoxRedraw(b C.Box, cgfx C.Graphics) {
	gfx := graphicsPtr{cgfx}
	fn := boxRedrawMap[b]
	if fn != nil {
		fn(gfx)
	}
}

//export gorouteItemSelect
func gorouteItemSelect(m C.MenuItem) {
	fn := itemSelectMap[m]
	if fn != nil {
		fn()
	}
}

//FIXME implement
func (b boxPtr) Hide() {}
func (b boxPtr) Destroy() {}
func (b boxPtr) Parent() Element { return nil }
func (b boxPtr) RemoveChild(n int) {}
func (b boxPtr) GetChildCount() int { return 0 }
func (b boxPtr) GetChild(n int) Element { return nil }
func (b boxPtr) HandleResize(fn func()) {}
func (b boxPtr) HandleMouseMove(fn func(int, int)) {}
func (b boxPtr) HandleMouseDown(fn func(int)) {}
func (b boxPtr) HandleMouseUp(fn func(int)) {}
func (b boxPtr) HandleMouseEnter(fn func()) {}
func (b boxPtr) HandleMouseLeave(fn func()) {}
func (b boxPtr) HandleKeyDown(fn func(int)) {}
func (b boxPtr) HandleKeyUp(fn func(int)) {}
func (b boxPtr) ForceRedraw() {}

func (b scrollBoxPtr) Show() {}
func (b scrollBoxPtr) Hide() {}
func (b scrollBoxPtr) Destroy() {}
func (b scrollBoxPtr) Parent() Element { return nil }
func (b scrollBoxPtr) AddChild(el Element) {}
func (b scrollBoxPtr) RemoveChild(n int) {}
func (b scrollBoxPtr) GetChildCount() int { return 0 }
func (b scrollBoxPtr) GetChild(n int) Element { return nil }
func (b scrollBoxPtr) HandleResize(fn func()) {}
func (b scrollBoxPtr) HandleMouseMove(fn func(int, int)) {}
func (b scrollBoxPtr) HandleMouseDown(fn func(int)) {}
func (b scrollBoxPtr) HandleMouseUp(fn func(int)) {}
func (b scrollBoxPtr) HandleMouseEnter(fn func()) {}
func (b scrollBoxPtr) HandleMouseLeave(fn func()) {}
func (b scrollBoxPtr) HandleKeyDown(fn func(int)) {}
func (b scrollBoxPtr) HandleKeyUp(fn func(int)) {}
func (b scrollBoxPtr) ForceRedraw() {}

func (b buttonPtr) Show() {}
func (b buttonPtr) Hide() {}
func (b buttonPtr) Destroy() {}
func (b buttonPtr) Parent() Element { return nil }
func (b buttonPtr) SetText(txt string) {}
func (b buttonPtr) SetImage(img Image) {}

func (gfx graphicsPtr) DrawImage(x float64, y float64,
		width float64, height float64,
		img Image) {}


func (menu menuPtr) GetMenuItemCount() int { return 0 }
func (menu menuPtr) GetMenuItem(n int) MenuItem { return nil }

func (mi menuItemPtr) GetMenuItemCount() int { return 0 }
func (mi menuItemPtr) GetMenuItem(n int) MenuItem { return nil }


func CreateImageFromFile(filename string) Image { return nil }

