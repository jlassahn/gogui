
package gogui

type Position struct {
	Percent int16
	Offset int16
}

type Color struct {
	R uint8
	G uint8
	B uint8
	A uint8
}

type Element interface {
	getElementPtr() elementPtr
	SetPosition(left, top, right, bottom Position)
	Show()
	Hide()
	Destroy()
	Parent() Element
}

type Box interface {
	Element
	AddChild(el Element)
	RemoveChild(n int)
	GetChildCount() int
	GetChild(n int) Element
	HandleResize(fn func())
	HandleMouseMove(fn func(int, int))
	HandleMouseDown(fn func(int))
	HandleMouseUp(fn func(int))
	HandleMouseEnter(fn func())
	HandleMouseLeave(fn func())
	HandleKeyDown(fn func(int))
	HandleKeyUp(fn func(int))
	HandleRedraw(fn func(Graphics))
	ForceRedraw()
}

type ScrollBox interface {
	Box
	SetContentSize(width int, height int)
}

type Window interface {
	Box

	SetTitle(txt string)
	SetMenu(menu Menu)

	HandleClose(fn func())
}

type Button interface {
	Element
	GetBestWidth() int
	GetBestHeight() int
	HandleClick(fn func())
	SetText(txt string)
	SetImage(img Image)
}

type Menu interface {
	AddMenuItem(item MenuItem)
	GetMenuItemCount() int
	GerMenuItem(n int) MenuItem
}

type MenuItem interface {
	Menu
	HandleMenuSelect(fn func())
}

type Image interface {
	getPtr() imagePtr
	Destroy();
	GetImageBuffer() []byte
	BeginDraw() Graphics
	EndDraw(gfx Graphics)
}

type Font *fontPtr

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
	SetFont(font Font)
	SetDefaultFont() //selects a font used for normal UI text
	DrawText(x float64, y float64, angle float64, txt string)
	DrawImage(x float64, y float64,
			width float64, height float64,
			img Image)
}

func Pos(pct int, offset int) Position {
	return Position{
		int16(pct),
		int16(offset),
	}
}


