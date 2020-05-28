
#import "include/m_gui.h"
#import "util_darwin.h"

@implementation iWindow

- (id) initWithStyle: (int) mode
	{
		NSWindow *win;

		NSRect windowRect = [[NSScreen mainScreen] visibleFrame];

		NSUInteger winStyle = 0;
		if (mode & WINDOW_TITLED) winStyle |= NSWindowStyleMaskTitled;
		if (mode & WINDOW_CLOSABLE) winStyle |= NSWindowStyleMaskClosable;
		if (mode & WINDOW_SIZABLE) winStyle |= NSWindowStyleMaskMiniaturizable |
		                                       NSWindowStyleMaskResizable;

		windowRect = [NSWindow
			contentRectForFrameRect: windowRect
			styleMask: winStyle];

		win = [[NSWindow alloc]
			initWithContentRect:windowRect
			styleMask:winStyle
			backing:NSBackingStoreBuffered
			defer:NO];

		[win setAcceptsMouseMovedEvents: YES]; //FIXME is this needed?

		if (mode & WINDOW_TOPMOST)
		{
			[win setLevel: NSFloatingWindowLevel];
		}
		// FIXME change the content view to something else to get access to
		// drawRect, etc.

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

		return self;
	}

- (BOOL) windowShouldClose : (NSWindow *) sender
	{
		if (self->handle_close)
			self->handle_close(self->handle_close_ctx);

		return NO;
	}

- (void) windowWillClose : (NSNotification *) note
	{
	}

- (NSSize) windowWillResize: (NSWindow *) sender toSize: (NSSize) size
	{
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

		NSRect content = [NSWindow
			contentRectForFrameRect: rc
			styleMask: windowStyle];

		[self resizeChildren: content.size];
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

- (void) setTitle: (NSString *)txt
	{
		[self->window setTitle: txt];
	}

- (void) destroy
	{
		[window close];
		window = NULL;
		[self release];
	}
@end


Window CreateWindow(int mode)
{
	return (Window)[[iWindow alloc] initWithStyle: mode];
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

void SetTitle(Window window, const char *title)
{
	NSString *str = [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
	[(iWindow *)window setTitle: str];

}

