
#import "include/m_gui.h"
#import "util_darwin.h"

@interface iView: NSView
{
	iBox *box;
	NSTrackingArea *trackingArea;
}
- (id) initWithBox: (iBox *) b;
- (void) drawRect: (NSRect) rect;
@end

@implementation iView

- (id) initWithBox: (iBox *) b
	{
		[super init];
		self->box = b;

		NSTrackingAreaOptions opts;
		opts = NSTrackingMouseMoved
		     | NSTrackingMouseEnteredAndExited
		     | NSTrackingEnabledDuringMouseDrag
		     | NSTrackingInVisibleRect
		     | NSTrackingActiveAlways;
		NSRect rc;
		rc.origin.x = 0;
		rc.origin.y = 0;
		rc.size.width = 0;
		rc.size.height = 0;
		self->trackingArea = [[NSTrackingArea alloc]
			initWithRect: rc
				 options: opts
				   owner: self
			   userInfo: NULL];
		[self addTrackingArea: self->trackingArea];

		// FIXME release NSTrackingArea....
		return self;
	}

- (void)drawRect: (NSRect) rect
	{
		NSRect frame = [self frame];
		NSRect bounds = [self bounds];

		Graphics gfx = gfxStartRender( (int)bounds.size.width, (int)bounds.size.height);
		[self->box doRedraw: gfx];
		gfxEndRender(gfx);
	}

- (void) mouseDown: (NSEvent *)event
	{
		NSPoint pt = [self convertPoint: [event locationInWindow] fromView: NULL];
		NSRect frame = [self frame];
		pt.y = frame.size.height - pt.y;
		if (box->handle_mouse_down)
			box->handle_mouse_down(box->handle_mouse_down_ctx, pt.x, pt.y, 1);
	}

- (void) mouseUp: (NSEvent *)event
	{
		NSPoint pt = [self convertPoint: [event locationInWindow] fromView: NULL];
		NSRect frame = [self frame];
		pt.y = frame.size.height - pt.y;
		if (box->handle_mouse_up)
			box->handle_mouse_up(box->handle_mouse_up_ctx, pt.x, pt.y, 1);
	}

- (void) mouseMoved: (NSEvent *)event
	{
		NSPoint pt = [self convertPoint: [event locationInWindow] fromView: NULL];
		NSRect frame = [self frame];
		pt.y = frame.size.height - pt.y;
		if (box->handle_mouse_move)
			box->handle_mouse_move(box->handle_mouse_move_ctx, pt.x, pt.y);
	}

- (void) mouseDragged: (NSEvent *)event
	{
		NSPoint pt = [self convertPoint: [event locationInWindow] fromView: NULL];
		NSRect frame = [self frame];
		pt.y = frame.size.height - pt.y;
		if (box->handle_mouse_move)
			box->handle_mouse_move(box->handle_mouse_move_ctx, pt.x, pt.y);
	}

- (void) mouseEntered: (NSEvent *)event
	{
		if (box->handle_mouse_enter)
			box->handle_mouse_enter(box->handle_mouse_enter_ctx);
	}

- (void) mouseExited: (NSEvent *)event
	{
		if (box->handle_mouse_leave)
			box->handle_mouse_leave(box->handle_mouse_leave_ctx);
	}

- (BOOL) acceptsFirstResponder
	{
		return YES;
	}

- (void) keyDown: (NSEvent *)event
	{
		NSLog(@"GOT KEY DOWN %X %X [%@]", [event keyCode], [[event characters] characterAtIndex: 0], [event characters]);
	}

@end

@implementation iBox
- (id) init
	{
		self = [super init];
		if (!self)
			return self;

		iView *iview = [[iView alloc] initWithBox: self];
		self->view = iview;

		self->children = NULL;

		return self;
	}

- (id) initWithView: (NSView *)viewIn
	{
		self = [super init];
		if (!self)
			return self;

		self->view = viewIn;
		self->children = NULL;

		return self;
	}

- (void) doRedraw: (Graphics) gfx
	{
		if (self->handle_redraw)
			self->handle_redraw(self->handle_redraw_ctx, gfx);
	}

