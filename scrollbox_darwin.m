

#import "include/m_gui.h"
#import "util_darwin.h"


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

		//FIXME fake
		NSSize size;
		size.width = 1000;
		size.height = 1000;
		[self->contentBox->view setFrameSize: size];

		[(NSScrollView *)self->view setDocumentView: self->contentBox->view];
		[(NSScrollView *)self->view setHasVerticalScroller: YES];
		[(NSScrollView *)self->view setHasHorizontalScroller: YES];

		printf("scrollbar %p\n", [(NSScrollView *)self->view horizontalScroller]);
		return self;
	}

- (void) handleRedraw: (void (*)(void *, Graphics)) fn withContext: (void *) ctx
	{
		printf("scrollbox handleRedraw call\n");
		[self->contentBox handleRedraw: fn withContext: ctx];
	}

- (void) setContentWidth: (int)width height: (int)height
	{
		NSSize size;
		size.width = width;
		size.height = height;
		[self->contentBox->view setFrameSize: size];
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

