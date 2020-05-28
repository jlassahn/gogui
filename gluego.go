
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
var boxMouseMoveMap = map[C.Box] func(int, int) {}
var boxMouseDownMap = map[C.Box] func(int, int, int) {}
var boxMouseUpMap = map[C.Box] func(int, int, int) {}
var boxMouseEnterMap = map[C.Box] func() {}
var boxMouseLeaveMap = map[C.Box] func() {}
var itemSelectMap = map[C.MenuItem] func() {}
var textChangeMap = map[C.TextInput] func(string) {}

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

//export gorouteBoxMouseMove
func gorouteBoxMouseMove(b C.Box, x C.int, y C.int) {
	fn := boxMouseMoveMap[b]
	if fn != nil {
		fn(int(x), int(y))
	}
}

//export gorouteBoxMouseDown
func gorouteBoxMouseDown(b C.Box, x C.int, y C.int, btn C.int) {
	fn := boxMouseDownMap[b]
	if fn != nil {
		fn(int(x), int(y), int(btn))
	}
}

//export gorouteBoxMouseUp
func gorouteBoxMouseUp(b C.Box, x C.int, y C.int, btn C.int) {
	fn := boxMouseUpMap[b]
	if fn != nil {
		fn(int(x), int(y), int(btn))
	}
}

//export gorouteBoxMouseEnter
func gorouteBoxMouseEnter(b C.Box) {
	fn := boxMouseEnterMap[b]
	if fn != nil {
		fn()
	}
}

//export gorouteBoxMouseLeave
func gorouteBoxMouseLeave(b C.Box) {
	fn := boxMouseLeaveMap[b]
	if fn != nil {
		fn()
	}
}

//export gorouteItemSelect
func gorouteItemSelect(m C.MenuItem) {
	fn := itemSelectMap[m]
	if fn != nil {
		fn()
	}
}

//export gorouteTextChange
func gorouteTextChange(t C.TextInput,  txt *C.char) {
	str := C.GoString(txt)
	fn := textChangeMap[t]
	if fn != nil {
		fn(str)
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
func (b boxPtr) HandleMouseDown(fn func(int, int, int)) {}
func (b boxPtr) HandleMouseUp(fn func(int, int, int)) {}
func (b boxPtr) HandleMouseEnter(fn func()) {}
func (b boxPtr) HandleMouseLeave(fn func()) {}
func (b boxPtr) HandleKeyDown(fn func(int)) {}
func (b boxPtr) HandleKeyUp(fn func(int)) {}
func (b boxPtr) ForceRedraw() {}

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