- (void) addChild: (iElement *)child
	{
		child->parent = self;
		child->nextChild = self->children;
		self->children = child;

		NSRect rc = ComputePosition(
				[self->view frame],
				child->left,
				child->top,
				child->right,
				child->bottom);

		[child->view setFrameOrigin: rc.origin];
		[child->view setFrameSize: rc.size];
		[self->view addSubview: child->view];
	}

- (void) handleRedraw: (void (*)(void *, Graphics)) fn withContext: (void *) ctx
	{
		self->handle_redraw = fn;
		self->handle_redraw_ctx = ctx;
	}

- (void) handleMouseMove: (void (*)(void *, int, int)) fn withContext: (void *) ctx
	{
		self->handle_mouse_move = fn;
		self->handle_mouse_move_ctx = ctx;
	}

- (void) handleMouseDown: (void (*)(void *, int, int, int)) fn withContext: (void *) ctx
	{
		self->handle_mouse_down = fn;
		self->handle_mouse_down_ctx = ctx;
	}

- (void) handleMouseUp: (void (*)(void *, int, int, int)) fn withContext: (void *) ctx
	{
		self->handle_mouse_up = fn;
		self->handle_mouse_up_ctx = ctx;
	}

- (void) handleMouseEnter: (void (*)(void *)) fn withContext: (void *) ctx
	{
		self->handle_mouse_enter = fn;
		self->handle_mouse_enter_ctx = ctx;
	}

- (void) handleMouseLeave: (void (*)(void *)) fn withContext: (void *) ctx
	{
		self->handle_mouse_leave = fn;
		self->handle_mouse_leave_ctx = ctx;
	}

- (void) resizeChildren: (NSSize) size
	{
		NSRect outer;
		outer.origin.x = 0;
		outer.origin.y = 0;
		outer.size = size;

		iElement *child;
		for (child = self->children; child != NULL; child = child->nextChild)
		{
			NSRect rc = ComputePosition(
					outer,
					child->left,
					child->top,
					child->right,
					child->bottom);

			[child->view setFrameOrigin: rc.origin];
			[child->view setFrameSize: rc.size];
			[child resizeChildren: rc.size];
		}
	}

- (void) forceRedraw
	{
		printf("FORCE REDRAW\n");
		[self->view  display];
	}
@end

Box CreateBox(void)
{
	return (Box)[[iBox alloc] init];
}

Element BoxToElement(Box b)
{
	return (Element)b;
}

void AddChild(Box box, Element child)
{
	[(iBox *)box addChild: (iElement *)child];
}

void RemoveChild(Box box, int n)
{
	//FIXME implement
}


int GetChildCount(Box box)
{
	//FIXME implement
	return 0;
}

Element GetChild(Box box, int n)
{
	//FIXME implement
	return NULL;
}

void HandleResize(Box box, void (*fn)(void *), void *ctx)
{
	//FIXME implement
}

void HandleMouseMove(Box box, void (*fn)(void *, int, int), void *ctx)
{
	[(iBox *)box handleMouseMove: fn withContext: ctx];
}

void HandleMouseDown(Box box, void (*fn)(void *, int, int, int), void *ctx)
{
	[(iBox *)box handleMouseDown: fn withContext: ctx];
}

void HandleMouseUp(Box box, void (*fn)(void *, int, int, int), void *ctx)
{
	[(iBox *)box handleMouseUp: fn withContext: ctx];
}

void HandleMouseEnter(Box box, void (*fn)(void *), void *ctx)
{
	[(iBox *)box handleMouseEnter: fn withContext: ctx];
}

void HandleMouseLeave(Box box, void (*fn)(void *), void *ctx)
{
	[(iBox *)box handleMouseLeave: fn withContext: ctx];
}

void HandleKeyDown(Box box, void (*fn)(void *, int, int), void *ctx)
{
	// unicode char, modifier flags
	//FIXME implement
}

void HandleKeyUp(Box box, void (*fn)(void *, int, int), void *ctx)
{
	//FIXME implement
}

void HandleRedraw(Box box, void (*fn)(void *, Graphics), void *ctx)
{
	[(iBox *)box handleRedraw: fn withContext: ctx];
}

void ForceRedraw(Box box)
{
	[(iBox *)box forceRedraw];
}

