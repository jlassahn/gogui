
package main

import (
	"fmt"

	"github.com/jlassahn/gogui"
)


func closeHandler() {
	gogui.StopEventLoop(0)
}

func drawHandler(gfx gogui.Graphics) {

	fmt.Printf("DRAW %d, %d\n", gfx.GetCanvasWidth(), gfx.GetCanvasHeight())

	//gfx.SetFillColor(gogui.Color{255, 0, 0, 255})
	//gfx.SetStrokeColor(gogui.Color{0, 255, 0, 255})
	//gfx.SetLineWidth(3.0)
	gfx.FillCanvas()

	gfx.StartPath(0.0, 0.0)
	gfx.LineTo(100.0, 1000.0)
	gfx.StrokePath()

	gfx.StartPath(10.0, 10.0)
	gfx.CurveTo(110, 10, 110, 110, 10, 110)
	gfx.StrokePath()

}

func main() {

	gogui.Init()
	defer gogui.Exit()

	window := gogui.CreateWindow()
	window.SetPosition(
		gogui.Pos(50, 0),
		gogui.Pos(10, 0),
		gogui.Pos(75, 0),
		gogui.Pos(50, 0))
	window.HandleClose(closeHandler)

	scroll := gogui.CreateScrollBox()
	scroll.SetPosition(
		gogui.Pos(50,0),
		gogui.Pos(10,0),
		gogui.Pos(80,0),
		gogui.Pos(50,0))
	scroll.HandleRedraw(drawHandler)

	window.AddChild(scroll)

	/*
	box1 := gogui.CreateBox()
	box1.SetPosition(
		gogui.Pos(50,0),
		gogui.Pos(10,0),
		gogui.Pos(80,0),
		gogui.Pos(50,0))
	box1.HandleRedraw(drawHandler)

	window.AddChild(box1)
	*/

	window.Show()

	ret := gogui.RunEventLoop()
	fmt.Println(ret)
}

