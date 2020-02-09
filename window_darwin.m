
#import "include/m_gui.h"
#import "util_darwin.h"


@implementation iWindow
- (id) init
	{
		NSWindow *win;

		NSRect windowRect = [[NSScreen mainScreen] visibleFrame];

		NSUInteger winStyle =
			NSWindowStyleMaskTitled |
			NSWindowStyleMaskClosable |
			NSWindowStyleMaskMiniaturizable |
			NSWindowStyleMaskResizable;

		windowRect = [NSWindow
			contentRectForFrameRect: windowRect
			styleMask: winStyle];

		win = [[NSWindow alloc]
			initWithContentRect:windowRect
			styleMask:winStyle
			backing:NSBackingStoreBuffered
			defer:NO];


		self = [super initWithView: [win contentView]];

		self->window = win;
		self->windowStyle = winStyle;
		self->left = Pos(0, 0);
		self->top = Pos(0, 0);
		self->right = Pos(100, 0);
		self->bottom = Pos(100, 0);
		self->menu = NULL;

		[self->window setDelegate: self];

		//FIXME learn about Activation, Key windows, Main Windows.
		//FIXME think about acceptsMouseMovedEvents

		return self;
	}

	//FIXME figure out how to get the window close message without autoclosing the window
- (BOOL) windowShouldClose : (NSWindow *) sender
	{
		return YES;
	}

- (void) windowWillClose : (NSNotification *) note
	{
		NSLog(@"FIXME will close");
		if (self->handle_close)
			self->handle_close(self->handle_close_ctx);
	}

- (NSSize) windowWillResize: (NSWindow *) sender toSize: (NSSize) size
	{
		NSLog(@"FIXME will resize");

		NSRect rc;
		rc.origin.x = 0;
		rc.origin.y = 0;
		rc.size = size;

		NSRect content = [NSWindow
			contentRectForFrameRect: rc
			styleMask: self->windowStyle];

		[self resizeChildren: content.size];
		return size;
	}

- (void) windowDidBecomeKey: (NSNotification *)notification
	{
		printf("FIXME became key\n");
		[NSApp setMainMenu: self->nsmenu];
	}

- (void) show
	{
		[self->window orderFrontRegardless];
	}

- (void) setPositionLeft: (POSITION)leftIn
		Top: (POSITION)topIn
		Right: (POSITION)rightIn
		Bottom: (POSITION)bottomIn
	{
		[super setPositionLeft: left Top: top Right: right Bottom: bottom];

		NSRect screen = [[NSScreen mainScreen] visibleFrame];
		NSRect rc = ComputePosition(screen, leftIn, topIn, rightIn, bottomIn);

		[self->window setFrame:rc display:true];
		[self resizeChildren: rc.size];
	}

- (void) handleClose: (void (*)(void *)) fn withContext: (void *)ctx
	{
		self->handle_close = fn;
		self->handle_close_ctx = ctx;
	}

- (void) setMenu: (iMenu *)m
	{
		self->menu = m;
		self->nsmenu = [m getNSMenu];
	}
@end


Window CreateWindow(void)
{
	return (Window)[[iWindow alloc] init];
}

Element WindowToElement(Window w)
{
	return (Element)w;
}

Box WindowToBox(Window w)
{
	return (Box)w;
}

void HandleClose(Window window, void (*fn)(void *), void *ctx)
{
	[(iWindow *)window handleClose: fn withContext: ctx];
}

void SetMenu(Window window, Menu menu)
{
	[(iWindow *)window setMenu: (iMenu *)menu];
}

