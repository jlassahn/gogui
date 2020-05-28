
#import <stdio.h>
#import "include/gui.h"
#import "glue.h"


// externs for Golang calls
extern bool gorouteAppOpenFile(const char *name);
extern void gorouteWindowClose(Window w);
extern void gorouteButtonClick(Button b);
extern void gorouteBoxRedraw(Box b, Graphics gfx);
extern void gorouteBoxMouseMove(Box b, int x, int y);
extern void gorouteBoxMouseDown(Box b, int x, int y, int btn);
extern void gorouteBoxMouseUp(Box b, int x, int y, int btn);
extern void gorouteBoxMouseEnter(Box b);
extern void gorouteBoxMouseLeave(Box b);
extern void gorouteItemSelect(MenuItem m);
extern void gorouteTextChange(TextInput t, const char *txt);


// static C redirect functions that can be called through pointers
static bool crouteAppOpenFile(void *ctx, const char *name)
{
	return gorouteAppOpenFile(name);
}

static void crouteWindowClose(void *ctx) { gorouteWindowClose((Window)ctx); }

static void crouteButtonClick(void *ctx) { gorouteButtonClick((Button)ctx); }

static void crouteBoxResize(void *ctx) {}
static void crouteBoxKeyDown(void *ctx, int ch, int flags) {}
static void crouteBoxKeyUp(void *ctx, int ch, int flags) {}

static void crouteBoxRedraw(void *ctx, Graphics gfx) {
	gorouteBoxRedraw((Box)ctx, gfx);
}

static void crouteBoxMouseMove(void *ctx, int x, int y) {
	gorouteBoxMouseMove((Box)ctx, x, y);
}

static void crouteBoxMouseDown(void *ctx, int x, int y, int btn) {
	gorouteBoxMouseDown((Box)ctx, x, y, btn);
}

static void crouteBoxMouseUp(void *ctx, int x, int y, int btn) {
	gorouteBoxMouseUp((Box)ctx, x, y, btn);
}

static void crouteBoxMouseEnter(void *ctx) {
	gorouteBoxMouseEnter((Box)ctx);
}

static void crouteBoxMouseLeave(void *ctx) {
	gorouteBoxMouseLeave((Box)ctx);
}

static void crouteItemSelect(void *ctx) {
	gorouteItemSelect((MenuItem)ctx);
}

static void crouteTextChange(void *ctx, const char *txt) {
	gorouteTextChange((TextInput)ctx, txt);
}

// setup functions called from Go
void SetGlobalCallbacks(void)
{
	HandleAppOpenFile(crouteAppOpenFile, NULL);
}

void SetWindowCallbacks(Window window)
{
	HandleClose(window, crouteWindowClose, window);
}

void SetButtonCallbacks(Button button)
{
	HandleClick(button, crouteButtonClick, button);
}

void SetBoxCallbacks(Box box)
{
	HandleResize(box, crouteBoxResize, box);
	HandleMouseMove(box, crouteBoxMouseMove, box);
	HandleMouseDown(box, crouteBoxMouseDown, box);
	HandleMouseUp(box, crouteBoxMouseUp, box);
	HandleMouseEnter(box, crouteBoxMouseEnter, box);
	HandleMouseLeave(box, crouteBoxMouseLeave, box);
	HandleKeyDown(box, crouteBoxKeyDown, box);
	HandleKeyUp(box, crouteBoxKeyUp, box);
	HandleRedraw(box, crouteBoxRedraw, box);
}

void SetScrollBoxCallbacks(ScrollBox b)
{
	//FIXME do we need to cast to Box?
	Box box = ScrollBoxToBox(b);
	HandleResize(box, crouteBoxResize, box);
	HandleMouseMove(box, crouteBoxMouseMove, box);
	HandleMouseDown(box, crouteBoxMouseDown, box);
	HandleMouseUp(box, crouteBoxMouseUp, box);
	HandleMouseEnter(box, crouteBoxMouseEnter, box);
	HandleMouseLeave(box, crouteBoxMouseLeave, box);
	HandleKeyDown(box, crouteBoxKeyDown, box);
	HandleKeyUp(box, crouteBoxKeyUp, box);
	HandleRedraw(box, crouteBoxRedraw, box);
}

void SetMenuCallbacks(MenuItem m)
{
	HandleMenuSelect(m, crouteItemSelect, m);
}

void SetTextCallbacks(TextInput t)
{
	HandleChange(t, crouteTextChange, t);
}

