
package gogui

// #cgo CFLAGS: -x objective-c
// #cgo LDFLAGS: -framework cocoa
//
// #include "glue.h"
//
import "C"
import "unsafe"
import "fmt"

const (
	// Join Styles
	JOIN_ROUND int = C.JOIN_ROUND
	JOIN_MITER int = C.JOIN_MITER
	JOIN_BEVEL int = C.JOIN_BEVEL

	// Font Styles
	FONT_NORMAL int = C.FONT_NORMAL
	FONT_BOLD int = C.FONT_BOLD
	FONT_ITALIC int = C.FONT_ITALIC
	FONT_BOLD_ITALIC int = C.FONT_BOLD_ITALIC
	// It's valid to assume FONT_BOLD_ITALIC == FONT_BOLD + FONT_ITALIC
)

func Init() {
	C.Init();
}

func Exit() {
	C.Exit();
}

func StopEventLoop(ret int) {
	C.StopEventLoop(C.int(ret));
}

func RunEventLoop() int {
	return int(C.RunEventLoop())
}

func HandleAppOpenFile(fn func(string) error) {
	appOpenFileHandler = fn
}

func CreateWindow() Window {
	window := C.CreateWindow()
	C.SetWindowCallbacks(window)
	return windowPtr{window}
}

func (w windowPtr) getElementPtr() elementPtr {
	return elementPtr{C.WindowToElement(w.ptr)}
}

func (w windowPtr) SetPosition(left, top, right, bottom Position) {
	C.SetPosition(C.WindowToElement(w.ptr),
		cpos(left),
		cpos(top),
		cpos(right),
		cpos(bottom))
}

func (w windowPtr) Show() {
	C.Show(C.WindowToElement(w.ptr))
}

func (w windowPtr) HandleClose(fn func()) {
	windowCloseMap[w.ptr] = fn
}

func (w windowPtr) AddChild(el Element) {
	C.AddChild(C.WindowToBox(w.ptr), el.getElementPtr().ptr)
}

func (w windowPtr) SetMenu(menu Menu) {
	C.SetMenu(w.ptr, menu.getPtr().ptr);
}

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

func (b scrollBoxPtr) HandleRedraw(fn func(Graphics)) {
	fmt.Printf("HandleRedraw map %p to %p\n", C.ScrollBoxToBox(b.ptr), fn)
	boxRedrawMap[C.ScrollBoxToBox(b.ptr)] = fn
}

func (gfx graphicsPtr) GetCanvasWidth() int {
	return int(C.GetCanvasWidth(gfx.ptr))
}

func (gfx graphicsPtr) GetCanvasHeight() int {
	return int(C.GetCanvasHeight(gfx.ptr))
}

func (gfx graphicsPtr) FillCanvas() {
	C.FillCanvas(gfx.ptr)
}

func (gfx graphicsPtr) SetStrokeColor(color Color) {
	C.SetStrokeColor(gfx.ptr, ccol(color))
}

func (gfx graphicsPtr) SetFillColor(color Color) {
	C.SetFillColor(gfx.ptr, ccol(color))
}

func (gfx graphicsPtr) SetLineWidth(width float64) {
	C.SetLineWidth(gfx.ptr, C.double(width))
}

func (gfx graphicsPtr) SetLineJoin(joinStyle int) {
	C.SetLineJoin(gfx.ptr, C.int(joinStyle))
}

func (gfx graphicsPtr) StartPath(x float64, y float64) {
	C.StartPath(gfx.ptr, C.double(x), C.double(y))
}

func (gfx graphicsPtr) LineTo(x float64, y float64) {
	C.LineTo(gfx.ptr, C.double(x), C.double(y))
}

func (gfx graphicsPtr) CurveTo(c1x float64, c1y float64,
		c2x float64, c2y float64,
		x float64, y float64) {

	C.CurveTo(gfx.ptr,
		C.double(c1x), C.double(c1y),
		C.double(c2x), C.double(c2y),
		C.double(x), C.double(y))
}

func (gfx graphicsPtr) ClosePath() {
	C.ClosePath(gfx.ptr)
}

func (gfx graphicsPtr) StrokePath() {
	C.StrokePath(gfx.ptr)
}

func (gfx graphicsPtr) FillPath() {
	C.FillPath(gfx.ptr)
}

