
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
		printf("got drawRect\n");
		NSRect frame = [self frame];
		NSRect bounds = [self bounds];
		printf("frame = %f %f %f %f\n", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
		printf("bounds = %f %f %f %f\n", bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);

		Graphics gfx = gfxStartRender( (int)bounds.size.width, (int)bounds.size.height);
		[self->box doRedraw: gfx];
		gfxEndRender(gfx);

		/* FIXME remove...

		//FIXME memory allocation?  release?
		// NSColor is always autoreleased, don't need to release it
		NSColor *fillcol = [NSColor colorWithCalibratedRed: 1.0 green: 0.0 blue: 0.0 alpha: 1.0];
		[fillcol setFill];

		NSColor *strokecol = [NSColor colorWithCalibratedRed: 0.0 green: 1.0 blue: 0.0 alpha: 1.0];
		[strokecol setStroke];
		NSRectFill(bounds);

		NSBezierPath *path = [NSBezierPath bezierPath];
		NSPoint pt;
		pt.x = 0;
		pt.y = 0;
		[path moveToPoint: pt];
		pt.x = 100;
		pt.y = 900;
		[path lineToPoint: pt];

		pt.x = 0;
		pt.y = 0;
		NSPoint pt1;
		NSPoint pt2;
		pt1.x = 100;
		pt1.y = 0;
		pt2.x = 100;
		pt2.y = 0;
		[path curveToPoint: pt controlPoint1:pt1 controlPoint2:pt2];

		[path setLineWidth: 10];
		[path stroke];

		NSString *str = @"Test Text";
		pt.x = 10;
		pt.y = 100;
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict autorelease];
		NSFont *font = [NSFont fontWithName: @"DejaVu Serif Italic" size:20.0];
		// FIXME font will be NULL if the name isn't found
		//printf("font = %p\n", font);
		[ dict setObject: font forKey: NSFontAttributeName ];
		NSColor *txtcol = [NSColor colorWithCalibratedRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0];
		[txtcol setFill];
		[str drawAtPoint: pt withAttributes: dict];
		*/
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
		printf("doRedraw fn=%p\n", self->handle_redraw);
		if (self->handle_redraw)
			self->handle_redraw(self->handle_redraw_ctx, gfx);
	}

- (void) addChild: (iElement *)child
	{
		NSLog(@"FIXME called addChild on base");

		child->parent = self;
		child->nextChild = self->children;
		self->children = child;

		NSRect rc = ComputePosition(
				[self->view frame],
				child->left,
				child->top,
				child->right,
				child->bottom);
		printf("box view = %p, child view = %p\n", self->view, child->view);
		printf("child position: %f %f %f %f\n", rc.origin.x, rc.origin.y, 
				rc.size.width, rc.size.height);


		[child->view setFrameOrigin: rc.origin];
		[child->view setFrameSize: rc.size];
		[self->view addSubview: child->view];
	}

- (void) handleRedraw: (void (*)(void *, Graphics)) fn withContext: (void *) ctx
	{
		printf("box handleRedraw call\n");
		self->handle_redraw = fn;
		self->handle_redraw_ctx = ctx;
	}

- (void) resizeChildren: (NSSize) size
	{
		NSLog(@"FIXME box resizeChildren");

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

