
package gogui

// #include "glue.h"
//
import "C"
import (
	"runtime"
)

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

	// Window styles
	WINDOW_TITLED int = C.WINDOW_TITLED
	WINDOW_CLOSABLE = C.WINDOW_CLOSABLE
	WINDOW_SIZABLE = C.WINDOW_SIZABLE
	WINDOW_TOPMOST = C.WINDOW_TOPMOST
	WINDOW_NORMAL = C.WINDOW_NORMAL
)

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

func Pos(pct int, offset int) Position {
	return Position{
		int16(pct),
		int16(offset),
	}
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

func Init() {

	// Cocoa must run on the applocation's main thread
	runtime.LockOSThread()

	C.Init()
	C.SetGlobalCallbacks()
}

func Exit() {
	C.Exit()
}

func StopEventLoop(ret int) {
	C.StopEventLoop(C.int(ret))
}

func RunEventLoop() int {
	return int(C.RunEventLoop())
}


func HandleAppOpenFile(fn func(string) error) {
	appOpenFileHandler = fn
}