func (gfx graphicsPtr) DrawText(x float64, y float64, angle float64, txt string) {
	ctxt := C.CString(txt)
	defer C.free(unsafe.Pointer(ctxt))
	C.DrawText(gfx.ptr, C.double(x), C.double(y), C.double(angle), ctxt)
}

func (gfx graphicsPtr)  MeasureText(txt string) float64 {

	ctxt := C.CString(txt)
	defer C.free(unsafe.Pointer(ctxt))
	return float64(C.MeasureText(gfx.ptr, ctxt))
}

func (gfx graphicsPtr) SetFont(font Font, size float64) {
	C.SetFont(gfx.ptr, font.ptr, C.double(size))
}

func (gfx graphicsPtr) SetDefaultFont() {
	C.SetDefaultFont(gfx.ptr)
}

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

func CreateFont(family string, style int) Font {

	ctxt := C.CString(family)
	defer C.free(unsafe.Pointer(ctxt))

	return Font(fontPtr{C.CreateFont(ctxt, C.int(style))})
}

func DestroyFont(font Font) {
	C.DestroyFont(font.ptr)
}

func cpos(x Position) C.POSITION {
	return C.POSITION {
		C.short(x.Percent),
		C.short(x.Offset),
	}
}

func ccol(x Color) C.COLOR {
	return C.COLOR {
		C.uchar(x.R),
		C.uchar(x.G),
		C.uchar(x.B),
		C.uchar(x.A),
	}
}

type elementPtr struct { ptr C.Element }
type boxPtr struct { ptr C.Box }
type scrollBoxPtr struct { ptr C.ScrollBox }
type windowPtr struct { ptr C.Window }
type buttonPtr struct { ptr C.Button }
type menuPtr struct { ptr C.Menu }
type menuItemPtr struct { ptr C.MenuItem }
type imagePtr struct { ptr C.Image }
type graphicsPtr struct { ptr C.Graphics }
type fontPtr struct { ptr C.Font }


var appOpenFileHandler func(string) error
var windowCloseMap = map[C.Window] func() {}
var buttonClickMap = map[C.Button] func() {}
var boxRedrawMap = map[C.Box] func(Graphics) {}
var itemSelectMap = map[C.MenuItem] func() {}

//export appOpenFileCallback
func appOpenFileCallback(txt *C.char) C.char {
	if appOpenFileHandler != nil {
		str := C.GoString(txt)
		if appOpenFileHandler(str) != nil {
			return 1
		}
		return 0
	}
	return 0
}

//export windowCloseCallback
func windowCloseCallback(w C.Window) {
	fn := windowCloseMap[w]
	if fn != nil {
		fn()
	}
}

//export buttonClickCallback
func buttonClickCallback(b C.Button) {
	fn := buttonClickMap[b]
	if fn != nil {
		fn()
	}
}

//export boxRedrawCallback
func boxRedrawCallback(b C.Box, cgfx C.Graphics) {
	fmt.Printf("boxRedrawCallback lookup %p\n", b)
	gfx := graphicsPtr{cgfx}
	fn := boxRedrawMap[b]
	if fn != nil {
		fmt.Printf("calling callback\n")
		fn(gfx)
	}
}

//export itemSelectCallback
func itemSelectCallback(m C.MenuItem) {
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

func (w windowPtr) Hide() {}
func (w windowPtr) Destroy() {}
func (w windowPtr) Parent() Element { return nil }
func (w windowPtr) RemoveChild(n int) {}
func (w windowPtr) GetChildCount() int { return 0 }
func (w windowPtr) GetChild(n int) Element { return nil }
func (w windowPtr) HandleResize(fn func()) {}
func (w windowPtr) HandleMouseMove(fn func(int, int)) {}
func (w windowPtr) HandleMouseDown(fn func(int)) {}
func (w windowPtr) HandleMouseUp(fn func(int)) {}
func (w windowPtr) HandleMouseEnter(fn func()) {}
func (w windowPtr) HandleMouseLeave(fn func()) {}
func (w windowPtr) HandleKeyDown(fn func(int)) {}
func (w windowPtr) HandleKeyUp(fn func(int)) {}
func (w windowPtr) HandleRedraw(fn func(Graphics)) {}
func (w windowPtr) ForceRedraw() {}
func (w windowPtr) SetTitle(txt string) {}

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

