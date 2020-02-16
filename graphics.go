
package gogui

// #include "glue.h"
//
import "C"
import (
	"unsafe"
)

type Font fontPtr

type Graphics interface {
	GetCanvasWidth() int
	GetCanvasHeight() int
	SetStrokeColor(color Color)
	SetFillColor(color Color)
	SetLineWidth(width float64)
	SetLineJoin(joinStyle int)
	StartPath(x float64, y float64)
	LineTo(x float64, y float64)
	CurveTo(c1x float64, c1y float64,
			c2x float64, c2y float64,
			x float64, y float64)
	ClosePath()
	StrokePath()
	FillPath()
	FillCanvas()
	SetFont(font Font, size float64)
	SetDefaultFont() //selects a font used for normal UI text
	DrawText(x float64, y float64, angle float64, txt string)
	MeasureText(txt string) float64
	DrawImage(x float64, y float64,
			width float64, height float64,
			img Image)
}

type graphicsPtr struct { ptr C.Graphics }
type fontPtr struct { ptr C.Font }

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

func CreateFont(family string, style int) Font {

	ctxt := C.CString(family)
	defer C.free(unsafe.Pointer(ctxt))

	return Font(fontPtr{C.CreateFont(ctxt, C.int(style))})
}

func DestroyFont(font Font) {
	C.DestroyFont(font.ptr)
}

