

#import "include/m_gui.h"
#import "util_darwin.h"


// FIXME use NSScrollView:documentVisibleRect to find scroll location
// FIXME use contentBox:scrollPoint to adjust the scroll location ?
// FIXME use NSScrollView:contentSize to find the size of the container
//       contentSize contains no new information
//       documentVisbleRect always gives the size of the scroll region
//       even if the contained view is smalller
// FIXME maybe override NSView:setFrameSize to react when the view resizes


// FIXME most of the methods inherited from Box should be redirected to the
// document Box

@implementation iScrollBox
- (id) init
	{
		self = [super init];
		if (!self)
			return self;

		self->view = [[NSScrollView alloc] init];
		self->contentBox = [[iBox alloc] init];

		NSColor *col = [NSColor
			colorWithCalibratedRed: 1.0 
			green: 1.0
			blue: 1.0
			alpha: 1.0];
		[(NSScrollView *)self->view setBackgroundColor: col];

		NSSize size;
		size.width = 1000;
		size.height = 1000;
		[self->contentBox->view setFrameSize: size];
		self->contentWidth = size.width;
		self->contentHeight = size.height;

		[(NSScrollView *)self->view setDocumentView: self->contentBox->view];
		[(NSScrollView *)self->view setHasVerticalScroller: YES];
		[(NSScrollView *)self->view setHasHorizontalScroller: YES];

		return self;
	}

- (void) handleRedraw: (void (*)(void *, Graphics)) fn withContext: (void *) ctx
	{
		[self->contentBox handleRedraw: fn withContext: ctx];
	}

- (void) handleMouseMove: (void (*)(void *, int, int)) fn withContext: (void *) ctx
	{
		[self->contentBox handleMouseMove: fn withContext: ctx];
	}

- (void) handleMouseDown: (void (*)(void *, int, int, int)) fn withContext: (void *) ctx
	{
		[self->contentBox handleMouseDown: fn withContext: ctx];
	}

- (void) handleMouseUp: (void (*)(void *, int, int, int)) fn withContext: (void *) ctx
	{
		[self->contentBox handleMouseUp: fn withContext: ctx];
	}

- (void) handleMouseEnter: (void (*)(void *)) fn withContext: (void *) ctx
	{
		[self->contentBox handleMouseEnter: fn withContext: ctx];
	}

- (void) handleMouseLeave: (void (*)(void *)) fn withContext: (void *) ctx
	{
		[self->contentBox handleMouseLeave: fn withContext: ctx];
	}

- (void) setContentWidth: (int)width height: (int)height
	{
		NSSize size;
		size.width = width;
		size.height = height;
		[self->contentBox->view setFrameSize: size];
		self->contentWidth = width;
		self->contentHeight = height;
	}

- (void) setBackgroundColor: (NSColor *)col
	{
		[(NSScrollView *)self->view setBackgroundColor: col];
	}

- (void) forceRedraw
	{
		printf("FORCE REDRAW SCROLLBOX\n");

		/*
		// FIXME
		NSRect rc = [(NSScrollView *)self->view documentVisibleRect];
		printf("documentVisibleRect = %f, %f, %f, %f\n",
				rc.origin.x, rc.origin.y, rc.size.width, rc.size.height);
		NSPoint pt;
		pt.x = 200;
		pt.y = 0;
		[self->contentBox->view scrollPoint: pt];
		*/

		[self->contentBox forceRedraw];
	}

- (int) visibleWidth
	{
		NSRect rc = [(NSScrollView *)self->view documentVisibleRect];
		return rc.size.width;
	}

- (int) visibleHeight
	{
		NSRect rc = [(NSScrollView *)self->view documentVisibleRect];
		return rc.size.height;
	}

- (int) visibleLeft
	{
		NSRect rc = [(NSScrollView *)self->view documentVisibleRect];
		return rc.origin.x;
	}

- (int) visibleTop
	{
		int y;
		NSRect rc = [(NSScrollView *)self->view documentVisibleRect];
		y = self->contentHeight - rc.origin.y - rc.size.height;
		if (y < 0)
			y = 0;
		return y;
	}

- (void) setVisibleLeft: (int)x Top: (int)y
	{
		NSPoint pt;
		NSRect rc = [(NSScrollView *)self->view documentVisibleRect];
		pt.x = x;
		pt.y = self->contentHeight - y - rc.size.height;
		[self->contentBox->view scrollPoint: pt];
	}

@end

ScrollBox CreateScrollBox(void)
{
	return (ScrollBox)[[iScrollBox alloc] init];
}

Element ScrollBoxToElement(ScrollBox b)
{
	return (Element)b;
}

Box ScrollBoxToBox(ScrollBox b)
{
	return (Box)b;
}

void SetContentSize(ScrollBox box, int width, int height)
{
	[(iScrollBox *)box setContentWidth: width height: height];
}

void SetBackgroundColor(ScrollBox box, COLOR color)
{
	NSColor *col = [NSColor
		colorWithCalibratedRed: color.r/255.0
		green: color.g/255.0
		blue: color.b/255.0
		alpha: color.a/255.0];

	[(iScrollBox *)box  setBackgroundColor: col];
}

int GetVisibleWidth(ScrollBox box)
{
	return [(iScrollBox *)box visibleWidth];
}

int GetVisibleHeight(ScrollBox box)
{
	return [(iScrollBox *)box visibleHeight];
}

int GetVisibleLeft(ScrollBox box)
{
	return [(iScrollBox *)box visibleLeft];
}

int GetVisibleTop(ScrollBox box)
{
	return [(iScrollBox *)box visibleTop];
}

void SetVisibleLeftTop(ScrollBox box, int left, int top)
{
	[(iScrollBox *)box setVisibleLeft: left Top: top];
}

