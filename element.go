
package gogui

// #include "glue.h"
//
import "C"

type Element interface {
	getElementPtr() elementPtr
	SetPosition(left, top, right, bottom Position)
	Show()
	Hide()
	Destroy()
	Parent() Element
}

type elementPtr struct { ptr C.Element }

