
#import "Cocoa/Cocoa.h"
#import "include/gui.h"

@interface iElement : NSObject
{
	NSView *view;
	iElement *parent;
	iElement *nextChild;

	POSITION left;
	POSITION right;
	POSITION top;
	POSITION bottom;
}
- (void) setPositionLeft: (POSITION)left
		Top: (POSITION)top
		Right: (POSITION)right
		Bottom: (POSITION)bottom;

- (void) resizeChildren: (NSSize) size;
- (void) show;

@end

@interface iBox : iElement
{
	iElement *children;

	void (*handle_redraw)(void *ctx, Graphics gfx);
	void *handle_redraw_ctx;
}

- (id) initWithView: (NSView *) viewIn;
- (void) doRedraw: (Graphics) gfx;

- (void) addChild: (iElement *)child;
- (void) handleRedraw: (void (*)(void *, Graphics)) fn withContext: (void *) ctx;

@end

@interface iScrollBox : iBox
{
	iBox *contentBox;
}
- (void) setContentWidth: (int)width height: (int)height;
@end

@interface iWindow : iBox <NSWindowDelegate>
{
	NSWindow *window;
	NSUInteger windowStyle;

	void (*handle_close)(void *ctx);
	void *handle_close_ctx;
}
- (BOOL) windowShouldClose : (NSWindow *) sender;
- (void) windowWillClose : (NSNotification *) note;
- (NSSize) windowWillResize : (NSWindow *) sender toSize: (NSSize) size;

- (void) handleClose: (void (*)(void *)) fn withContext: (void *) ctx;
@end

@interface iButton : iElement
{
	NSButton *button;

	void (*handle_click)(void *ctx);
	void *handle_click_ctx;
}
- (id) initWithText: (NSString *) txt;
- (void) handleClick: (void (*)(void *)) fn withContext: (void *) ctx;
- (int) bestWidth;
- (int) bestHeight;
@end

@interface iMenu : NSObject
{ }
@end

@interface iMenuItem : iMenu
{ }
@end

@interface iImage : NSObject
{ }
@end


Graphics gfxStartRender(int width, int height);
void gfxEndRender(Graphics gfx);

