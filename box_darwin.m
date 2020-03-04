
#import "include/m_gui.h"
#import "util_darwin.h"

@interface iView: NSView
{
	iBox *box;
}
- (id) initWithBox: (iBox *) b;
- (void) drawRect: (NSRect) rect;
@end

@implementation iView

- (id) initWithBox: (iBox *) b
	{
		[super init];
		self->box = b;
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
	//FIXME implement
}

void HandleMouseDown(Box box, void (*fn)(void *, int), void *ctx)
{
	//FIXME implement
}

void HandleMouseUp(Box box, void (*fn)(void *, int), void *ctx)
{
	//FIXME implement
}

void HandleMouseEnter(Box box, void (*fn)(void *), void *ctx)
{
	//FIXME implement
}

void HandleMouseLeave(Box box, void (*fn)(void *), void *ctx)
{
	//FIXME implement
}

void HandleKeyDown(Box box, void (*fn)(void *, int), void *ctx)
{
	//FIXME implement
}

void HandleKeyUp(Box box, void (*fn)(void *, int), void *ctx)
{
	//FIXME implement
}

void HandleRedraw(Box box, void (*fn)(void *, Graphics), void *ctx)
{
	[(iBox *)box handleRedraw: fn withContext: ctx];
}

void ForceRedraw(Box box)
{
	//FIXME implement
}

