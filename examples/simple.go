
package main

import (
	"fmt"

	"github.com/jlassahn/gogui"
)


func closeHandler() {
	gogui.StopEventLoop(0)
}

func clickHandler() {
	fmt.Println("CLICK")
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

	button := gogui.CreateTextButton("Hello.")
	btnWidth := button.GetBestWidth()
	btnHeight := button.GetBestHeight()
	button.SetPosition(
		gogui.Pos(50, -btnWidth/2),
		gogui.Pos(50, -btnHeight),
		gogui.Pos(50, btnWidth/2),
		gogui.Pos(50, 0))
	button.HandleClick(clickHandler)
	window.AddChild(button)

	window.Show()

	ret := gogui.RunEventLoop()
	fmt.Println(ret)

}

