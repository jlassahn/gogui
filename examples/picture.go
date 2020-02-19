
package main

import (
	"fmt"

	"github.com/jlassahn/gogui"
)

func clickHandler() {
	fmt.Println("CLICK")
}

func closeHandler() {
	gogui.StopEventLoop(0)
}

func drawHandler(gfx gogui.Graphics) {

	//default background is white
	gfx.FillCanvas()

	gfx.SetStrokeColor(gogui.Color{255, 0, 0, 255})
	gfx.SetLineWidth(3.0)

	gfx.StartPath(250, 50)
	gfx.CurveTo(350, 50, 450, 150, 450, 250)
	gfx.CurveTo(450, 350, 350, 450, 250, 450)
	gfx.CurveTo(150, 450, 50, 350, 50, 250)
	gfx.CurveTo(50, 150, 150, 50, 250, 50)
	gfx.StrokePath()

	gfx.StartPath(100, 270)
	gfx.CurveTo(100, 430, 400, 430, 400, 270)
	gfx.StrokePath()

	gfx.StartPath(150, 150)
	gfx.LineTo(150, 200)
	gfx.StrokePath()

	gfx.StartPath(350, 150)
	gfx.LineTo(350, 200)
	gfx.StrokePath()
}

func main() {

	gogui.Init()
	defer gogui.Exit()

	window := gogui.CreateWindow(gogui.WINDOW_NORMAL)
	window.SetPosition(
		gogui.Pos(50, 0),
		gogui.Pos(10, 0),
		gogui.Pos(75, 0),
		gogui.Pos(50, 0))
	window.HandleClose(closeHandler)

	scroll := gogui.CreateScrollBox()
	scroll.SetPosition(
		gogui.Pos(0,100),
		gogui.Pos(0,50),
		gogui.Pos(100,0),
		gogui.Pos(100,0))
	scroll.SetContentSize(500, 500)
	scroll.HandleRedraw(drawHandler)
	window.AddChild(scroll)

	btnPos := 50
	button := gogui.CreateTextButton("Button 1")
	btnHeight := button.GetBestHeight()
	fmt.Printf("button height = %d\n", btnHeight)
	button.SetPosition(
		gogui.Pos(0, 0),
		gogui.Pos(0, btnPos),
		gogui.Pos(0, 100),
		gogui.Pos(0, btnPos+btnHeight))
	button.HandleClick(clickHandler)
	window.AddChild(button)

	btnPos += btnHeight
	button = gogui.CreateTextButton("Button 2")
	fmt.Printf("button height = %d\n", btnHeight)
	button.SetPosition(
		gogui.Pos(0, 0),
		gogui.Pos(0, btnPos),
		gogui.Pos(0, 100),
		gogui.Pos(0, btnPos+btnHeight))
	button.HandleClick(clickHandler)
	window.AddChild(button)

	btnPos += btnHeight
	button = gogui.CreateTextButton("Button 3")
	fmt.Printf("button height = %d\n", btnHeight)
	button.SetPosition(
		gogui.Pos(0, 0),
		gogui.Pos(0, btnPos),
		gogui.Pos(0, 100),
		gogui.Pos(0, btnPos+btnHeight))
	button.HandleClick(clickHandler)
	window.AddChild(button)

	window.Show()

	ret := gogui.RunEventLoop()
	fmt.Println(ret)
}

