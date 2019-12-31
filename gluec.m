
#import <stdio.h>
#import "include/gui.h"
#import "glue.h"


// externs for Golang calls
extern void windowCloseCallback(Window w);
extern void buttonClickCallback(Button b);
extern void boxRedrawCallback(Box b, Graphics gfx);


// static C redirect functions that can be called through pointers
static void windowClose(void *ctx)
{
	windowCloseCallback((Window)ctx);
}

static void buttonClick(void *ctx)
{
	buttonClickCallback((Button)ctx);
}

static void boxResize(void *ctx) {}
static void boxMouseMove(void *ctx, int x, int y) {}
static void boxMouseDown(void *ctx, int btn) {}
static void boxMouseUp(void *ctx, int btn) {}
static void boxMouseEnter(void *ctx) {}
static void boxMouseLeave(void *ctx) {}
static void boxKeyDown(void *ctx, int kc) {}
static void boxKeyUp(void *ctx, int kc) {}

static void boxRedraw(void *ctx, Graphics gfx) {
	printf("static boxRedraw\n");
	boxRedrawCallback((Box)ctx, gfx);
}

// setup functions called from Go
void SetWindowCallbacks(Window window)
{
	HandleClose(window, windowClose, window);
}

void SetButtonCallbacks(Button button)
{
	HandleClick(button, buttonClick, button);
}

void SetBoxCallbacks(Box box)
{
	HandleResize(box, boxResize, box);
	HandleMouseMove(box, boxMouseMove, box);
	HandleMouseDown(box, boxMouseDown, box);
	HandleMouseUp(box, boxMouseUp, box);
	HandleMouseEnter(box, boxMouseEnter, box);
	HandleMouseLeave(box, boxMouseLeave, box);
	HandleKeyDown(box, boxKeyDown, box);
	HandleKeyUp(box, boxKeyUp, box);
	HandleRedraw(box, boxRedraw, box);
}

void SetScrollBoxCallbacks(ScrollBox b)
{
	//FIXME do we need to cast to Box?
	Box box = ScrollBoxToBox(b);
	HandleResize(box, boxResize, box);
	HandleMouseMove(box, boxMouseMove, box);
	HandleMouseDown(box, boxMouseDown, box);
	HandleMouseUp(box, boxMouseUp, box);
	HandleMouseEnter(box, boxMouseEnter, box);
	HandleMouseLeave(box, boxMouseLeave, box);
	HandleKeyDown(box, boxKeyDown, box);
	HandleKeyUp(box, boxKeyUp, box);
	HandleRedraw(box, boxRedraw, box);
}

